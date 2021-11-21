unit frmCompWord_W_DB;

{$mode delphi}
//{$DEFINE DEBUG}
interface

uses
  Classes, SysUtils, Messages, Forms, Controls, Graphics, Dialogs,
  fgl, SQLDB, WordDmod, ComCtrls, Contnrs, LMessages, LCLIntf;

type

  { TNodeWalker }

  TNodeWalker = class(TTreeView)
  private
		FOutList : TStringList;
		FCandidateList : TStringList; // FCandidateList is compared to database
    FTree: TTreeView;
    FTreeHeight, FTreeWidth : Integer;
    FRecurseCount : Integer;
    FPassCount : Integer;
    FGet3LetterWords : Boolean;
		FParentHandle : UInt64;

		procedure build_candidate_list(leafList : TObjectList);
  function GetFromDb : TStringList;
		function GetLimitClause : String;
    function get_top_level_node_into_array: Integer;

    procedure SetTree(const Value: TTreeView);
    procedure processTree;
		function get_the_leaves(parent_node : TTreeNode;
                               leafList : TObjectList;
                                    lvl : Integer = 0): Integer;
  public
    FParentNodeAra : array of TTreeNode;
    FLimitClause : String;
    FWork_str : String;

    property LimitClause : String read FLimitClause write FLimitClause;
    property Tree: TTreeView write SetTree;
    constructor Create(const aOwner: TComponent; tvu : TTreeView;
              const height, width : Integer;
              const get_3_ltr_words : Boolean);
    destructor Destroy; override;
    property OutList : TStringList read FOutList;
    property PrepList : TStringList read FCandidateList;
    property TreeWidth : Integer read FTreeWidth write FTreeWidth;
    property TreeHeight : Integer read FTreeHeight write FTreeHeight;
    property CandidateList : TStringList read FCandidateList
                                        write FCandidateList;
    property ParentHandle : UInt64 read FParentHandle write FParentHandle;
  var
    Callback : TCallbackMethod;
  end;

var
  {$IFDEF DEBUG}
  _fl_ : TextFile;
  {$ENDIF}
  dummy : Boolean = True;

implementation

{$R *.lfm}

{ TNodeWalker }

const
SQL_get_words_cnt = 'SET ' + #64 + 'cnt := 0';
SQL_get_words_W_count = 'select (%scnt := %scnt +1) RowNbr, word from words '
  + 'CROSS JOIN (SELECT %scnt := 0) AS dummy  %s';
SQL_get_words = 'select word from words %s';

function TNodeWalker.GetFromDb : TStringList;
{
    implemented as of 10/20/2021
    looks like getting words from database
    Caller is responsible for disposing of Result'ant TStringList.

    What is the maximum string length? FTreeWidth
    Then, need lists for all FTreeWidth character lengths
    and for, iteratively, Dec(FTreeWidth) down to character length
    of 3 combinations.
}
  function prepareWordParam : String;
  var
    str, result_str : String;
    _ln : Integer;
  begin
    str := '';
    _ln := FTreeWidth;
    begin
      result_str := '';
      _ln := FCandidateList.Count;
      if FCandidateList.Count = 0 then
        raise Exception.Create('GetFromDb: Candidate list is not built');
      while (FCandidateList.Count > 0) and (Length(str) < 1000) do
      begin
        str := FCandidateList[0];
        str := AnsiQuotedStr(str, DOUBLEQUOTE);
        result_str += LowerCase(str) + COMMA;
        FCandidateList.Delete(0);
			end;
      if result_str.EndsWith(COMMA) then
        Result := Copy(result_str, 1, Length(result_str) -1)
      else
        Result := result_str;
		end;
	end;

var
  q: TSQLQuery;
  i, segSize: Integer;
  s: string;
  tx : TSQLTransaction;
begin
  q := TSQLQuery.Create(self);
  q.DataBase := Word_Dmod.DbConn;
  q.DataBase.Open;

  try

    q.SQL.Text := 'CALL sp_GET_GOOD_WORDS(:PARAMWORDLIST)';
    q.Prepare;

    begin
      s := prepareWordParam;
      if s = '' then
        raise Exception.Create('TreeWalker did not work?');
      q.ParamByName('PARAMWORDLIST').AsString := s;
      q.Open;
      q.First;
      while not q.EOF do
      begin
        segSize := q.Fields.Count;
        s := q.Fields[0].AsString;
        FOutList.Add(s);
        q.Next;
			end;
		end;
  finally
    q.DataBase.Close(True);
    q.Free;
  end;
end;

function TNodeWalker.GetLimitClause : String;
begin
  Result := FLimitClause;
end;

procedure TNodeWalker.SetTree(const Value : TTreeView);
begin
  FTree := Value;
end;

constructor TNodeWalker.Create(const aOwner : TComponent; tvu : TTreeView;
			                  const height, width : Integer;
                        const get_3_ltr_words : Boolean);
begin
  inherited Create(aOwner);
  FCandidateList := TStringList.Create;
  FOutList := TStringList.Create;
  FTree := tvu;
  FTreeHeight := height;
  FTreeWidth := width;
  FGet3LetterWords := get_3_ltr_words;
  if FTree.Items.Count < 5 then
    ShowMessage('TNodeWalker.Create: empty tree?');
  FParentHandle := Application.Handle;
  processTree;
end;

destructor TNodeWalker.Destroy;
begin
  FCandidateList.Free;
  FOutList.Free;
	inherited Destroy;
end;

const
MAX_NODE_ARA_LEN = 15;

function TNodeWalker.get_top_level_node_into_array: Integer;
(*  function TNodeWalker.get_top_level_node_into_array: Integer;
 *  gets the top level nodes of the tree/tvu into an array    *)
var
  i : Integer;
  Node, anode: TTreeNode;
  s : String;
begin
  SetLength(FParentNodeAra, MAX_NODE_ARA_LEN);  // initialize the array
	i := 0;
	Node:= FTree.Items.GetFirstNode;
	while Assigned(Node) do
  begin
    FParentNodeAra[i] := Node;
    s := Node.Text;
	  Inc(i);
	  Node  := Node.getNextSibling;
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
  idx, cnt, i : Integer;
  lenList : Integer;
  leaf_list : TObjectList;
  msg : TMessage;
begin
  if FTree.Items.Count < 5 then
    Exit;
  cnt := get_top_level_node_into_array;
  FCandidateList.Clear;
  lenList := Length(FParentNodeAra);

  FRecurseCount := 0;
  leaf_list := TObjectList.Create();
  try
    for idx := 0 to Length(FParentNodeAra) -1 do
    {  iterate over the parent/top level nodes with a recursive
       process to get their sub tree values }
    begin
      FPassCount := 0;
      get_the_leaves(FParentNodeAra[idx], leaf_list, 0);
      Inc(FRecurseCount, FPassCount);
		end;
    lenList := leaf_list.Count;
    build_candidate_list(leaf_list);
    {  pass the leaf_list to the main window in WordScapes  }
    msg.msg := LM_POP_RAW_WORDS;
    msg.wParam := PtrUInt(leaf_list);
    Callback(msg);
    //SendMessage(Application.Handle, LM_POP_RAW_WORDS, PtrUInt(leaf_list), 0);
	finally
    leaf_list.Free;
  end;
end;

function TNodeWalker.get_the_leaves(parent_node : TTreeNode;
                                       leafList : TObjectList;
                                            lvl : Integer) : Integer;
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
  idx, ndx : Integer;
  work_node, prev_node : TTreeNode;

begin
  Inc(FPassCount);
  Inc(lvl);
  try
    work_node := parent_node.GetFirstChild;
    while Assigned(work_node) do
    begin
      prev_node := work_node;
      //get_one_pass(work_node);  // , pOutStr);
      ndx := work_node.Index;
      get_the_leaves(work_node, leafList, lvl);
      work_node := parent_node.GetNextChild(work_node);
      {  if work_node is nil, prev_node is the leaf. }
      if (lvl = FTreeWidth -1) and (not Assigned(work_node)) then
         leafList.Add(prev_node);
		end;

    {$ifdef debug}
    WriteLn(_fl_, pOutStr);
    {$endif}
	finally
	end;
end;

procedure TNodeWalker.build_candidate_list(leafList : TObjectList);
(*     procedure TNodeWalker.build_candidate_list
*      using the parameter leadList, which contains pointers to the
*      leaves of the main TTreeView, builds the candidate word list
*      by taking the parent, grand-parent... of the leafList nodes.
*      This is done for all candidate word lengths downto either 4,
*      the default, or 3 if the "Get three letter words" check box
*      on the main form is checked. For those string lengths less
*      than the length of the input string, by limiting the
*      parent, grand-parent... walk; this works because all possible
*      permutations are in the tree.
*)
  function build_candidate(leaf : TTreeNode; word_len : Integer): String;
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
  lf_ndx, iwordLen, minWordLen,
    len_ndx : Integer;
  sCandidate : String;
begin
  minWordLen := 4;
  if FGet3LetterWords then
     minWordLen := 3;
  iWordLen := FTreeWidth;
  lf_ndx := 0;
  len_ndx := FTreeWidth;    // len_ndx will be dec'd downto minWordLen
  FCandidateList.Clear;
  while lf_ndx < leafList.Count do
  begin
    while len_ndx >= minWordLen do
		  begin
		    sCandidate := build_candidate(TTreeNode(leafList[lf_ndx]), len_ndx);
		    FCandidateList.Add(sCandidate);
		    Inc(lf_ndx);
        if lf_ndx = leafList.Count then
           Break;      // the inner loop
	    end;
    if len_ndx = minWordLen then
       Break;      // the outer loop
    Dec(len_ndx);
    lf_ndx := 0;
	end;
end;

end.



{ TfmCompWords_W_DB }

TfmCompWords_W_DB = class(TForm)
private
  FWalker : TNodeWalker;
  FTreeHeight : Integer;
  FTreeWidth : Integer;
  FOut_list : TStringList;
  FParentHandle : THandle;
public
  constructor Create(const aOwner : TComponent; tvu : TTreeView;
                         const height, width : Integer;
                          const get3LtrWords : Boolean;
                               parent_handle : THandle); reintroduce;
  property Out_list : TStringList read FOut_list;
  destructor Destroy; override;
  property ParentHandle : THandle read FParentHandle write FParentHandle;
end;

{ TfmCompWords_W_DB }

constructor TfmCompWords_W_DB.Create(const aOwner : TComponent; tvu : TTreeView;
			const height, width : Integer; const get3LtrWords : Boolean;
      parent_handle : THandle);
(*
 *   //this is good for the initial tree, i.e., presume 'ROSES', height would
 *   //be 4 ('ROSE', since duplicate chars are dropped) and width would be 5.
 *   //Now, how do we handle the same presumed starting string but for
 *   //combination of 3 and 4?
 *
 *   DONE: HANDLED IN build_candidate_list
 *
 *   //Try: passing in the new treeview's, first of height = 4 and width = 3.
 *   //    Then, another treeview of height = 4 and width = 4.
 *)
begin
  inherited Create(aOwner);
  ;
  FTreeHeight := height;
  FTreeWidth := width;
  FWalker := TNodeWalker.Create(self, tvu, FTreeWidth,
                                                FTreeHeight, get3LtrWords);
  FOut_list := FWalker.FOutList;
end;

destructor TfmCompWords_W_DB.Destroy;
begin
  FWalker.Free;
	inherited Destroy;
end;


