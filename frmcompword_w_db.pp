unit frmCompWord_W_DB;

{$mode delphi}
//{$DEFINE DEBUG}
interface

uses
  Classes, SysUtils, Messages, Forms, Controls, Graphics, Dialogs, fgl, SQLDB,
  WordDmod, ComCtrls, Contnrs, LMessages, LCLIntf, ExtCtrls, LResources;

type

  TfmCompWords_W_DB = class(TForm)

  end;

  { TNodeWalker }

  TNodeWalker = class(TTreeView)
  private
    FFinalList: TStringList;     // FFinalList is good words from database
    FCandidateStream: TMemoryStream;
    FTree: TTreeView;
    FTreeHeight, FTreeWidth: integer;
    FRecurseCount: integer;
    FPassCount: integer;
    FGet3LetterWords: boolean;
    FParentHandle: uint64;

    procedure build_candidate_list(leafList: TList);
    //procedure build_candidate_list(leafList: TObjectList);
    function GetFromDb: TStringList;
    function GetLimitClause: string;
    function get_top_level_node_into_array: integer;
    procedure Timer_timeout(Sender: TObject);

    procedure SetTree(const Value: TTreeView);
    procedure processTree;
    procedure get_the_leaves(parent_node: TTreeNode; leaf_list: TList;
      lvl: integer = 0);
  public
    FParentNodeAra: array of TTreeNode;
    FLimitClause: string;
    FWork_str: string;

    constructor Create(const aOwner: TComponent);
    destructor Destroy; override;

    procedure setup_walker(tvu: TTreeView; const Height, Width: integer;
      const get_3_ltr_words: boolean);

    property LimitClause: string read FLimitClause write FLimitClause;
    property Tree: TTreeView write SetTree;
    property OutList: TStringList read FFinalList;
    //property PrepList: TStringList read FCandidateList;
    property TreeWidth: integer read FTreeWidth write FTreeWidth;
    property TreeHeight: integer read FTreeHeight write FTreeHeight;
    //property CandidateList: TStringList read FCandidateList write FCandidateList;
    property ParentHandle: uint64 read FParentHandle write FParentHandle;
  var
    ObjectListCallback: TObjectListCallbackMethod;
    LeafListCallback: TObjectListCallbackMethod;
    FLeafListCallback: TMemoryStreamCallbackMethod;
    StringListCallback: TStringListCallbackMethod;
    StringStreamCallback: TStringStreamCallbackMethod;
    CandidateCallback: TMemoryStreamCallbackMethod;
    MemoryStreamCallback: TMemoryStreamCallbackMethod;
    PgBarCallback: TPgBarCallbackMethod;
    CursorCallback: TIntegerCallbackMethod;
    StatusBarCallback: TStringCallbackMethod;
    FinalOutputCallback: TStringListCallbackMethod;
  end;

var
  {$IFDEF DEBUG}
  _fl_ : TextFile;
  {$ENDIF}
  dummy: boolean = True;

implementation

{$R *.lfm}

{ TNodeWalker }

const
  SQL_get_words_cnt = 'SET ' + #64 + 'cnt := 0';
  SQL_get_words_W_count = 'select (%scnt := %scnt +1) RowNbr, word from words ' +
    'CROSS JOIN (SELECT %scnt := 0) AS dummy  %s';
  SQL_get_words = 'select word from words %s';

{ TfmCompWords_W_DB }

procedure TNodeWalker.Timer_timeout(Sender: TObject);
var
  rec: TPgBarOps;
begin
  rec.arg := 0;
  rec.max := 0;
  rec.step := MAXINT;
  PgBarCallback(rec);
end;

function TNodeWalker.GetFromDb: TStringList;
{
    implemented as of 10/20/2021
    looks like getting words from database
    Caller is responsible for disposing of Result'ant TStringList.

    What is the maximum string length? FTreeWidth
    Then, need lists for all FTreeWidth character lengths
    and for, iteratively, Dec(FTreeWidth) down to character length
    of 3 combinations.
}
var
  word_param_array: array of string;


  procedure prepareWordParam_Array;
  var
    str, result_str: string;
    _ln: integer;

    function drop_comma(str: string): string;
    begin
      if str.EndsWith(COMMA) then
        Result := Copy(str, 1, Length(str) - 1)
      else
        Result := str;
    end;

  begin
    str := '';
    _ln := FTreeWidth;
    begin
      result_str := '';
      _ln := FCandidateStream.Size;
      if FCandidateStream.Size = 0 then
        raise Exception.Create('GetFromDb: Candidate Stream is not built');

      FCandidateStream.Seek(0, soBeginning);
      str := FCandidateStream.ReadAnsiString;
      while True do
      begin
        str := AnsiQuotedStr(str, DOUBLEQUOTE);
        result_str += LowerCase(str) + COMMA;
        _ln := Length(result_str);
        if Length(result_str) > 4900 then
        begin
          SetLength(word_param_array, Length(word_param_array) + 1);
          result_str := drop_comma(result_str);
          word_param_array[Length(word_param_array) - 1] := result_str;
          result_str := EmptyStr;
        end;
        if FCandidateStream.Position >= FCandidateStream.Size then
          Break;
        str := FCandidateStream.ReadAnsiString;
      end;

      if Length(result_str) > 0 then
      begin
        result_str := drop_comma(result_str);
        SetLength(word_param_array, Length(word_param_array) + 1);
        word_param_array[Length(word_param_array) - 1] := result_str;
      end;

    end;
  end;

var
  q: TSQLQuery;
  i, segSize: integer;
  str: ansistring;
  tx: TSQLTransaction;
  lst: TStringList;
begin
  SetLength(word_param_array, 0);
  prepareWordParam_Array;
  //FCandidateList.Clear;
  //FCandidateStream.Size := 0;
  lst := TStringList.Create;

  q := TSQLQuery.Create(self);
  q.DataBase := Word_Dmod.DbConn;
  q.DataBase.Open;

  try
    try
      q.SQL.Text := 'CALL sp_GET_GOOD_WORDS(:PARAMWORDLIST)';
      q.Prepare;

      try

        i := 0;
        while i < Length(word_param_array) do
        begin
          q.ParamByName('PARAMWORDLIST').AsString := word_param_array[i];
          q.Open;
          q.First;
          while not q.EOF do
          begin
            segSize := q.Fields.Count;
            str := q.Fields[0].AsString;
            lst.Add(str);
            q.Next;
          end;
          Inc(i);
        end;
        if lst.Count > 0 then
          FinalOutputCallback(lst);
      finally
        q.DataBase.Close(True);
        q.Free;
      end;
    except
      on Ex: Exception do
      begin
        ShowMessage(Format('TNodeWalker.GetFromDb exception: %s', [Ex.Message]));
      end;
    end;
  finally
    lst.Free;
    SetLength(word_param_array, 0);
  end;
end;

function TNodeWalker.GetLimitClause: string;
begin
  Result := FLimitClause;
end;

procedure TNodeWalker.SetTree(const Value: TTreeView);
begin
  FTree := Value;
end;

constructor TNodeWalker.Create(const aOwner: TComponent);
begin
  inherited Create(aOwner);
  //FCandidateList := TStringList.Create;
  FFinalList := TStringList.Create;

  //timer_timeout_callback := Timer_timeout;
end;

procedure TNodeWalker.setup_walker(tvu: TTreeView; const Height, Width: integer;
  const get_3_ltr_words: boolean);
begin
  //FCandidateList.Clear;
  FTree := tvu;
  FTreeHeight := Height;
  FTreeWidth := Width;
  FGet3LetterWords := get_3_ltr_words;
  if FTree.Items.Count < 5 then
    ShowMessage('TNodeWalker.Create: empty tree?');
  FParentHandle := Application.Handle;
  processTree;
end;

destructor TNodeWalker.Destroy;
begin
  //FCandidateList.Free;
  if Assigned(FCandidateStream) then
    FCandidateStream.Free;
  FFinalList.Free;
  inherited Destroy;
end;

const
  MAX_NODE_ARA_LEN = 15;

function TNodeWalker.get_top_level_node_into_array: integer;
(*  function TNodeWalker.get_top_level_node_into_array: Integer;
 *  gets the top level nodes of the tree/tvu into an array    *)
var
  i: integer;
  Node: TTreeNode;
begin
  SetLength(FParentNodeAra, MAX_NODE_ARA_LEN);  // initialize the array
  i := 0;
  Node := FTree.Items.GetFirstNode;
  while Assigned(Node) do
  begin
    FParentNodeAra[i] := Node;
    Inc(i);
    Node := Node.getNextSibling;
  end;
  SetLength(FParentNodeAra, i);    // set array length to reality
  Result := i;
end;

const
  _write_ln = 'Level: %d Text:%s%s';

procedure TNodeWalker.processTree;
(*  function TNodeWalker.processTree
 *  this is the entry point, it is called from the constructor.
 *  It bundles the top-level nodes into an array using the
 *  get_top_level_node_into_array method.
 *  Thence, iterates over that array, calling the worker method:
 *  get_the_leaves for each array node.
 *)
var
  idx, cnt, i: integer;
  lenList, leaf_count: integer;
  leaf_list: TList;
  msg: TMessage;
  _cursor: TCursor;
  rec: TPgBarOps;
const
  statBar_fmt_str = 'Processing %d element of top level node array';
begin
  _cursor := Cursor;
  CursorCallback(crHourGlass);
  StatusBarCallback('Just began processing final output');
  Application.ProcessMessages;
  if FTree.Items.Count < 5 then
    Exit;
  cnt := get_top_level_node_into_array;

  Get_temp_file_name;
  FCandidateStream := TMemoryStream.Create;
  leaf_list := TList.Create;
  lenList := Length(FParentNodeAra);

  FRecurseCount := 0;
  rec.arg := 0;
  rec.max := MAXINT;
  rec.step := 0;
  PgBarCallback(rec);

  try
    while idx < Length(FParentNodeAra) do
    {  iterate over the parent/top level nodes with a recursive
       process to get their sub tree values. E.g., if the user input "rosy",
       there would be four iteration of this block of code; one for "r",
       then "o", then "s" and finally "y"}
    begin
      rec.arg := idx;
      rec.max := 0;
      rec.step := 0;
      PgBarCallback(rec);
      StatusBarCallback(Format(statBar_fmt_str, [idx]));
      FPassCount := 0;
      get_the_leaves(FParentNodeAra[idx], leaf_list, 0);
      {  TODO: this is the place to yield the leaf_list  }
      //build_candidate_list(leaf_list);
      //leaf_list.Clear;
      //leaf_count := leaf_list.Count;
      Inc(FRecurseCount, FPassCount);
      Inc(idx);
    end;
    //lenList := leaf_list.Count;
    build_candidate_list(leaf_list);
  finally
    Inc(idx);

    rec.arg := idx;
    rec.max := 0;
    rec.step := 0;
    PgBarCallback(rec);

    FCandidateStream.Free;

    StatusBarCallback('Freeing heap memory. Get comfortable.');
    leaf_list.Free;
    CursorCallback(_cursor);
    StatusBarCallback('');
  end;
end;

procedure TNodeWalker.get_the_leaves(parent_node: TTreeNode;
  leaf_list: TList; lvl: integer);
(*   function TNodeWalker.get_the_leaves
*    parameters: parent_node : TTreeNode;
*                pOutStr : String;
*                lvl : Integer;  -- this is the level in the tree
*    objective: iterate over all the nodes at the current level.
*               Then, to recurse for each of these up the tree to
*               the leaves which will be placed in the FLeafList
*               class variable.
*)
var
  idx: integer;
  work_node, prev_node: TTreeNode;
begin
  Inc(FPassCount);
  Inc(lvl);
  try
    work_node := parent_node.GetFirstChild;
    while Assigned(work_node) do
    begin
      prev_node := work_node;
      get_the_leaves(work_node, leaf_list, lvl);
      work_node := parent_node.GetNextChild(work_node);
      {  if work_node is nil, prev_node is the leaf. }
      if (lvl = FTreeWidth - 1) and (not Assigned(work_node)) then
        leaf_list.Add(@prev_node);
    end;

    {$ifdef debug}
    WriteLn(_fl_, pOutStr);
    {$endif}
  finally
  end;
end;

procedure TNodeWalker.build_candidate_list(leafList : TList);
(*     procedure TNodeWalker.build_candidate_list
*      using the parameter leafList, which contains pointers to the
*      leaves of the main TTreeView, builds the candidate word list
*      by taking the parent, grand-parent... of the leafList nodes.
*      This is done for all candidate word lengths downto either 4,
*      the default, or 3 if the "Get three letter words" check box
*      on the main form is checked. For those string lengths less
*      than the length of the input string, by limiting the
*      parent, grand-parent... walk; this works because all possible
*      permutations are in the tree.
*)
  function build_candidate(leaf: TTreeNode; word_len: integer): string;
  begin
    Result := EmptyStr;
    while Assigned(leaf) do
    begin
      Result := leaf.Text + Result;
      if Length(Result) = word_len then
        Break;
      leaf := leaf.Parent;
    end;
  end;

var
  lf_ndx, iwordLen, minWordLen, len_ndx: integer;
  sz: QWord;
  leaf_list_count: integer;
  sCandidate: ansistring;
begin
  minWordLen := 4;
  if FGet3LetterWords then
    minWordLen := 3;
  iWordLen := FTreeWidth;
  lf_ndx := 0;
  len_ndx := FTreeWidth;    // len_ndx will be dec'd downto minWordLen

  //FCandidateStream := TFileStream.Create(Temp_file_name, fmCreate or fmOpenReadWrite);
  FCandidateStream.Clear;
  leaf_list_count := leafList.Count;
  try
    while lf_ndx < leafList.Count do
    begin
      while len_ndx >= minWordLen do
      begin

        sCandidate := build_candidate(TTreeNode(leafList[lf_ndx]), len_ndx);
        //if FCandidateList.IndexOf(sCandidate) < 0 then
        //    FCandidateList.Add(sCandidate);
        FCandidateStream.WriteAnsiString(sCandidate);
        Inc(lf_ndx);
        if lf_ndx = leafList.Count then
          Break;      // the inner loop
      end;
      CandidateCallback(FCandidateStream);
      GetFromDb;
      FCandidateStream.Clear;

      if len_ndx = minWordLen then
        Break;      // the outer loop

      Dec(len_ndx);
      lf_ndx := 0;
    end;
  finally
    if Assigned(FCandidateStream) then
      FCandidateStream.Clear;
  end;
end;

end.
