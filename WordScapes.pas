unit WordScapes;

{$MODE Delphi}
{$DEFINE SEEWORDS}

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Forms,
  frmCompWord_W_DB, WordscapeHelper,
  WordDmod, SQLDB, ActnList, GetParams4Read,// Contnrs,
  Menus, Grids, MaskEdit, XMLPropStorage, Buttons;

type
  TCallers = (get_started, build_tree, node_walker, compare_to_db);

  { TV }

  TV = class(TForm)
    ActBldSubTrees: TAction;
    ActBldTree: TAction;
    ActBuildWordList: TAction;
    actClose: TAction;
    ActCmpWords_W_Db: TAction;
    ActEnableMnMnu: TAction;
    ActGetFile: TAction;
    ActGetStarted: TAction;
    ActionTestCalculate: TAction;
    ActLoadSelection: TAction;
    ActLoadWords: TAction;
    ActLst4WordScapes: TActionList;
    ActNodeWalker: TAction;
    btmPanelTab2: TPanel;
    BtnBuildTree: TBitBtn;
    btnTestingCalculate: TBitBtn;
    Buildtree1: TMenuItem;
    capCombinationCount: TLabel;
    capIterator: TLabel;
    capLvl: TLabel;
    capMaxCount: TLabel;
    capPermutationCount: TLabel;
    capPermutationExCount: TLabel;
    capRootChar: TLabel;
    cap_enterLetters: TLabel;
    cap_output_grid: TLabel;
    cap_words_memo: TLabel;
    CC1: TMenuItem;
    ckb_take_threes: TCheckBox;
    edCharString: TEdit;
    edMaxCount: TEdit;
    edMinLen: TMaskEdit;
    edSetSize: TMaskEdit;
    edTakenAt: TMaskEdit;
    edTvuItmCount: TEdit;
    File1: TMenuItem;
    imgList: TImageList;
    lblCombinationCount: TLabel;
    lblFinalCount: TLabel;
    lblIteratorI: TLabel;
    lblLvl: TLabel;
    lblMinLen: TLabel;
    lblPermutationCount: TLabel;
    lblPermutationExCount: TLabel;
    lblRootChar: TLabel;
    lblSetSize: TLabel;
    lblTakeAt: TLabel;
    lblTakeAt1: TLabel;
    lblTvuItemCount: TLabel;
    MenuItem1: TMenuItem;
    MenuItem6: TMenuItem;
    mnMnu: TMainMenu;
    mnuItm_bld_sub_trees: TMenuItem;
    mnuItm_bld_tree: TMenuItem;
    mnuItm_expose_test_tab: TMenuItem;
    mnuItm_node_walker: TMenuItem;
    mnuItm_ps_the_tree: TMenuItem;
    mnuItm_ps_word_list: TMenuItem;
    mnuPsOptions: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Panel1: TPanel;
    pgBar: TProgressBar;
    pgCtrl: TPageControl;
    pgCtrl_ex: TPageControl;
    pnlTesting: TPanel;
    pnlTvu: TPanel;
    pnlTvuTop: TPanel;
    pnl_for_output_grid: TPanel;
    pnl_for_words_memo: TPanel;
    pnl_words_grid: TPanel;
    Popup: TPopupMenu;
    Processwordlist1: TMenuItem;
    raw_words_mmo: TMemo;
    sGrid_output: TStringGrid;
    sgrid_raw_words: TStringGrid;
    dbop_splitter: TSplitter;
    tvu_splitter: TSplitter;
    statusBar: TStatusBar;
    tb_build_tree: TToolButton;
    tb_ps_sub_trees: TToolButton;
    tb_ps_tree: TToolButton;
    toolBar_main: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    topPanelTab2: TPanel;
    tsDbOps: TTabSheet;
    tsFor3s: TTabSheet;
    tsMain: TTabSheet;
    tsTesting: TTabSheet;
    tvu: TTreeView;
    MainPropStorage: TXMLPropStorage;

    procedure ActBldSubTreesExecute(Sender: TObject);
    procedure ActBldTreeExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure ActionTestCalculateExecute(Sender: TObject);
    procedure ActLoadSelectionExecute(Sender: TObject);
    procedure ActLoadWordsExecute(Sender: TObject);
    procedure ActNodeWalkerExecute(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure edCharStringKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edCharStringKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MaskEditEnter(Sender: TObject);
    procedure mnuItm_expose_test_tabClick(Sender: TObject);
    procedure tvuChange(Sender: TObject; Node: TTreeNode);

  private
    FAraOfTvu: array of TTreeView;
    FFileName: TFileName;
    FLst4Words: TStringList;
    FMinLen: integer;
    FNodeWalker: TNodeWalker;
    FStartString: string;
    //FTreeHeight: integer;
    FTreeWidth: integer;
    F_Handle: uint64;
    FNodeWalker_rowCount_array: array of integer;

    function AddThisLevelsChildren(_str: string; Parent: TTreeNode): TTreeNode;
    procedure CursorFeedback(arg_cursor: integer);
    function ExtractSubTree(toLevel: integer): TTreeView;
    procedure Final_output(slst: TStringList);
    function find_column_of_grid(_len: integer; grid: TStringGrid): integer;
    function GetLmtClause: utf8string;
    function GetTreeWidth: integer;
    function Get_good_words_from_DB(const parm_str: string;
      var slst: TStringList): boolean;
    function ParseLmtClause({var startAt, howMany: integer}): boolean;

    procedure AddTheChildren(Str: string; lvl: integer; ParmNode: TTreeNode);
    procedure buildATree(tree: TTreeView; const toLevel: integer);
    procedure BuildCombinationTree(ltrCount: integer);
    procedure freeFAraOfTvu;
    procedure FrmPsWordsFormClose(Sender: TObject);
    procedure PgBarFeedback(rec: TPgBarOps);
    procedure Populate_output_grid(lst: TStringList);
    //procedure Populate_output_grid(strm: TFileStream);

    procedure Populate_raw_words(strm: TMemoryStream);
    //procedure Populate_raw_words(lst: TStringList);

    procedure SetLmtClause(AValue: utf8string);
    procedure SetStartString(AValue: string);
    procedure setup_output_list_grid;
    procedure setup_raw_list_grid;
    procedure setup_pgBar(max: integer = 0);
    procedure set_actions(Sender: TCallers);
    procedure StatusBarFeedback(_str: string);
    procedure unset_actions_enabled;
    procedure UpdateProgressBar;

  public
    property FLmtClause: utf8string read GetLmtClause write SetLmtClause;
    property TreeWidth: integer read GetTreeWidth write FTreeWidth;
    property StartString: string read FStartString write SetStartString;
    property _handle: uint64 read F_Handle write F_Handle;

  var
    MainCallBack: TCallbackMethod;
  end;

var
  V: TV;

implementation

{$R *.lfm}

uses Character;

const
  First = 1;
  NEW_TREE_PREFIX = 'tvu_';
//Grid_title_raw = 'Raw words (permutations)';
//Grid_title_final = 'Good words';


procedure TV.edCharStringKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ActBldTree.Execute;
    Exit;
  end;
end;


procedure TV.SetLmtClause(AValue: utf8string);
begin
  FLmtClause := AValue;
end;

procedure TV.SetStartString(AValue: string);
begin
  if FStartString = AValue then Exit;
  FStartString := AValue;
end;

procedure TV.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TV.freeFAraOfTvu;
var
  i: integer;
begin
  for i := 0 to Length(FAraOfTvu) - 1 do
    FAraOfTvu[i].Free;
  SetLength(FAraOfTvu, 0);
end;

procedure TV.FrmPsWordsFormClose(Sender: TObject);
begin
  freeFAraOfTvu;
end;

procedure TV.set_actions(Sender: TCallers);
begin
  if Sender = get_started then
  begin
    ActBldTree.Enabled := True;
    ActNodeWalker.Enabled := False;
    ActCmpWords_W_Db.Enabled := False;
  end
  else if Sender = build_tree then
  begin
    ActNodeWalker.Enabled := True;
    ActCmpWords_W_Db.Enabled := False;
  end
  else if Sender = node_walker then
  begin
    ActNodeWalker.Enabled := False;
    ActCmpWords_W_Db.Enabled := True;
  end
  else if Sender = compare_to_db then
  begin
    ActNodeWalker.Enabled := False;
    ActCmpWords_W_Db.Enabled := False;
  end;
end;

procedure TV.unset_actions_enabled;
begin
  //tb_ps_tree.Enabled := False;
  //tb_ps_sub_trees.Enabled := False;

  ActBldTree.Enabled := True;
  ActCmpWords_W_Db.Enabled := False;
  ActBldSubTrees.Enabled := False;
end;

procedure TV.ActBldTreeExecute(Sender: TObject);
(*  procedure TV.ActBldTreeExecute(Sender: TObject);
    caller is TToolButton.tb_build_tree.
    objective is to populate the tvu TTreeview (main)  *)
var
  end_row: integer;
  zone_set: TGridZoneSet;
  _cursor: TCursor;
begin
  _cursor := Cursor;
  CursorFeedback(crHourGlass);
  Clear_string_grid(sgrid_raw_words, 1, 1, 0);
  Application.ProcessMessages;
  try
    if Length(edCharString.Text) > 8 then
    begin
      ShowMessage('Length of characters entered must not exceed 8');
      edCharString.SetFocus;
      Exit;
    end;
    if sgrid_raw_words.RowCount = 1 then
      end_row := 0
    else
      end_row := sgrid_raw_words.RowCount - 1;
    sgrid_raw_words.Clear;

    FStartString := UpperCase(edCharString.Text);
    buildATree(tvu, Length(FStartString));
    set_actions(build_tree);
  finally
    CursorFeedback(_cursor);
  end;
end;

procedure TV.ActNodeWalkerExecute(Sender: TObject);
var
  _tree_height: integer;
begin
  {  sgrid_raw_words is reconfigured on each call to this method.  }
  setup_raw_list_grid;
  Application.ProcessMessages;
  _tree_height := Length(CleanDuplicateChars(FStartString));
  FNodeWalker.setup_walker(tvu, _tree_height, FTreeWidth, ckb_take_threes.Checked);
  try

  finally
    set_actions(node_walker);
    pgBar.Visible := False;
  end;
end;

procedure TV.setup_raw_list_grid;
(*
 *  procedure TV.setup_raw_list_grid;
 *  Set the columns for the raw list elements. If ckb_take_threes.Checked,
 *  there will be Length(edCharString.Text) -2 columns. Otherwise, there
 *  will be Length(edCharString.Text) -3 columns.
 *)
const
  ColHeading = 'Length: %d';
var
  i, col_cnt, ndx, col_cnt_diff: integer;
  heading_str: string;
  grid: TStringGrid;
begin
  grid := sgrid_raw_words;
  Clear_string_grid(grid, 1, 1, 0, 1);
  grid.ColCount := 0;
  col_cnt_diff := 3;
  if ckb_take_threes.Checked then
    col_cnt_diff := 2;

  col_cnt := Length(edCharString.Text) - col_cnt_diff;
  Inc(col_cnt_diff);
  //ndx :=
  i := 0;
  while i < col_cnt do
  begin
    heading_str := Format(ColHeading, [i + col_cnt_diff]);
    grid.ColCount := grid.ColCount + 1;
    grid.Cells[i, 0] := heading_str;
    grid.Objects[i, 0] := TObject(i + col_cnt_diff);
    Inc(i);
  end;
  SetLength(FNodeWalker_rowCount_array, grid.ColCount);
  for i := 0 to grid.ColCount - 1 do
    FNodeWalker_rowCount_array[i] := 0;
  setup_output_list_grid;
end;

procedure TV.setup_output_list_grid;
var
  i_col, col_cnt, ndx, col_cnt_diff: integer;
  heading_str: string;
  grid, raw_grid: TStringGrid;
begin
  grid := sGrid_output;
  raw_grid := sgrid_raw_words;
  grid.Clear;
  grid.ColCount := raw_grid.ColCount;
  grid.RowCount := raw_grid.RowCount;
  for i_col := 0 to raw_grid.ColCount - 1 do
  begin
    grid.Objects[i_col, 0] := raw_grid.Objects[i_col, 0];
    grid.Cells[i_col, 0] := raw_grid.Cells[i_col, 0];
  end;
end;

function TV.find_column_of_grid(_len: integer; grid: TStringGrid): integer;
(*
 *    function find_column_of_grid searches for the column that
 *    will receive _len letter words by searching iteratively
 *    through sgrid_raw_words.Objects for an object made like
 *    TObject(string length).
 *)
var
  i, iValue: integer;
begin
  Result := -1;
  i := 0;
  while i < grid.ColCount do
  begin
    iValue := integer(grid.Objects[i, 0]);
    if grid.Objects[i, 0] = TObject(_len) then
      Break;
    Inc(i);
  end;
  if i = grid.ColCount then
    raise Exception.Create('TV.Populate_raw_words.find_column_of_grid ' +
      'exception: column not found.');
  Result := i;
end;

procedure TV.Populate_raw_words(strm: TMemoryStream);
(*
 *  procedure TV.Populate_raw_words:
 *  the strm's of words are passed one length at a time. E.g. assume user inputs
 *  'rosary' and the  ckb_take_threes is checked: there will be a column in
 *  sgrid_raw_words for words of length = 6, 5, 4 and 3.
 *  Therefore, there will be four (4) calls to this method with strm's of 6
 *  letter words, thence of 5 letter words, thence of 4 letter words and finally,
 *  of 3 letter words.
 *)

var
  i_row, s_len, _col: integer;
  i : Integer;
  str: ansistring;
  sz : DWORD;
begin
  sz := strm.Size;
  if strm.Size = 0 then
    raise Exception.Create('TV.Populate_raw_words: input stringStream is empty');

  strm.Seek(0, soBeginning);
  str := strm.ReadAnsiString;
  if String(str) = '' then
  begin
    ShowMessage('TV.Populate_raw_words: stringStream is defective??');
    Exit;
	end;

	s_len := Length(str);
  _col := find_column_of_grid(s_len, sgrid_raw_words);
  i_row := 1;    // there is a fixed row
  try
    try
    //while strm.Size > 0 do

      while str > '' do
      begin
        sgrid_raw_words.RowCount := sgrid_raw_words.RowCount +1;
        sgrid_raw_words.Cells[_col, i_row] := UpperCase(str);
        Inc(i_row);
        if strm.Position >= strm.Size then
          Break;
        str := strm.ReadAnsiString;
      end;
      Inc(FNodeWalker_rowCount_array[_col], i_row - 1);
    except on Ex : Exception do
      ShowMessage(Format('TV.Populate_raw_words exception in loop: %s @row %d',
              [Ex.Message, i_row]));
		end;
	finally
    Application.ProcessMessages;
  end;
end;

procedure TV.Populate_output_grid(lst : TStringList);
(*
 *    TV.Populate_output_grid
 *)
var
  i_col, i_row, str_len, ndx: integer;
  str: ansistring;
begin
  i_col := 0;
  if lst.Count = 0 then
    raise Exception.Create('TV.Populate_output_grid: Parameter lst is empty');
  str := lst[0];
  str_len := Length(str);

  i_col := find_column_of_grid(str_len, sGrid_output);
  i_row := 1;    // there is a fixed row
  ndx := 0;
  try
    while True do
    begin
      if sGrid_output.RowCount < i_row +1 then
        sGrid_output.RowCount := i_row +1;
      sGrid_output.Cells[i_col, i_row] := UpperCase(str);
      Inc(i_row);
      Inc(ndx);
      if ndx >= lst.Count then
        Break;
      str := lst[ndx];
    end;
  finally
    try
      Application.ProcessMessages;
      pgCtrl.ActivePage := tsDbOps;
      sGrid_output.SetFocus;
		except on Ex : Exception do
      ShowMessage(Format('TV.Populate_output_grid exception: %s', [Ex.Message]));
		end;
	end;
end;

function TV.Get_good_words_from_DB(const parm_str: string;
  var slst: TStringList): boolean;
(*
 *    TV.Get_good_words_from_DB: passes parm_str to the database to discover
 *    the legitimate words in that parm_str. Those legitimate words are
 *    returned to the caller via the slst : TStringList parameter.
 *)
var
  qry: TSQLQuery;
  tx: TSQLTransaction;
  sql: string;
const
  WORD_SELECT_SQL = 'SELECT word FROM words WHERE word in (%s) ORDER BY word';

begin
  Result := False;
  sql := Format(WORD_SELECT_SQL, [parm_str]);
  qry := TSQLQuery.Create(self);
  try
    qry.DataBase := Word_Dmod.OpenDbConnection(tx);
    qry.SQL.Add(sql);
    qry.UniDirectional := True;
    qry.Prepare;
    qry.Open;
    while not qry.EOF do
    begin
      slst.Add(qry.FieldByName('word').AsString);
    end;
    Result := True;
  finally
    qry.Free;
  end;
end;

procedure TV.setup_pgBar(max: integer = 0);
begin
  pgBar.Min := 0;
  pgBar.Max := max;
  pgBar.Position := 0;
  pgBar.Visible := True;
  pgBar.Style := pbstNormal;
end;

procedure TV.Final_output(slst: TStringList);
var
  i, str_len: integer;
begin
  if slst.Count = 0 then
    Exit;

  str_len := Length(slst[0]);
  sgrid_output.BeginUpdate;
  try

  finally
    sgrid_output.EndUpdate(True);
  end;
end;

procedure TV.buildATree(tree: TTreeView; const toLevel: integer);
var
  i, lvl: integer;
  maxLvls, ht, permCnt: integer;
  permCnt_ex, combinationCnt: integer;
  takeAt: integer;
  cleanStr: string;
  Node, firstNode: TTreeNode;
begin
  if toLevel = Length(FStartString) then
  begin
    edTvuItmCount.Text := '';
    cleanStr := CleanString(FStartString);
    pnlTvuTop.Caption := Format('Start string is: %s', [FStartString]);
  end
  else
  ;
  // what if toLevel <> Length(FStartString)
  cleanStr := CleanString(FStartString);
  // this is not right. takeAt should be the length of the input string.
  takeAt := Length(cleanStr);
  if takeAt = 0 then
    Exit;

  tree.Items.Clear;

  try
    begin
      { lst.Count factorial permutation count of the cnaracters of cleanStr.
        I don't know what I meant here!!}
      maxLvls := toLevel;
      permCnt := PermutationCount(maxLvls, takeAt);
      combinationCnt := CombinationCount(maxLvls, maxLvls);
      permCnt_ex := PermutationCount_ex(maxLvls, takeAt, FMinLen);

      setup_pgBar(permCnt);

      edMaxCount.Text := pgBar.Max.ToString;
      edMaxCount.Update;

      {
        this iteration "primes" the tree with the first level from
        the string. I.e., if the string is 'revenge', nodes are
        added to the root of 'r', 'e', 'v', 'e', 'n', 'g' and 'e'.
      }
      firstNode := tree.Items.AddFirst(nil, cleanStr[1]);
      { the first level does not need to have duplicate letters because
        all the combinations}
      cleanStr := CleanDuplicateChars(cleanStr);
      ht := Length(cleanStr);
      for i := 2 to ht do
      begin
        tvu.Items.Add(firstNode, cleanStr[i]);
        { siblings of firstNode }
      end;
      { restore the string }
      cleanStr := CleanString(FStartString);

      try
        tree.Items.BeginUpdate;
        Node := tree.Items.GetFirstNode;
        lvl := 0;
        //globLevel := lvl;
        while Node <> nil do
        begin
          lblRootChar.Caption := Concat('---', Node.Text, '---');
          // tree.FullExpand;
          // tree.Items.BeginUpdate;
          {   We are at level 0!!   }
          FTreeWidth := Length(cleanStr);
          AddTheChildren(cleanStr, 0, Node);
          Node := Node.getNextSibling;
        end;
      finally
        tree.FullExpand;
        tree.Select(firstNode);
        firstNode.MakeVisible;
        tree.Items.EndUpdate;

        if toLevel = Length(FStartString) then
        begin
          pgCtrl.ActivePage := tsMain;
          tree.SetFocus;
          edTvuItmCount.Text := tree.Items.Count.ToString;
          lblFinalCount.Caption := tree.Items.Count.ToString;
        end;
        pgBar.Visible := False;
      end;
    end;
  except
    on Ex: Exception do
      ShowMessage(Ex.Message);
  end;
end;

function removeParmNodeTextChar(Str, char2Remove: string): string;
var
  i: integer;
begin
  { remove the ParmNode.Text character from Str }
  i := 1;
  while (i < Length(Str)) and (Str[i] <> char2Remove) do
    Inc(i, 1);
  if Str[i] = char2Remove then
    Delete(Str, i, 1);
  Result := Str;
end;

function TV.AddThisLevelsChildren(_str: string; Parent: TTreeNode): TTreeNode;
{
  TFrmWordScapes.AddThisLevelsChildren
  parameters:
  _str is the part of the string originally provided by the user that is left
  Parent is the parent node for the branch of the tree
  returns the first node added
}
var
  FrstNode: TTreeNode;
begin
  FrstNode := tvu.Items.AddChildFirst(Parent, _str[First]);
  { otherwise, add the remaining lst members as children of ParmNode }
  Delete(_str, First, 1);
  while (Length(_str) > 0) do
  begin
    tvu.Items.Add(FrstNode, _str[First]);
    { siblings of firstNode }
    Delete(_str, First, 1);
  end;
  Result := FrstNode;
end;

function TV.GetLmtClause: utf8string;
begin
  Result := FLmtClause;
end;

function TV.GetTreeWidth: integer;
begin
  if tvu.Items.Count < 5 then Exit;
  FTreeWidth := Length(FStartString);
end;

procedure TV.UpdateProgressBar;
begin
  pgBar.Position := tvu.Items.Count;
  edTvuItmCount.Text := tvu.Items.Count.ToString;
  edTvuItmCount.Update;
  pgBar.Update;
end;

procedure TV.AddTheChildren(Str: string; lvl: integer; ParmNode: TTreeNode);
(*
 *    procedure TV.AddTheChildren
 *    parameter lvl is the level in the tree.
 *)
var
  a_node: TTreeNode;
begin

  { remove the ParmNode.Text character from Str to prevent re-use }
  Str := removeParmNodeTextChar(Str, ParmNode.Text[1]);

  Inc(lvl); { each call to AddTheChildren moves us down to another level }
  { but, we can only go to the max levels (the length of the original string) }
  if (lvl > FTreeWidth) { or (lvl > howDeep)} then
    Exit;

  lblLvl.Caption := Concat('===', IntToStr(lvl), '===');
  { also, if the length of the parm string = 1, we've gone thru them all }
  if Length(Str) < 1 then { if there are no more in the list, quit. }
    Exit; { this should never execute }

  { update the progress bar }
  if (tvu.Items.Count mod 25 = 0) then
    UpdateProgressBar;

  { add this level's children }
  a_node := AddThisLevelsChildren(Str, ParmNode);

  { Now make recursive calls for each of firstNode's siblings }
  while True do
  begin
    AddTheChildren(Str, lvl, a_node);
    a_node := a_node.getNextSibling;
    if a_node = nil then
      break;
  end;

end;

procedure TV.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TV.edCharStringKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
var
  work_s: string;
  ch: char;
  oldPosition: integer;
begin
  work_s := edCharString.Text;
  if Length(work_s) > 8 then
  begin
    ShowMessage('A maximum of 8 characters are acceptable.');
    edCharString.Text := Copy(work_s, 1, Length(work_s) - 1);
  end;

  if Key = VK_BACK then
    Exit;

  oldPosition := TEdit(Sender).SelStart;
  work_s := TEdit(Sender).Text;
  ch := Chr(Key);
  try
    if not IsLetter(ch) then
    begin
      work_s := Copy(work_s, 1, Length(work_s) - 1);
      TEdit(Sender).Text := work_s;
      Exit;
    end;
  finally
    TEdit(Sender).SelStart := OldPosition;
  end;
end;

procedure TV.MaskEditEnter(Sender: TObject);
begin
  TMaskEdit(Sender).SelectAll;
end;

procedure TV.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FLst4Words) then
    FLst4Words.Free;
  MainPropStorage.Save;
  while Length(FAraOfTvu) > 0 do
  begin
    FAraOfTvu[Length(FAraOfTvu) - 1].Free;
    SetLength(FAraOfTvu, Length(FAraOfTvu) - 2);
  end;
  FNodeWalker.Free;
end;

procedure TV.mnuItm_expose_test_tabClick(Sender: TObject);
begin
  tsTesting.Visible := True;
end;

procedure TV.Close1Click(Sender: TObject);
begin
  Word_Dmod.Free;
  Close;
end;

procedure TV.tvuChange(Sender: TObject; Node: TTreeNode);
begin
  if tvu.Items.Count = 0 then
  begin
    ShowMessage(Concat('in tvuChange ', sLineBreak, 'what the hey?'));
  end;
end;

procedure TV.FormActivate(Sender: TObject);
begin
  //tb_build_tree.SetFocus;
end;

{$ASSERTIONS ON}
procedure TV.FormCreate(Sender: TObject);
begin
  {$define STAY_TOP}
{$IFDEF STAY_TOP}
  SetWindowPos(self.Handle, HWND_TOPMOST, 0, 0, 0, 0, 0);
  //, SWP_NoMove);
  //or SWP_NoSize);
{$ENDIF}
  Word_Dmod := TWord_Dmod.Create(self);
  MainPropStorage.Restore;
  SetLength(FAraOfTvu, 0);
  set_actions(get_started);
  Assert(self.Handle <> Application.Handle, 'self.handle <> Application.Handle');
  FNodeWalker := TNodeWalker.Create(self);

  //FNodeWalker.StringListCallback := TStringListCallbackMethod(Populate_raw_words);
  FNodeWalker.CandidateCallback := TMemoryStreamCallbackMethod(Populate_raw_words);

  FNodeWalker.FinalOutputCallback := TStringListCallbackMethod(Populate_output_grid);
  FNodeWalker.PgBarCallback := TPgBarCallbackMethod(PgBarFeedback);
  FNodeWalker.CursorCallback := TIntegerCallbackMethod(CursorFeedback);
  FNodeWalker.StatusBarCallback := TStringCallbackMethod(StatusBarFeedback);
end;

function TV.ParseLmtClause({var startAt, howMany: integer}): boolean;
var
  // , segSize
  i, dummy_value, iCode: integer;
  s, tmpS: string;
const
  LimitS = 'limit ';
begin
  Result := False;
  s := Trim(FLmtClause); { should look like "Limit ####, ####" }
  if Trim(s) = '' then
    Exit;

  { rid yourself of the "Limit" }

  if s.StartsWith(LimitS, True) then
    s := s.Replace(LimitS, '');
  { ContainsText, StartsText, EndsText and ReplaceText }
  s := Trim(s);
  { Now, s should look like "####, ####" }

  { get the starts at }
  i := Pos(COMMA, s);
  if not (i > 0) then
    Exit; // FLmtClause is not properly formatted.

  tmpS := Trim(Copy(s, 0, i - 1)); // tmpS should be the startsAt number
  Val(tmpS, dummy_value, iCode);
  if iCode <> 0 then // tmpS is not a number
    Exit; // s is not a limit clause
  Invalidate;

  { get the howMany }
  tmpS := Trim(Copy(s, i + 1)); // clip the comma; tmpS should be "####"
  Val(tmpS, dummy_value, iCode);
  if iCode <> 0 then    // FLmtClause is not properly formatted
    Exit;
  Result := True;
end;

procedure TV.ActLoadSelectionExecute(Sender: TObject);
//var
//  startsAt, howMany: integer;
begin
  //startsAt := -1;
  //howMany := -1;
  if not Assigned(FrmGetDbParams) then
    FrmGetDbParams := TFrmGetDbParams.Create(self);

  FrmGetDbParams.Position := poMainFormCenter;
  FrmGetDbParams.ShowModal;
  FLmtClause := FrmGetDbParams.FLmtClause;
  ParseLmtClause({startsAt, howMany});
end;

procedure TV.BuildCombinationTree(ltrCount: integer);
(*  procedure TV.BuildCombinationTree
 *  No idea what this is for???
 *)
var
  ts: TTabSheet;
  tree: TTreeView;
begin
  if ltrCount < 3 then Exit;

  ts := TTabSheet.Create(pgCtrl_ex);
  ts.PageControl := pgCtrl_ex;
  ts.Caption := IntToStr(ltrCount) + 's';
  tree := ExtractSubTree(ltrCount);
  tree.Name := NEW_TREE_PREFIX + IntToStr(ltrCount);
  tree.Parent := ts;
  tree.Align := alClient;

end;

function TV.ExtractSubTree(toLevel: integer): TTreeView;
var
  newLen: integer;
  tv: TTreeView;
begin
  newLen := Length(FAraOfTvu) + 1;
  SetLength(FAraOfTvu, Length(FAraOfTvu) + 1);
  Dec(newLen);
  FAraOfTvu[newLen] := TTreeView.Create(self);
  tv := FAraOfTvu[newLen];
  buildATree(tv, toLevel);
  Result := tv;
end;

procedure TV.ActBldSubTreesExecute(Sender: TObject);
var
  i: integer;
begin
  freeFAraOfTvu;
  for i := 3 to FTreeWidth - 1 do
  begin
    BuildCombinationTree(i);
  end;
  //bldTreeWords := TfmBldTreeWords.Create(self, tvu, ht, wd);
end;

procedure TV.ActLoadWordsExecute(Sender: TObject);
(*
 *    procedure TV.ActLoadWordsExecute
 *    Not sure what this is for. But, it is not thoroughly implemented.
 *)
begin
  ActLoadSelection.Execute;
  try
    if not Assigned(FLst4Words) then
      FLst4Words := TStringList.Create;
    FLst4Words.LoadFromFile(FFileName);
    //psTextFile(FLst4Words);
  except
    on E: Exception do
      ShowMessage(Concat('ActLoadWordsExecute: ', sLineBreak, E.Message));
  end;
end;

procedure TV.ActionTestCalculateExecute(Sender: TObject);
var
  num, takenAt, minLen: integer;
begin
  num := StrToInt(Trim(edSetSize.Text));
  takenAt := StrToInt(Trim(edTakenAt.Text));
  minLen := StrToInt(Trim(edMinLen.Text));

  lblCombinationCount.Caption := IntToStr(CombinationCount(num, takenAt));
  lblPermutationCount.Caption := IntToStr(PermutationCount(num, takenAt));
  lblPermutationExCount.Caption :=
    IntToStr(PermutationCount_ex(num, takenAt, minLen));
end;

procedure TV.PgBarFeedback(rec: TPgBarOps);
{  procedure TV.PgBarFeedback(arg : Integer; _max : Integer = 0;
                                    step : Integer = 0);        }
var
  arg, _max, step: integer;
begin
  arg := rec.arg;
  _max := rec.max;
  step := rec.step;
  if arg > 0 then
    pgBar.Position := arg
  else
  if arg = -1 then
    setup_pgBar(_max)
  else
  if (arg = 0) and (_max = MAXINT) then
  begin
    pgBar.Style := pbstMarquee;
    pgBar.Visible := True;
    Application.ProcessMessages;
  end
  else
  if step = MAXINT then
    pgBar.StepIt;
end;

procedure TV.CursorFeedback(arg_cursor: integer);
begin
  pgCtrl.Cursor := TCursor(arg_cursor);
  Application.ProcessMessages;
  Sleep(1);
end;

procedure TV.StatusBarFeedback(_str: string);
begin
  statusBar.SimpleText := _str;
  Application.ProcessMessages;
  Sleep(1);
end;

end.
procedure ActCmpWords_W_DbExecute(Sender: TObject);
procedure TV.ActCmpWords_W_DbExecute(Sender: TObject);
(*      { #todo : THIS IS NOT USED!!!???!! }
 *  TV.ActCmpWords_W_DbExecute
 *  The driver for
 *  1.  gathering raw words (from sgrid_raw_words) into suitable strings
 *      for a query where clause. (build_parm_str function)
 *  2.  call TV.Populate_output_grid which finishes the get good words process.
 *)const
val_fmt = '"%s",';
function build_parm_str(col: integer;
sg: TStringGrid): string;
var
i: integer;
msg: string;
begin
Result := EmptyStr;
i := sg.FixedRows;
if sg.RowCount < sg.FixedRows then
begin
msg := Format('TV.ActCmpWords_W_DbExecute: empty grid column %d',
[col]);
raise Exception.Create(msg);
end;
while True do    // i < sg.RowCount do  beginResult :=
Result + Format(val_fmt, [sg.Cells[col, i]]);
Inc(i);
if (i = sg.RowCount)       // at the end of the column or(sg.Cells[col, i] = EmptyStr) then
// out of populated cells  Break;// inner loop  end;if Length(Result) = 0 then
raise Exception.Create('TV.ActCmpWords_W_DbExecute no parameters found.');
if Result[Length(Result)] = COMMA then
Result := Copy(Result, 0, Length(Result) -1);
end;
var
i_col: integer;
sg: TStringGrid;
sl: TStringList;
val_str: string;
_cursor: TCursor;
begin
_cursor := Cursor;
CursorFeedback(crHourGlass);
val_str := EmptyStr;
sg := sgrid_raw_words;
pgCtrl.ActivePageIndex := 1;
Application.ProcessMessages;
sl := TStringList.Create;
try
i_col := sg.ColCount -1;
while i_col > -1 do
begin
val_str := build_parm_str(i_col, sg);
      {   val_str is a comma separated list of QuotedStr raw words.
          Now, strain them out through the database.  }//Populate_output_grid(val_str);
Application.ProcessMessages;
Dec(i_col);
end;
//Populate_output_grid;    set_actions(compare_to_db);finally
sl.Free;
CursorFeedback(_cursor);
end;
end;
