unit WordScapes;

{$MODE Delphi}
{$DEFINE SEEWORDS}

interface

uses
  windows, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Forms, // Frame4WS,
  frmCompWord_W_DB, WordscapeHelper,
  ProcessWords2Db_controller,
  WordDmod, SQLDB, ActnList, GetParams4Read,
	Menus, Grids, MaskEdit, XMLPropStorage, Buttons;
  //IDETheme.ActnCtrls, Strings, Regex, , Contnrs;

type

    { TV }

  TV = class(TForm)
		ActGetFile: TAction;
		ActBldSubTrees : TAction;
		ActCmpWords_W_Db : TAction;
		ActNodeWalker : TAction;
		ActionTestCalculate : TAction;
		ActLoadSelection: TAction;
		ActLoadWords: TAction;
		btnTestingCalculate : TBitBtn;
		BtnBuildTree : TBitBtn;
    btmPanelTab2: TPanel;
		capCombinationCount : TLabel;
		capPermutationExCount : TLabel;
		edMinLen : TMaskEdit;
		imgList : TImageList;
		cap_output_grid : TLabel;
		cap_words_memo : TLabel;
		lblCombinationCount : TLabel;
		capPermutationCount : TLabel;
		lblPermutationCount : TLabel;
		lblPermutationExCount : TLabel;
		lblSetSize : TLabel;
		lblTakeAt : TLabel;
		edSetSize : TMaskEdit;
		edTakenAt : TMaskEdit;
		lblTakeAt1 : TLabel;
		lblMinLen : TLabel;
		MenuItem1 : TMenuItem;
		mnuItm_node_walker : TMenuItem;
		mnuItm_expose_test_tab : TMenuItem;
		N7 : TMenuItem;
		N6 : TMenuItem;
		mmoWords : TMemo;
		mnuItm_bld_tree : TMenuItem;
		mnuItm_ps_word_list : TMenuItem;
		mnuItm_ps_the_tree : TMenuItem;
		mnuItm_bld_sub_trees : TMenuItem;
		MenuItem6 : TMenuItem;
		N5 : TMenuItem;
		N4 : TMenuItem;
		N3 : TMenuItem;
		N2 : TMenuItem;
		pnl_for_words_memo : TPanel;
		pnl_for_output_grid : TPanel;
		pgCtrl_ex : TPageControl;
		Panel1: TPanel;
		pnlTvuTop : TPanel;
		pnlTvu : TPanel;
		pnlTesting : TPanel;
		pnlTvuTop1 : TPanel;
		Popup : TPopupMenu;
		sGrid : TStringGrid;
    capIterator: TLabel;
    lblIteratorI: TLabel;
    capLvl: TLabel;
    lblLvl: TLabel;
    capRootChar: TLabel;
    lblRootChar: TLabel;
    pgBar: TProgressBar;
		spltr_4_tvu: TSplitter;
		Splitter3: TSplitter;
		toolBar_main : TToolBar;
		tb_build_tree : TToolButton;
		tb_ps_sub_trees : TToolButton;
		ToolButton1 : TToolButton;
		ToolButton2 : TToolButton;
		ToolButton3 : TToolButton;
		tb_ps_tree : TToolButton;
		ToolButton4 : TToolButton;
		ToolButton5 : TToolButton;
		tsFor3s : TTabSheet;
		tsDbOps: TTabSheet;
		tsTesting : TTabSheet;
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
		tvu : TTreeView;
		MainPropStorage : TXMLPropStorage;
		procedure ActBldSubTreesExecute(Sender : TObject);
		procedure ActionTestCalculateExecute(Sender : TObject);
  procedure ActLoadSelectionExecute(Sender: TObject);
    procedure ActLoadWordsExecute(Sender: TObject);
		procedure ActCmpWords_W_DbExecute(Sender : TObject);
		procedure ActNodeWalkerExecute(Sender : TObject);
    procedure BtnCloseClick(Sender: TObject);
		procedure edCharStringKeyUp(Sender : TObject; var Key : Word;
					Shift : TShiftState);
		procedure MaskEditEnter(Sender : TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure mnuItm_expose_test_tabClick(Sender : TObject);
    procedure tvuChange(Sender: TObject; Node: TTreeNode);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActBldTreeExecute(Sender: TObject);
    procedure ActBuildWordListExecute(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure edCharStringKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
		FFileName: TFileName;
    FLst4Words : TStringList;
		FTreeHeight : integer;
		FTreeWidth : integer;
    FStartString : String;
    FMinLen : Integer;
    FAraOfTvu : array of TTreeView;

		procedure ActWrtWords2WordscapeExecute(Sender: TObject);
    procedure AddTheChildren(Str : string; lvl : Integer; ParmNode : TTreeNode);
		procedure buildATree(tree : TTreeView; const toLevel : Integer);
		procedure BuildCombinationTree(ltrCount : Integer);
		function cleanWordsTable: Boolean;
    function AddThisLevelsChildren(_str: string; Parent: TTreeNode): TTreeNode;
		function ExtractSubTree(toLevel : Integer) : TTreeView;
		procedure freeFAraOfTvu;

		function GetLmtClause: UTF8String;

		function GetTreeWidth : integer;
		function ParseLmtClause(var startAt, howMany: Integer): Boolean;

		procedure SetLmtClause(AValue: UTF8String);
		procedure SetStartString(AValue : String);
		procedure unset_actions_enabled;
    procedure UpdateProgressBar;
    procedure FrmPsWordsFormClose(Sender: TObject);
  public
    property FLmtClause: UTF8String read GetLmtClause write SetLmtClause;

    property TreeWidth : integer read GetTreeWidth write FTreeWidth;
    property StartString : String read FStartString write SetStartString;
    //property MaxLevels: Integer read FMaxLevels write FMaxLevels;
  end;

var
  V: TV;

implementation

{$R *.lfm}

uses Character;

const
  First = 1;
  NEW_TREE_PREFIX = 'tvu_';



procedure TV.edCharStringKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ActBldTree.Execute;
    Exit;
	end;
end;


procedure TV.SetLmtClause(AValue: UTF8String);
begin
  FLmtClause := AValue;
end;

procedure TV.SetStartString(AValue : String);
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
  i : Integer;
begin
  for i := 0 to Length(FAraOfTvu) -1 do
    FAraOfTvu[i].Free;
  SetLength(FAraOfTvu, 0);
end;

procedure TV.FrmPsWordsFormClose(Sender: TObject);
begin
  FrmPsWords2DBController.Free;
  freeFAraOfTvu;
end;

procedure TV.ActBuildWordListExecute(Sender: TObject);
(*   procedure TV.ActBuildWordListExecute
*    not sure what this is???
*)
begin
  if FrmPsWords2DBController = nil then
    FrmPsWords2DBController := TFrmPsWords2DBController.Create(self);
  FrmPsWords2DBController.Position := poMainFormCenter;
  FrmPsWords2DBController.Show;
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
begin
  if Length(edCharString.Text) > 8 then
  begin
    ShowMessage('Length of characters entered must not exceed 8');
    edCharString.SetFocus;
    Exit;
	end;
	unset_actions_enabled;
  FStartString := UpperCase(edCharString.Text);
  buildATree(tvu, Length(FStartString));
  ActBldSubTrees.Enabled := False;

end;

procedure TV.ActNodeWalkerExecute(Sender : TObject);
var
  _tree_height : Integer;
  nodewalker : TNodeWalker;
begin
  {   FTreeHeight should be length of "cleaned" list of characters
                                               entered by the user   }
  _tree_height := Length(CleanDuplicateChars(FStartString));
  nodewalker := TNodeWalker.Create(self, tvu, _tree_height, FTreeWidth);
  try

	finally
    nodewalker.Free;
	end;

end;


procedure TV.buildATree(tree : TTreeView; const toLevel : Integer);
var
  i, lvl : Integer;
  maxLvls, ht, permCnt, permCnt_ex, combinationCnt,  takeAt : Integer;
  cleanStr : String;
  Node, firstNode: TTreeNode;
begin
  if toLevel = Length(FStartString) then
  begin
  	edTvuItmCount.Text := '';
    cleanStr := CleanString(FStartString);
    pnlTvuTop.Caption := Format('Start string is: %s', [FStartString]);
	end
  else   ;
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
  i: Integer;
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

function TV.GetLmtClause : UTF8String;
begin
  Result := FLmtClause;
end;

function TV.GetTreeWidth : integer;
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
procedure TV.AddTheChildren(Str: string; lvl : Integer; ParmNode: TTreeNode);
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

procedure TV.edCharStringKeyUp(Sender : TObject; var Key : Word;
			Shift : TShiftState);
var
  work_s : String;
  ch : Char;
  oldPosition : Integer;
begin
  work_s := edCharString.Text;
  if Length(work_s) > 8 then
  begin
    ShowMessage('A maximum of 8 characters are acceptable.');
    edCharString.Text := Copy(work_s, 1, Length(work_s) -1);
	end;

  if Key = VK_BACK then
    Exit;

  oldPosition := TEdit(Sender).SelStart;
  work_s := TEdit(Sender).Text;
  ch := Chr(Key);
  try
    if not IsLetter(ch) then
    begin
      work_s := Copy(work_s, 1, Length(work_s) -1);
      TEdit(Sender).Text := work_s;
      Exit;
  	end;
  finally
  	TEdit(Sender).SelStart := OldPosition;
  end;
end;

procedure TV.MaskEditEnter(Sender : TObject);
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
    FAraOfTvu[Length(FAraOfTvu) -1].Free;
    SetLength(FAraOfTvu, Length(FAraOfTvu) -2 );
	end;
end;

procedure TV.mnuItm_expose_test_tabClick(Sender : TObject);
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
  unset_actions_enabled;
end;

function TV.ParseLmtClause(var startAt, howMany: Integer): Boolean;
var
      // , segSize
  i, iValue, iCode: Integer;
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
  if not(i > 0) then
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


function TV.cleanWordsTable: Boolean;
(*
  function TV.cleanWordsTable: boolean;
  A DANGEROUS FUNCTION so I have it repeated in several units???
 *)
const
  SQL = 'delete from words';
var
  qry: TSQLQuery;
  tx: TSQLTransaction;
begin
  Result := False;

  qry := TSQLQuery.Create(self);
  try
    qry.DataBase := Word_Dmod.OpenDbConnection(tx);
    qry.Transaction := tx;
    qry.SQL.Add(WORDS_INSERT_SQL);
    tx.StartTransaction;
    try
      qry.ExecSQL;
      tx.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        tx.Rollback;
        ShowMessage(Concat('cleanWordsTable: ', sLineBreak, E.Message));
        raise;
      end;
    end;
  finally
    qry.DataBase.Close(True);
    qry.Free;
  end;
end;

procedure TV.ActLoadSelectionExecute(Sender: TObject);
var
  startsAt, howMany: Integer;
begin
  startsAt := NOTASSIGNED_INT;
  howMany := NOTASSIGNED_INT;
  if not Assigned(FrmGetDbParams) then
    FrmGetDbParams := TFrmGetDbParams.Create(self);

  FrmGetDbParams.Position := poMainFormCenter;
  FrmGetDbParams.ShowModal;
  FLmtClause := FrmGetDbParams.FLmtClause;
  ParseLmtClause(startsAt, howMany);
end;

procedure TV.BuildCombinationTree(ltrCount : Integer);
(*  procedure TV.BuildCombinationTree
 *  No idea what this is for???
 *)
var
  ts : TTabSheet;
  tree : TTreeView;
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

function TV.ExtractSubTree(toLevel : Integer) : TTreeView;
var
  newLen : Integer;
  tv : TTreeView;
begin
  newLen := Length(FAraOfTvu) +1;
  SetLength(FAraOfTvu, Length(FAraOfTvu) +1);
  Dec(newLen);
  FAraOfTvu[newLen] := TTreeView.Create(self);
  tv := FAraOfTvu[newLen];
  buildATree(tv, toLevel);
  Result := tv;
end;

procedure TV.ActBldSubTreesExecute(Sender : TObject);
var
  i : Integer;
begin
  freeFAraOfTvu;
  for i := 3 to FTreeWidth -1 do
  begin
    BuildCombinationTree(i);
	end;
  //bldTreeWords := TfmBldTreeWords.Create(self, tvu, ht, wd);
end;

procedure TV.ActLoadWordsExecute(Sender: TObject);
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

procedure TV.ActCmpWords_W_DbExecute(Sender : TObject);
var
  compWords_W_DB : TfmCompWords_W_DB;
  wd, ht : Integer;
begin
  if tvu.Items.Count < 5 then
    Exit;
  //ht := TreeHeight;     // why does this get from 4 (the actual height) to 64
  ht := FTreeHeight;
  wd := TreeWidth;
  compWords_W_DB := TfmCompWords_W_DB.Create(self, tvu, ht, wd);
  try
    mmoWords.Lines := compWords_W_DB.Out_list;
    pgCtrl.ActivePage := tsDbOps;

	finally
    compWords_W_DB.Free;
    ActBldSubTrees.Enabled := True;
	end;
end;

procedure TV.ActionTestCalculateExecute(Sender : TObject);
var
  num, takenAt, minLen : Integer;
begin
  num := StrToInt(Trim(edSetSize.Text));
  takenAt := StrToInt(Trim(edTakenAt.Text));
  minLen := StrToInt(Trim(edMinLen.Text));

  lblCombinationCount.Caption := IntToStr(CombinationCount(num, takenAt));
  lblPermutationCount.Caption := IntToStr(PermutationCount(num, takenAt));
  lblPermutationExCount.Caption := IntToStr(
                                  PermutationCount_ex(num, takenAt, minLen));
end;

procedure TV.ActWrtWords2WordscapeExecute(Sender: TObject);
var
  i : Integer;
  //startTime: TTime;
  tx: TSQLTransaction;
  qry: TSQLQuery;
begin
{$IFDEF SEEWORDS}
  mmoWords.Lines.Clear;
{$ENDIF}
  if not cleanWordsTable then
    Exit;
  pgBar.Min := 0;
  pgBar.Max := FLst4Words.Count;
  pgBar.Position := 0;
  //startTime := Now;

  //Word_Dmod.DbConn.Trace();
  qry := TSQLQuery.Create(self);

  i := 0;

  try
    qry.DataBase := Word_Dmod.OpenDbConnection(tx);
    qry.Transaction := tx;
    qry.SQL.Add(WORDS_INSERT_SQL);

    //qry.Params[0].DataType := ftString;
    qry.Prepare;
    pgBar.Visible := True;
    tx.StartTransaction;
    try
      while i < FLst4Words.Count - 1 do
      begin
        //if RegEx.IsMatch(FLst4Words.Strings[i]) then
        //begin
        //  FLst4Words.Delete(i);
        //  Continue;
        //end;
        {$DEFINE SEEWORDS}
        {$IFDEF SEEWORDS}
        mmoWords.Lines.Add(FLst4Words.Strings[i]);
        {$ENDIF}
        // process the line
        qry.Params[0].AsString := FLst4Words.Strings[i];
        qry.ExecSQL;
        if i mod 50 = 0 then
        begin
          if i mod 1000 = 0 then
          begin
            tx.Commit;
            tx.StartTransaction;
            Application.ProcessMessages;
          end;
          if i mod 100 = 0 then
          begin
            pgBar.Position := i;
            pgBar.Repaint;

            //lblElapsedTime.Caption := SecondsBetween(Now, startTime).ToString;
            //lblElapsedTime.Repaint;
            //estimatedTimeOfCompletion(startTime, rows2Ps, i);
          end;
          //lblCurRow.Caption := i.ToString;
          //lblCurRow.Repaint;
        end;

        Inc(i);
      end;
      tx.Commit;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
        tx.Rollback;
      end;

    end;
  finally
    qry.Free;
{$IFDEF SEEWORDS}
    mmoWords.Visible := True;
{$ENDIF}
    pgBar.Visible := False;
  end;
end;

end.
