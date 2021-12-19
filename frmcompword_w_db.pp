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
    // FCandidateStream: TMemoryStream;
    FCandidateList : TStringList;
    FTree: TTreeView;
    FTreeHeight, FTreeWidth: integer;
    FRecurseCount: integer;
    FPassCount: integer;
    FGet3LetterWords: boolean;
    FOutputCount: Integer;

    function build_candidate_list(leafList : TObjectList) : TStringList;
    //procedure build_candidate_list(leafList: TObjectList);
    function Get_goodWords_from_qry : TStringList;
    function GetLimitClause: string;
    function get_top_level_node_into_array: integer;
    procedure Timer_timeout(Sender: TObject);

    procedure SetTree(const Value: TTreeView);
    procedure processTree;
    procedure get_the_leaves(parent_node : TTreeNode; leaf_list : TObjectList;
					lvl : integer);
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
    property TreeWidth: integer read FTreeWidth write FTreeWidth;
    property TreeHeight: integer read FTreeHeight write FTreeHeight;
    property OutputCount: Integer write FOutputCount;

  var
    ObjectListCallback: TObjectListCallbackMethod;
    LeafListCallback: TObjectListCallbackMethod;
    FLeafListCallback: TMemoryStreamCallbackMethod;
    StringListCallback: TStringListCallbackMethod;
    StringStreamCallback: TStringStreamCallbackMethod;
    CandidateCallback: TStringListCallbackMethod;
    MemoryStreamCallback: TMemoryStreamCallbackMethod;
    PgBarCallback: TPgBarCallbackMethod;
    CursorCallback: TIntegerCallbackMethod;
    StatusBarCallback: TStringCallbackMethod;
    FinalOutputCallback: TStringListCallbackMethod;
    FinalOutputCountCallBack : TIntegerCallbackMethod;
  end;

var
  {$IFDEF DEBUG}
  _fl_ : TextFile;
  {$ENDIF}
  dummy: boolean = True;

implementation

uses BufDataset, DB;

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

function TNodeWalker.Get_goodWords_from_qry : TStringList;
{
    implemented as of 10/20/2021
    looks like getting words from database
    Caller is responsible for disposing of Result'ant TStringList.

    What is the maximum string length? FTreeWidth
    Then, need lists for all FTreeWidth character lengths
    and for, iteratively, Dec(FTreeWidth) down to character length
    of 3 combinations.

    20211217: removing all the use of the database. Will be replaced
    by TMemDataset.

    The caller to this method builds the FCandidateStream; its nodes will
    be tested agains the WordBuffer and the non-words will be added to
    the stringlist.
}
    function build_parameter_string : String;
    var
      str : String;
      i : Integer;
    begin
      Result := '';
      i := 0;
      // build the parameter string for use by Word_Dmod.qry
      repeat
        str := FCandidateList[0];
        Result := Concat(Result, COMMA, DOUBLEQUOTE, str, DOUBLEQUOTE);

        Inc(i);
        if Assigned(StatusBarCallback) and (i mod 50 = 0) then
          StatusBarCallback(Format('Get_goodWords_from_bufDset: %d', [i]));

        FCandidateList.Delete(0);
        if FCandidateList.Count = 0 then
          Break;
    	until (Length(Result) > MAX_SQL_PARM_LEN -200);

      if Result[1] = COMMA then
          Result := Result[2..Length(Result)];
		end;

var
  i, lst_count: integer;
  str, str_words: ansistring;
  word_buf : TStringList;
  slst : TStringList;
begin
  //word_buf := Word_Dmod.WordBufList;
  Result := TStringList.Create;
  Result.Sorted := True;

  if FCandidateList.Count = 0 then
    raise Exception.Create('Get_goodWords_from_bufDset: Candidate Stream is not built');

  lst_count := FCandidateList.Count;
  while FCandidateList.Count > 0 do
    begin
      str_words := build_parameter_string;
      try
        if Word_Dmod.Open_word_db then
          begin
              slst := TStringList.Create;
              try
                 Word_Dmod.qry.ParamByName('words').AsString := str_words;
                 Word_Dmod.qry.Open;
                 while not Word_Dmod.qry.EOF do
                 begin
                     str := Word_Dmod.qry.Fields[0].AsString;
                     slst.CommaText := str;
                     Result.AddStrings(slst);
                     Word_Dmod.qry.Next;
								 end;
								 slst.Clear;
							except on Ex : Exception do
                 ShowMessage(Format('TNodeWalker.Get_goodWords_from_bufDset: %s',
                           [Ex.Message]));
							end;
					end;
				finally
          Word_Dmod.Close_word_db;
          slst.Free;
				end;

      if i = FCandidateList.Count then
          Break;
      str_words := '';
  end;
	{  the "good word" list is built, call method to populate output grid, here!  }
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
  FCandidateList := TStringList.Create;
  FFinalList := TStringList.Create;

  //timer_timeout_callback := Timer_timeout;
end;

procedure TNodeWalker.setup_walker(tvu: TTreeView; const Height, Width: integer;
  const get_3_ltr_words: boolean);
begin
  FCandidateList.Clear;
  FTree := tvu;
  FTreeHeight := Height;
  FTreeWidth := Width;
  FGet3LetterWords := get_3_ltr_words;
  if FTree.Items.Count < 5 then
    ShowMessage('TNodeWalker.Create: empty tree?');
  processTree;
  FinalOutputCountCallBack(0);
  if FOutputCount = 1 then
    ShowMessage('TNodeWalker.setup_walker: no good words found!');
end;

destructor TNodeWalker.Destroy;
begin
  FreeAndNil(FCandidateList);
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
  leaf_list: TObjectList;
  msg: TMessage;
  _cursor: TCursor;
  rec: TPgBarOps;
  word_list : TStringList;
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
  leaf_list := TObjectList.Create;
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

      Inc(FRecurseCount, FPassCount);
      Inc(idx);
    end;

    // handle the event where the database returns an empty set
    word_list := build_candidate_list(leaf_list);
    //if word_list.Count > 0 then
    //    FinalOutputCallback(word_list);
  finally
    Inc(idx);

    rec.arg := idx;
    rec.max := 0;
    rec.step := 0;
    PgBarCallback(rec);

    StatusBarCallback('Freeing heap memory. Get comfortable.');
    leaf_list.Free;
    CursorCallback(_cursor);
    StatusBarCallback('');
  end;
end;

procedure TNodeWalker.get_the_leaves(parent_node: TTreeNode;
  leaf_list: TObjectList; lvl: integer);
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
  s : String;
begin
  Inc(FPassCount);
  Inc(lvl);
  try
    work_node := parent_node.GetFirstChild;
    while Assigned(work_node) do
    begin
      s := work_node.Text;
      prev_node := work_node;
      get_the_leaves(work_node, leaf_list, lvl);
      work_node := parent_node.GetNextChild(work_node);
      {  if work_node is nil, prev_node is the leaf. }
      if (lvl = FTreeWidth - 1) and (not Assigned(work_node)) then
        leaf_list.Add(prev_node);
    end;

    {$ifdef debug}
    WriteLn(_fl_, pOutStr);
    {$endif}
  finally
  end;
end;

function TNodeWalker.build_candidate_list(leafList : TObjectList) : TStringList;
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
  function build_candidate(leaf: TTreeNode; word_len: integer): AnsiString;
  var
    s : ansistring;
    count : Integer;
  begin
    Result := '';
    try
        //while (leaf.Count <= word_len) and (leaf.Count > -1) do
        while Assigned(leaf) do
        //while Assigned(leaf.Text) do
        begin
          s := leaf.Text;
          if (s[1] in ALPHA_CHARS) then
            Result := leaf.Text + Result;
          if Length(Result) = word_len then
            Break;
          leaf := leaf.Parent;
          count := leaf.Count;
        end;

		except on Ex : Exception do
      ShowMessage(Format('function build_candidate exception: %s', [Ex.Message]));
		end;
	end;

var
  lf_ndx, iwordLen, minWordLen, len_ndx: integer;
  sz: QWord;
  leaf_list_count, db_result_count: integer;
  sCandidate, s: AnsiString;
begin
  minWordLen := 4;
  if FGet3LetterWords then
    minWordLen := 3;
  iWordLen := FTreeWidth;
  lf_ndx := 0;
  len_ndx := FTreeWidth;    // len_ndx will be dec'd downto minWordLen

  FCandidateList.Clear;
  leaf_list_count := leafList.Count;
  try
    while lf_ndx < leafList.Count do
    begin
      while len_ndx >= minWordLen do
      begin

        sCandidate := build_candidate(TTreeNode(leafList[lf_ndx]), len_ndx);
        if String(sCandidate) = '' then
          raise Exception.Create('TNodeWalker.build_candidate_list: '
                    + 'build_candidate returned an empty string.');

        // ensure FCandidateList is unique
        if FCandidateList.IndexOf(sCandidate) = -1 then
          FCandidateList.Add(sCandidate);

        Inc(lf_ndx);
        if lf_ndx = leafList.Count then
          Break;      // the inner loop
      end;

      // this is a call to TV.Populate_raw_words
      CandidateCallback(FCandidateList);
      Result := Get_goodWords_from_qry;
      db_result_count := Result.Count;
      if Result.Count > 0 then
        {  this may happen for a variety of reasons, e.g., user input
            all consonants. Now, to handle it.  }
        begin
            FinalOutputCallback(Result);
    			//ShowMessage('build_candidate_list: query has returned an empty set.');
          //Exit;
				end;
      FCandidateList.Clear;

      if len_ndx = minWordLen then
        Break;      // the outer loop

      Dec(len_ndx);
      lf_ndx := 0;
    end;
  finally
    FCandidateList.Clear;
  end;
end;

end.
