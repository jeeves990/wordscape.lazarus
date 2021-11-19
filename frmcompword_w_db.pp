unit frmCompWord_W_DB;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  fgl, SQLDB, WordDmod, ComCtrls, Contnrs;

type

  { TNodeWalker }

  TNodeWalker = class(TTreeView)
  private
		FOutList : TStringList;
		FCandidateList : TStringList;    // FPrepList is what is compared to database
    FTree: TTreeView;
    FTreeHeight, FTreeWidth : Integer;

		function GetFromDb : TStringList;
		function GetLimitClause : String;
    function get_top_level_node_into_array: Integer;
    // Deprecated: procedure walkParentSubTree(_node : TTreeNode; const howWide : Integer);

    procedure SetTree(const Value: TTreeView);
    procedure processTree;
		function walkParent_the_Tree(parent_node : TTreeNode;
                                         lvl : Integer = 0): Integer;
  public
    FParentNodeAra : array of TTreeNode;
    FLimitClause : String;
    property LimitClause : String read FLimitClause write FLimitClause;
    property Tree: TTreeView write SetTree;
    constructor Create(const aOwner: TComponent; tvu : TTreeView;
                        const height, width : Integer);
    destructor Destroy; override;
    property OutList : TStringList read FOutList;
    property PrepList : TStringList read FCandidateList;
    property TreeWidth : Integer read FTreeWidth write FTreeWidth;
    property TreeHeight : Integer read FTreeHeight write FTreeHeight;
  end;

  { TfmCompWords_W_DB }

  TfmCompWords_W_DB = class(TForm)
  private
    FWalker : TNodeWalker;
    FTreeHeight : Integer;
    FTreeWidth : Integer;
    FOut_list : TStringList;
  public
    constructor Create(const aOwner : TComponent; tvu : TTreeView;
                        const height, width : Integer); reintroduce;
    property Out_list : TStringList read FOut_list;
    destructor Destroy; override;
  end;

var
  fmCompWords_W_DB : TfmCompWords_W_DB;

implementation

{$R *.lfm}

var
  tst_file : TextFile;
  tst_file_name : String;

function build_tst_file_name : String;
var
  dt : String;
begin
  dt := DateTimeToStr(Now);
  Result := dt + '--Test_file.txt';
end;

{ TfmCompWords_W_DB }

constructor TfmCompWords_W_DB.Create(const aOwner : TComponent; tvu : TTreeView;
			const height, width : Integer);
{
    this is good for the initial tree, i.e., presume 'ROSES', height would
    be 4 ('ROSE', since duplicate chars are dropped) and width would be 5.
    Now, how do we handle the same presumed starting string but for
    combination of 3 and 4?
    Try: passing in the new treeview's, first of height = 4 and width = 3.
        Then, another treeview of height = 4 and width = 4.
}
begin
  inherited Create(aOwner);
  FTreeHeight := height;
  FTreeWidth := width;
  FWalker := TNodeWalker.Create(self, tvu, FTreeWidth, FTreeHeight);
  FOut_list := FWalker.FOutList;
end;

destructor TfmCompWords_W_DB.Destroy;
begin
  FWalker.Free;
	inherited Destroy;
end;

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

procedure TNodeWalker.processTree;
(*  function TNodeWalker.processTree
 *  this is the entry point, it is called from the constructor.
 *)
var
  idx, cnt, i : Integer;
  lenList : Integer;
begin
  if FTree.Items.Count < 5 then
    Exit;
  cnt := get_top_level_node_into_array;
  FCandidateList.Clear;
  lenList := Length(FParentNodeAra);

  for idx := 0 to Length(FParentNodeAra) -1 do
  {  iterate over the parent/top level nodes with a recursive
     process to get their sub tree values }
  begin

    walkParent_the_Tree(FParentNodeAra[idx]);

	end;

  FCandidateList.Sort;
	lenList := FCandidateList.Count;
  GetFromDb;     // database is called here to get the good words
end;

constructor TNodeWalker.Create(const aOwner : TComponent; tvu : TTreeView;
			const height, width : Integer);
begin
  FCandidateList := TStringList.Create;
  FOutList := TStringList.Create;
  FTree := tvu;
  FTreeHeight := height;
  FTreeWidth := width;
  if FTree.Items.Count < 5 then
    ShowMessage('TNodeWalker.Create: empty tree?');
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

function TNodeWalker.walkParent_the_Tree(parent_node : TTreeNode;
      lvl : Integer) : Integer;
var
  idx : Integer;
  work_node : TTreeNode;
  child_node_list : TObjectList;
begin
  child_node_list := TObjectList.Create;
  Inc(lvl);
  try
    work_node := parent_node.GetFirstChild;
    while Assigned(work_node) do
    begin
      child_node_list.Add(work_node);
      walkParent_the_Tree(work_node, lvl);
      work_node := parent_node.GetNextChild(work_node)
		end;
	finally
    child_node_list.Free;
    Result := lvl
	end;
end;

end.



//procedure TNodeWalker.walkParentSubTree(_node : TTreeNode;
//                                  const howWide : Integer);
//(**************** this is deprecated  ******************)
//  function get_these_children(node : TTreeNode;
//                                        const thisWide : Integer) : Integer;
//  var
//    work_node,          // node to work with
//    lastSib,            // last sibling of param: node
//    first_child_node : TTreeNode;  // 1st child of param: node
//    next_sib_node : TTreeNode;
//    cara : array of TTreeNode;     // candidate node array
//    idx, i, child_out_str_length : Integer;
//    child_out_str : String;
//  begin
//		Inc(Result);
//
//    { if there are no children, this is a leaf node }
//    first_child_node := node.GetFirstChild;
//    if not Assigned(first_child_node) then
//      Exit;
//
//    { to test for being a leaf???  NOTE: first_child_node.GetLastSibling
//      is NOT in the order of getting the candidate. }
//    if not Assigned(first_child_node.GetLastSibling) then
//      Exit;
//    lastSib := first_child_node.GetLastSibling;
//    if lastSib = first_child_node then  // if first = last, this is a leaf
//      Exit;
//
//    SetLength(cara, MAX_NODE_ARA_LEN);    // get nodes at this level into cara
//    cara[0] := first_child_node;
//    idx := 1;
//
//    work_node := first_child_node.GetFirstChild;
//
//    {  beginning with param: node, the head of cara  }
//    while Assigned(work_node) do
//    begin
//      cara[idx] := work_node;
//      next_sib_node := first_child_node.GetNextChild(work_node);
//      if not Assigned(next_sib_node) then
//        Break;
//      work_node := next_sib_node;
//      Inc(idx);
//		end;
//
//    SetLength(cara, idx +1);
//    child_out_str := node.Text;
//    {  THIS IS WHERE THE CANDIDATE STRINGS ARE CONCATENATED.  }
//    for i := 0 to Length(cara) -1 do
//		  child_out_str := Concat(child_out_str, cara[i].Text);
//		      //child_out_str := child_out_str + cara[i].Text;
//    child_out_str_length := Length(child_out_str);
//
//    { add candidate strings to FCandidateList, the list that is
//      compared to the database for validity  }
//    if FCandidateList.IndexOf(child_out_str) < 0 then
//      FCandidateList.Add(child_out_str);
//
//
//    // iteratively call get_these_children recursively to get children
//    for idx := 0 to Length(cara) -1 do
//    begin
//      if not Assigned(cara[idx]) then
//      begin
//        ShowMessage(Format('cara[%d] is not valid', [idx]));
//        Exit;
//      end;
//      get_these_children(cara[idx], thisWide);
//		end;
//	end;
//
//  { so, I've got all the nodes from the tree, what do I do with them? }
//
//begin
//  //while True do
//  begin
//  	get_these_children(_node, howWide);
//	end;
//
//end;



