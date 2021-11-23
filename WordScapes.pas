unit WordScapes;

{$MODE Delphi}
{$DEFINE SEEWORDS}

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Forms,
  frmCompWord_W_DB, WordscapeHelper,
  WordDmod, SQLDB, ActnList, GetParams4Read, Contnrs,
  Menus, Grids, MaskEdit, XMLPropStorage, Buttons;

type
  TCallers = (get_started, build_tree, node_walker, compare_to_db);

  { TV }

  TV = class(TForm)
    ActGetFile: TAction;
    ActBldSubTrees: TAction;
    ActCmpWords_W_Db: TAction;
		ActGetStarted : TAction;
    ActNodeWalker: TAction;
    ActionTestCalculate: TAction;
    ActLoadSelection: TAction;
    ActLoadWords: TAction;
    btnTestingCalculate: TBitBtn;
    BtnBuildTree: TBitBtn;
    btmPanelTab2: TPanel;
    capCombinationCount: TLabel;
    capPermutationExCount: TLabel;
    ckb_take_threes: TCheckBox;
    edMinLen: TMaskEdit;
    imgList: TImageList;
    cap_output_grid: TLabel;
    cap_words_memo: TLabel;
    lblCombinationCount: TLabel;
    capPermutationCount: TLabel;
    lblPermutationCount: TLabel;
    lblPermutationExCount: TLabel;
    lblSetSize: TLabel;
    lblTakeAt: TLabel;
    edSetSize: TMaskEdit;
    edTakenAt: TMaskEdit;
    lblTakeAt1: TLabel;
    lblMinLen: TLabel;
		raw_words_mmo : TMemo;
    MenuItem1: TMenuItem;
    mnuItm_node_walker: TMenuItem;
    mnuItm_expose_test_tab: TMenuItem;
    N7: TMenuItem;
    N6: TMenuItem;
    mnuItm_bld_tree: TMenuItem;
    mnuItm_ps_word_list: TMenuItem;
    mnuItm_ps_the_tree: TMenuItem;
    mnuItm_bld_sub_trees: TMenuItem;
    MenuItem6: TMenuItem;
    N5: TMenuItem;
    N4: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    pnl_for_words_memo: TPanel;
    pnl_for_output_grid: TPanel;
    pgCtrl_ex: TPageControl;
    Panel1: TPanel;
    pnlTvuTop: TPanel;
    pnlTvu: TPanel;
    pnlTesting: TPanel;
    pnl_words_grid: TPanel;
    Popup: TPopupMenu;
    sGrid_output: TStringGrid;
    capIterator: TLabel;
    lblIteratorI: TLabel;
    capLvl: TLabel;
    lblLvl: TLabel;
    capRootChar: TLabel;
    lblRootChar: TLabel;
    pgBar: TProgressBar;
    spltr_4_tvu: TSplitter;
    Splitter3: TSplitter;
    sgrid_raw_words: TStringGrid;
    toolBar_main: TToolBar;
    tb_build_tree: TToolButton;
    tb_ps_sub_trees: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    tb_ps_tree: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    tsFor3s: TTabSheet;
    tsDbOps: TTabSheet;
    tsTesting: TTabSheet;
    topPanelTab2: TPanel;
    edCharString: TEdit;
    pgCtrl: TPageControl;
    tsMain: TTabSheet;
    lblTvuItemCount: TLabel;
    edTvuItmCount: TEdit;
    capMaxCount: TLabel;
    edMaxCount: TEdit;
    ActLst4WordScapes: TActionList;
    ActBldTree: TAction;
    ActBuildWordList: TAction;
    lblFinalCount: TLabel;
    cap_enterLetters: TLabel;
    ActEnableMnMnu: TAction;
    mnMnu: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    CC1: TMenuItem;
    actClose: TAction;
    mnuPsOptions: TMenuItem;
    Buildtree1: TMenuItem;
    Processwordlist1: TMenuItem;
    tvu: TTreeView;
    MainPropStorage: TXMLPropStorage;
    procedure ActBldSubTreesExecute(Sender: TObject);
    procedure ActionTestCalculateExecute(Sender: TObject);
    procedure ActLoadSelectionExecute(Sender: TObject);
    procedure ActLoadWordsExecute(Sender: TObject);
    procedure ActCmpWords_W_DbExecute(Sender: TObject);
    procedure ActNodeWalkerExecute(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure edCharStringKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MaskEditEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure mnuItm_expose_test_tabClick(Sender: TObject);
    procedure tvuChange(Sender: TObject; Node: TTreeNode);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActBldTreeExecute(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure edCharStringKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);

  private
    FFileName: TFileName;
    FLst4Words: TStringList;
    FTreeHeight: integer;
    FTreeWidth: integer;
    FStartString: string;
    FMinLen: integer;
    FAraOfTvu: array of TTreeView;
    F_Handle: uint64;
    FNodeWalker: TNodeWalker;

    procedure AddTheChildren(Str: string; lvl: integer; ParmNode: TTreeNode);
    procedure buildATree(tree: TTreeView; const toLevel: integer);
    procedure BuildCombinationTree(ltrCount: integer);
    function AddThisLevelsChildren(_str: string; Parent: TTreeNode): TTreeNode;
    function ExtractSubTree(toLevel: integer): TTreeView;
		function find_column_of_grid(_len : Integer) : Integer;
    procedure freeFAraOfTvu;

    function GetLmtClause: utf8string;

    function GetTreeWidth: integer;
		function Get_good_words_from_DB(const parm_str : String; var slst : TStringList) : Boolean;
		procedure Populate_output_grid;
    function ParseLmtClause(var startAt, howMany: integer): boolean;
		procedure Populate_output_grid(lst : TStringList);
    procedure Populate_raw_words(lst: TObjectList); overload;
    procedure Populate_raw_words(lst: TStringList); overload;

    procedure SetLmtClause(AValue: utf8string);
    procedure SetStartString(AValue: string);
    procedure setup_list_grid(sgrid : TStringGrid);
    procedure unset_actions_enabled;
    procedure UpdateProgressBar;
    procedure FrmPsWordsFormClose(Sender: TObject);
    procedure set_actions(Sender : TCallers);
  protected
    procedure Wnd_proc(var Msg: TMessage);
    procedure PopulateRawWords(var Msg: TMessage); //message LM_POP_RAW_WORDS;
    procedure GetMainWinHandle(var Msg: TMessage); //message LM_GET_MAIN_WINDOW_HANDLE;
  public
    procedure test_the_handle(var Msg: TMessage); // message LM_TEST_THE_HANDLE;
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
  Grid_title_raw = 'Raw words (permutations)';
  Grid_title_final = 'Good words';


procedure TV.Wnd_proc(var Msg: TMessage);
begin
  case Msg.msg of
    LM_POP_RAW_WORDS: PopulateRawWords(Msg);
    LM_GET_MAIN_WINDOW_HANDLE: GetMainWinHandle(Msg);
    LM_TEST_THE_HANDLE: test_the_handle(Msg);
  end;

end;

procedure TV.PopulateRawWords(var Msg: TMessage);
var
  leafList: TObjectList;
  i: integer;
  _s: string;
  max_str_len: integer;
begin
  ShowMessage('in TV.PopulateRawWords');
  sgrid_raw_words.RowCount := 1;
  Application.ProcessMessages;

  if Msg.wParam = -1 then
    Exit;
  leafList := TObjectList(Msg.msg);
  max_str_len := 0;
  for i := 0 to 100 do
  begin
    _s := string(leafList[i]);
    if Length(_s) > max_str_len then
      max_str_len := Length(_s);
  end;

  sgrid_raw_words.RowCount := leafList.Count;
  for i := 0 to leafList.Count - 1 do
  begin
    _s := string(leafList[i]);
  end;
end;

procedure TV.GetMainWinHandle(var Msg: TMessage);
begin
  self.Handle := Application.Handle;
  Assert(self.Handle = Application.Handle, 'after post message, handles same');
end;

procedure TV.test_the_handle(var Msg: TMessage);
begin
  ShowMessage('TV.test_the_handle');
end;


procedure TV.edCharStringKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin  if Key = VK_RETURN then
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

procedure TV.set_actions(Sender : TCallers);
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
  end_row : Integer;
  zone_set : TGridZoneSet;
begin
  Clear_string_grid(sgrid_raw_words, 1, 1, 0);
  Application.ProcessMessages;
  if Length(edCharString.Text) > 8 then
  begin
    ShowMessage('Length of characters entered must not exceed 8');
    edCharString.SetFocus;
    Exit;
  end;
  if sgrid_raw_words.RowCount = 1 then
      end_row := 0
  else
      end_row := sgrid_raw_words.RowCount -1;
  sgrid_raw_words.Clear;

  FStartString := UpperCase(edCharString.Text);
  buildATree(tvu, Length(FStartString));
  set_actions(build_tree);
end;

procedure TV.ActNodeWalkerExecute(Sender: TObject);
var
  _tree_height: integer;
begin
  {  sgrid_raw_words is reconfigured on each call to this method.  }
  setup_list_grid(sgrid_raw_words);
  Application.ProcessMessages;
  _tree_height := Length(CleanDuplicateChars(FStartString));
  FNodeWalker.setup_walker(tvu, _tree_height, FTreeWidth, ckb_take_threes.Checked);
  try
  finally
    set_actions(node_walker);
  end;
end;

procedure TV.setup_list_grid(sgrid : TStringGrid);
(*
 *  procedure TV.setup_list_grid;
 *  Set the columns for the raw list elements. If ckb_take_threes.Checked,
 *  there will be Length(edCharString.Text) -2 columns. Otherwise, there
 *  will be Length(edCharString.Text) -3 columns.
 *)
const
  ColHeading = 'Length: %d';
var
  i, col_cnt, ndx, col_cnt_diff: integer;
  heading_str: string;
begin
  Clear_string_grid(sgrid, 1, 1, 0, 1);
  sgrid.ColCount := 0;
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
    sgrid.ColCount := sgrid.ColCount + 1;
    sgrid.Cells[i, 0] := heading_str;
    sgrid.Objects[i, 0] := TObject(i + col_cnt_diff);
    Inc(i);
  end;
end;

procedure TV.Populate_output_grid(lst : TStringList);
var
  i : Integer;
begin

end;

procedure TV.Populate_raw_words(lst: TObjectList);
(*
 *    procedure TV.Populate_raw_words
 *    NOT IMPLEMENTED, PLACE HOLDER
 *)
var
  i: integer;
begin
end;

function TV.find_column_of_grid(_len : Integer): Integer;
(*
 *    function find_column_of_grid searches for the column that
 *    will receive _len letter words by searching iteratively
 *    through sgrid_raw_words.Objects for an object made like
 *    TObject(string length).
 *)
var
  i, iValue : Integer;
begin
  Result := -1;
  i := 0;
  while i < sgrid_raw_words.ColCount do
  begin
    iValue := Integer(sgrid_raw_words.Objects[i, 0]);
    if sgrid_raw_words.Objects[i, 0] = TObject(_len) then
        Break;
    Inc(i);
	end;
  if i = sgrid_raw_words.ColCount then
      raise Exception.Create('TV.Populate_raw_words.find_column_of_grid '
          +'exception: column not found.');
  Result := i;
end;

procedure TV.Populate_raw_words(lst: TStringList);
(*
 *  procedure TV.Populate_raw_words:
 *  the lst's of words are passed one length at a time. E.g. assume user inputs
 *  'rosary' and the  ckb_take_threes is checked: there will be a column in
 *  sgrid_raw_words for words of length = 6, 5, 4 and 3.
 *  Therefore, there will be four (4) calls to this method with lst's of 6
 *  letter words, thence of 5 letter words, thence of 4 letter words and finally,
 *  of 3 letter words.
 *)

var
  i_row, s_len, _col: integer;
begin
  if lst.Count = 0 then
    raise Exception.Create('TV.Populate_raw_words: parameter lst: ' +
                       'TStringList is empty');

  if sgrid_raw_words.RowCount < lst.Count then
    sgrid_raw_words.RowCount := lst.Count;

  s_len := Length(lst[0]);
  _col := find_column_of_grid(s_len);
  i_row := 1;    // there is a fixed row
  while i_row < lst.Count do
  begin
    sgrid_raw_words.Cells[_col, i_row] := lst[i_row -1];
    Inc(i_row);
	end;
end;

function TV.Get_good_words_from_DB(const parm_str : String;
          var slst : TStringList) : Boolean;
var
  qry: TSQLQuery;
  tx: TSQLTransaction;
  sql : String;
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

procedure TV.Populate_output_grid;
var
  i_col, i_row : Integer;
  col_value_str : String;
  slst : TStringList;
begin
  i_col := 0;
  slst := TStringList.Create;

  try
		while i_col < sgrid_raw_words.ColCount do
		begin
		  col_value_str := EmptyStr;
		  i_row := 1;
		  while i_row < sgrid_raw_words.RowCount do
		  begin
		    col_value_str := col_value_str + sgrid_raw_words.Cells[i_col, i_row] +COMMA;
		    if Length(col_value_str) > MAX_COL_VALUE_STR_LEN then
		    begin
          Get_good_words_from_DB(col_value_str, slst);
          Continue;
			  end;
        Populate_output_grid(slst);
			  Inc(i_row);
		    if sgrid_raw_words.Cells[i_col, i_row] = EmptyStr then
		      Break;
		  end;
		  Inc(i_col);
		end;

	finally
    slst.Free;
	end;
end;

procedure TV.ActCmpWords_W_DbExecute(Sender: TObject);
    const
      val_fmt = '"%s",';

    function build_parm_str(col : Integer; sg : TStringGrid) : String;
    var
      i : Integer;
      msg : String;
    begin
        Result := EmptyStr;
        i := sg.FixedRows;
        if sg.RowCount < sg.FixedRows then
        begin
            msg := Format('TV.ActCmpWords_W_DbExecute: empty grid column %d',
                    [col]);
            raise Exception.Create(msg);
				end;
				while True do    // i < sg.RowCount do
        begin
          Result := Result + Format(val_fmt, [sg.Cells[col, i]]);

          Inc(i);
          if (i = sg.RowCount)       // at the end of the column
              or (sg.Cells[col, i] = EmptyStr) then  // out of populated cells
            Break;    // inner loop
				end;
        if Length(Result) = 0 then
          raise Exception.Create('TV.ActCmpWords_W_DbExecute no parameters found.');
        if Result[Length(Result)] = COMMA then
          Result := Copy(Result, 0, Length(Result) -1);
    end;

var
  i_col : integer;
  sg : TStringGrid;
  sl : TStringList;
  val_str : String;
begin
  val_str := EmptyStr;
  sg := sgrid_raw_words;
  setup_list_grid(sGrid_output);
  pgCtrl.ActivePageIndex := 1;
  Application.ProcessMessages;
  sl := TStringList.Create;
  try
    i_col := sg.ColCount -1;
    while i_col > -1 do
    begin
      val_str := build_parm_str(i_col, sg);
      raw_words_mmo.Append(val_str);
      raw_words_mmo.Append('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
      raw_words_mmo.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
      Application.ProcessMessages;
  		Dec(i_col);
    end;

		Populate_output_grid;
    set_actions(compare_to_db);
  finally
    sl.Free;
	end;
end;


procedure TV.buildATree(tree: TTreeView; const toLevel: integer);
var
  i, lvl: integer;
  maxLvls, ht, permCnt, permCnt_ex, combinationCnt, takeAt: integer;
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

  pgBar.Min := 0;
  pgBar.Position := 0;
  pgBar.Visible := True;

  tree.Items.Clear;

  try
    begin
      { lst.Count factorial permutation count of the cnaracters of cleanStr.
        I don't know what I meant here!!}
      maxLvls := toLevel;
      permCnt := PermutationCount(maxLvls, takeAt);
      combinationCnt := CombinationCount(maxLvls, maxLvls);
      permCnt_ex := PermutationCount_ex(maxLvls, takeAt, FMinLen);
      pgBar.Max := permCnt;
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

{
  the lvl parameter is the level in the tree.
}
procedure TV.AddTheChildren(Str: string; lvl: integer; ParmNode: TTreeNode);
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
  FNodeWalker.ObjectListCallback := TObjectListCallbackMethod(Populate_raw_words);
  FNodeWalker.StringListCallback := TStringListCallbackMethod(Populate_raw_words);
end;

function TV.ParseLmtClause(var startAt, howMany: integer): boolean;
var
  // , segSize
  i, iValue, iCode: integer;
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
  Val(tmpS, iValue, iCode);
  if iCode <> 0 then // tmpS is not a number
    Exit; // s is not a limit clause
  { otherwise }
  // lblRows2Ps.Caption := tmpS;
  //lblRows2Ps.Caption := tmpS;
  //capRows2Ps.Caption := 'Starts at';
  Invalidate;

  { get the howMany }
  tmpS := Trim(Copy(s, i + 1)); // clip the comma; tmpS should be "####"
  // i := Pos(Space, s);
  // tmpS := Trim(Copy(s, i));
  // tmpS should be the startat number
  Val(tmpS, iValue, iCode);
  if iCode <> 0 then
    // FLmtClause is not properly formatted
    Exit;

  //lblCurRow.Caption := tmpS;
  //Invalidate;
  Result := True;
end;

procedure TV.ActLoadSelectionExecute(Sender: TObject);
var
  startsAt, howMany: integer;
begin
  startsAt := -1;
  howMany := -1;
  if not Assigned(FrmGetDbParams) then
    FrmGetDbParams := TFrmGetDbParams.Create(self);

  FrmGetDbParams.Position := poMainFormCenter;
  FrmGetDbParams.ShowModal;
  FLmtClause := FrmGetDbParams.FLmtClause;
  ParseLmtClause(startsAt, howMany);
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

end.
