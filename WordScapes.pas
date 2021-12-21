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
		ActAdd_2_db : TAction;
		ActSaveDB_2_txt : TAction;
		ActRemoveWord : TAction;
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
		Label1 : TLabel;
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
		delta_lstVu : TListView;
    MenuItem1: TMenuItem;
		MenuItem2 : TMenuItem;
		MenuItem3 : TMenuItem;
		MenuItem4 : TMenuItem;
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
		Panel2 : TPanel;
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
    sGrid_output: TStringGrid;
    sgrid_raw_words: TStringGrid;
    dbop_splitter: TSplitter;
		all_words_grid : TStringGrid;
		Splitter1 : TSplitter;
		ToolBar1 : TToolBar;
		ToolButton10 : TToolButton;
		ToolButton7 : TToolButton;
		ToolButton8 : TToolButton;
		ToolButton9 : TToolButton;
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

		procedure ActAdd_2_dbExecute(Sender : TObject);
    procedure ActBldSubTreesExecute(Sender: TObject);
    procedure ActBldTreeExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure ActionTestCalculateExecute(Sender: TObject);
    procedure ActLoadSelectionExecute(Sender: TObject);
    procedure ActLoadWordsExecute(Sender: TObject);
    procedure ActNodeWalkerExecute(Sender: TObject);
		procedure ActRemoveWordExecute(Sender : TObject);
		procedure ActSaveDB_2_txtExecute(Sender : TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure edCharStringKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edCharStringKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
		procedure FormKeyUp(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure MaskEditEnter(Sender: TObject);
    procedure mnuItm_expose_test_tabClick(Sender: TObject);
		procedure sGrid_outputDblClick(Sender : TObject);
    procedure tvuChange(Sender: TObject; Node: TTreeNode);
		procedure all_words_gridKeyUp(Sender : TObject; var Key : Word;
					Shift : TShiftState);

  private
    FAraOfTvu: array of TTreeView;
    FFileName: TFileName;
    FLst4Words: TStringList;
    FMinLen: integer;
    FNodeWalker: TNodeWalker;
    FStartString: string;
    FAlphaList : TStringList;
    FTreeWidth: integer;
    F_Handle: uint64;
    FNodeWalker_rowCount_array: array of integer;

    function AddThisLevelsChildren(_str: string; Parent: TTreeNode): TTreeNode;
		procedure AfterCreate(ptr : IntPtr);
		procedure Bld_alpha_list(ptr : IntPtr);
    procedure CursorFeedback(arg_cursor: integer);
    function ExtractSubTree(toLevel: integer): TTreeView;
    function find_column_of_grid(_len: integer; grid: TStringGrid): integer;
    function GetLmtClause: utf8string;
    function GetTreeWidth: integer;
    function ParseLmtClause({var startAt, howMany: integer}): boolean;

    procedure AddTheChildren(Str: string; lvl: integer; ParmNode: TTreeNode);
    procedure buildATree(tree: TTreeView; const toLevel: integer);
    procedure BuildCombinationTree(ltrCount: integer);
    procedure freeFAraOfTvu;
    procedure FrmPsWordsFormClose(Sender: TObject);
    procedure PgBarFeedback(rec: TPgBarOps);
    procedure Populate_output_grid(lst: TStringList);

    procedure Populate_raw_words(lst: TStringList);
		procedure Return_output_count(dummy : Integer);
		procedure re_build_tree(ptr : IntPtr);

    procedure SetLmtClause(AValue: utf8string);
    procedure SetStartString(AValue: string);

    procedure setup_list_grids;
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

uses Character, DB;

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
    delta_lstVu.Clear;
  finally
    CursorFeedback(_cursor);

  end;
  ActNodeWalker.Execute;
end;

procedure TV.ActNodeWalkerExecute(Sender: TObject);
var
  _tree_height: integer;
begin
  {  sgrid_raw_words is reconfigured on each call to this method.  }
  setup_list_grids;
  Application.ProcessMessages;
  _tree_height := Length(CleanDuplicateChars(FStartString));
  FNodeWalker.setup_walker(tvu, _tree_height, FTreeWidth, ckb_take_threes.Checked);
  try

  finally
    set_actions(node_walker);
    pgBar.Visible := False;
  end;
end;

procedure TV.setup_list_grids;
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
  grid, out_grid: TStringGrid;
begin
  grid := sgrid_raw_words;
  out_grid := sGrid_output;
  Clear_string_grid(grid, 1, 1, 0, 1);
  Clear_string_grid(sGrid_output, 1, 1, 0, 1);
  grid.ColCount := 0;
  out_grid.ColCount := 0;
  col_cnt_diff := 3;
  if ckb_take_threes.Checked then
    col_cnt_diff := 2;

  col_cnt := Length(edCharString.Text) - col_cnt_diff;
  Inc(col_cnt_diff);

  i := 0;
  while i < col_cnt do
  begin
    heading_str := Format(ColHeading, [i + col_cnt_diff]);

    grid.ColCount := grid.ColCount + 1;
    grid.Cells[i, 0] := heading_str;
    grid.Objects[i, 0] := TObject(i + col_cnt_diff);

    out_grid.ColCount := grid.ColCount + 1;
    out_grid.Cells[i, 0] := heading_str;
    out_grid.Objects[i, 0] := TObject(i + col_cnt_diff);
    Inc(i);
  end;
  SetLength(FNodeWalker_rowCount_array, grid.ColCount);
  for i := 0 to grid.ColCount - 1 do
    FNodeWalker_rowCount_array[i] := 0;
end;

function TV.find_column_of_grid(_len: integer; grid: TStringGrid): integer;
(*
 *    function find_column_of_grid searches for the column that
 *    will receive _len letter words by searching iteratively
 *    through grid.Objects for an object made like
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
    raise Exception.Create('TV.find_column_of_grid ' +
      'exception: column not found.');
  Result := i;
end;

procedure TV.Populate_raw_words(lst : TStringList);
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
  sz := lst.Count;
  if lst.Count = 0 then
    raise Exception.Create('TV.Populate_raw_words: input stringStream is empty');

  lst.Sort;
	s_len := Length(lst[0]);
  _col := find_column_of_grid(s_len, sgrid_raw_words);
  i_row := 1;    // there is a fixed row
  i := 0;
  try
    try
      repeat
          begin
            // get the current element into the str variable
            str := lst[i];
            // add a row to the stringGrid
            sgrid_raw_words.RowCount := sgrid_raw_words.RowCount +1;
            // set the cell in the column and in the row
            sgrid_raw_words.Cells[_col, i_row] := UpperCase(str);
            Inc(i_row);
            Inc(i);
            if i = lst.Count then
              Break;
          end;
      until i = lst.Count;

      Inc(FNodeWalker_rowCount_array[_col], i_row - 1);
    except on Ex : Exception do
      ShowMessage(Format('TV.Populate_raw_words exception in loop: %s @row %d',
              [Ex.Message, i_row]));
		end;
	finally
    Application.ProcessMessages;
  end;
end;

procedure TV.re_build_tree(ptr : IntPtr);
begin
    ActBldTree.Execute;
end;

procedure TV.Return_output_count(dummy : Integer);
begin
  FNodeWalker.OutputCount := sGrid_output.RowCount;
end;

procedure TV.Populate_output_grid(lst : TStringList);
(*
 *    TV.Populate_output_grid
 *    The parameter lst should be the 'clean' list of words
 *    from the raw_list_grid. By 'clean' is meant, checked by
 *    the words from the all_words_grid to make sure those
 *    words are recognizably English.
 *)
var
  i_col, i_row, str_len, ndx: integer;
  str: ansistring;
begin
  i_col := 0;
  //if lst.Count = 0 then
  //begin
  //    ShowMessage('TV.Populate_output_grid: param list is empty.');
  //    Exit;
	//end;
	str := lst[0];
  str_len := Length(str);

  i_col := find_column_of_grid(str_len, sGrid_output);
  i_row := 1;    // there is a fixed row
  ndx := 0;
  try
    while True do
    begin
      if Is_all_consanants(lst[ndx]) then
        begin
          Inc(ndx);
          if ndx = lst.Count then
            Break;
          Continue;
				end;
			if sGrid_output.RowCount < i_row +1 then
        sGrid_output.RowCount := i_row +1;
      sGrid_output.Cells[i_col, i_row] := UpperCase(lst[ndx]);
      Inc(ndx);
      if ndx = lst.Count then
        Break;
      Inc(i_row);
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
  FreeAndNil(FAlphaList);
end;

procedure TV.mnuItm_expose_test_tabClick(Sender: TObject);
begin
  tsTesting.Visible := True;
end;

procedure TV.sGrid_outputDblClick(Sender : TObject);
begin
  ActRemoveWord.Execute;
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

procedure TV.all_words_gridKeyUp(Sender : TObject; var Key : Word;
			Shift : TShiftState);
var
  ndx, location : Integer;
  c : Char;
begin
  if not (Key in [VK_A..VK_Z]) then Exit;
  c := LowerCase(Chr(key));
  ndx := FAlphaList.IndexOf(c);
  location := Integer(FAlphaList.Objects[ndx]);
  all_words_grid.Row := location;
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
  // set name of WordsFile
  if FileExists(ParamStr(1)) then
    WordsFile := ParamStr(1)
  else
    WordsFile := 'words.txt';

  Word_Dmod := TWord_Dmod.Create(self);
  Word_Dmod.StatBarCallback := StatusBarFeedback;
  Word_Dmod.PgBarCallback := PgBarFeedback;

  MainPropStorage.Restore;
  SetLength(FAraOfTvu, 0);
  set_actions(get_started);
  //Assert(self.Handle <> Application.Handle, 'self.handle <> Application.Handle');
  FNodeWalker := TNodeWalker.Create(self);

  FNodeWalker.CandidateCallback := TStringListCallbackMethod(Populate_raw_words);

  FNodeWalker.FinalOutputCallback := TStringListCallbackMethod(Populate_output_grid);
  FNodeWalker.PgBarCallback := TPgBarCallbackMethod(PgBarFeedback);
  FNodeWalker.CursorCallback := TIntegerCallbackMethod(CursorFeedback);
  FNodeWalker.StatusBarCallback := TStringCallbackMethod(StatusBarFeedback);
  FNodeWalker.FinalOutputCountCallBack := TIntegerCallbackMethod(Return_output_count);

  FAlphaList := TStringList.Create;
  Application.QueueAsyncCall(AfterCreate, 0);
end;

procedure TV.FormKeyUp(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  case Key of
    VK_INSERT : ActAdd_2_db.Execute;
    VK_DELETE : ActRemoveWord.Execute;
	end;
end;

procedure TV.AfterCreate(ptr : IntPtr);
const
  _sql = 'SELECT word FROM words';
var
  lst : TStringList;
  qry : TSQLQuery;
begin
  lst := TStringList.Create;
  qry := TSQLQuery.Create(self);
  try
    lst.LoadFromFile(WordsFile);
    all_words_grid.RowCount := lst.Count;
    all_words_grid.Cols[0].AddStrings(lst);
    Word_dmod.Populate_WordBufList(lst);

	finally
    FreeAndNil(lst);
    qry.Free;
	end;
	Application.QueueAsyncCall(Bld_alpha_list, 0);
end;

procedure TV.Bld_alpha_list(ptr : IntPtr);
var
  i, rec_i : Integer;
  c : AnsiChar;
  p : PChar;
begin
  FAlphaList.Clear;
  c := 'a';
  i := 0;
  rec_i := 0;
  repeat
    if LowerCase(PChar(all_words_grid.Cells[0, i])^) = c then
      begin
        FAlphaList.AddObject(c, TObject(i));
        Inc(Ord(c));
        Inc(rec_i);
			end;
		Inc(i);
	until i = all_words_grid.RowCount;
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

procedure TV.ActAdd_2_dbExecute(Sender : TObject);
const
  _sql = 'INSERT INTO words (word) VALUES (%s)';
var
  aWord, s : String;
  itm : TListItem;
begin
  if not InputQuery('Add word to database', 'Enter word to add', aWord) then
    Exit;

  s :=  Format(_sql, [QuotedStr(aWord)]);
  if Word_Dmod.Do_exec_sql(s) then
    begin
        itm := TListItem.Create(delta_lstVu.Items);
        itm.Caption := aWord;
        itm.SubItems.Add('+++');
        delta_lstVu.Items.AddItem(itm);
    end;
end;

procedure Pack_column(grid : TStringGrid; col : Integer);
label
  OuterLoop;
var
  seek, row : Integer;
begin
  row := 1;
  while True do
  begin
    OuterLoop:
      if row >= grid.RowCount then
          Break;

      if grid.Cells[col, row] = '' then
        begin
          seek := row + 1;
          while seek < grid.RowCount do
            begin
              if grid.Cells[col, seek] > '' then
                begin
                  grid.Cells[col, row] := grid.Cells[col, seek];
                  grid.Cells[col, seek] := '';
                  Inc(row);
                  goto OuterLoop;
								end;
							Inc(seek);
						end;
				end;
      Inc(row);
	end;
  grid.Refresh;
end;

procedure TV.ActRemoveWordExecute(Sender : TObject);
const
  _sql = 'DELETE FROM words WHERE word = %s';
var
  aWord, s : String;
  q : TSQLQuery;
  row, col : Integer;
  b, b_cellValue : Boolean;
  itm : TListItem;
begin
  aWord := '';
  row := 1;
  b_cellValue := False;
  if not isRowEmpty(sGrid_output, row) then
    begin
        row := sGrid_output.Row;
        col := sGrid_output.col;
        aWord := sGrid_output.Cells[col, row];
        b_cellValue := True;
		end;
	if not InputQuery('Remove word from database', 'Enter word to remove', aWord)
  then  Exit;

  s :=  Format(_sql, [QuotedStr(aWord)]);
  b := Word_Dmod.Do_exec_sql(s);
  if b and b_cellValue then
    begin
      sGrid_output.Cells[col, row] := '';
      sGrid_output.Refresh;
      Pack_column(sgrid_output, col);
		end;
  if b then
    begin
      itm := TListItem.Create(delta_lstVu.Items);
      itm.Caption := aWord;
      itm.SubItems.Add('---');
      delta_lstVu.Items.AddItem(itm);
      sGrid_output.Refresh;
    end;
end;

procedure TV.ActSaveDB_2_txtExecute(Sender : TObject);
const
  _sql = 'SELECT word FROM words';
var
  qry : TSQLQuery;
  fl : TextFile;
  s : String;
begin
  AssignFile(fl, WordsFile);
  Rewrite(fl);
  qry := TSQLQuery.Create(self);
  try
    qry.DataBase := Word_Dmod.sqlConn;
    qry.Transaction := Word_Dmod.tx;
    qry.SQL.Text := _sql;
    Word_Dmod.Open_word_db;
    qry.Open;
    qry.First;
    while not qry.EOF do
      begin
        s := qry.Fields[0].AsString;
        WriteLn(fl, s);
        qry.Next;
			end;
	finally
    CloseFile(fl);
    qry.Free;
    Word_Dmod.Close_word_db;
	end;
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

procedure TV.setup_pgBar(max: integer = 0);
begin
  pgBar.Min := 0;
  pgBar.Max := max;
  pgBar.Position := 0;
  pgBar.Visible := True;
  pgBar.Style := pbstNormal;
end;

procedure TV.PgBarFeedback(rec: TPgBarOps);
{  procedure TV.PgBarFeedback(arg : Integer; _max : Integer = 0;
                                    step : Integer = 0);        }
begin
  if rec.arg > 0 then
    pgBar.Position := rec.arg
  else
  if rec.arg = INIT_PGBAR then
    begin
      if rec.max > 0 then
        setup_pgBar(rec.max)
      else
        pgBar.Visible := False;
		end
	else
  if (rec.arg = MARQUEE_PGBAR) and (rec.max = MAXINT) then
  begin
    pgBar.Style := pbstMarquee;
    pgBar.Visible := True;
    Application.ProcessMessages;
  end
  else
  if (rec.arg = STEP_PGBAR) and (rec.step = MAXINT) then
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

