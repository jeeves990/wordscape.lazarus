unit WordScapes;

{$MODE Delphi}

interface

uses
  windows, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Forms, Frame4WS,
  ProcessWords2Db_controller, Strings, IDETheme.ActnCtrls,
  WordDmod, SQLDB, ActnList, GetParams4Read,
	Menus;

type


	{ TNodeWalker }

  TNodeWalker = class(TTreeView)
  private
    rootNode: TTreeNode;
    FTree: TTreeView;
    //Stack: TObjectStack;
    procedure SetTree(const Value: TTreeView);
    destructor Destroy; reintroduce;
    function _getFirstChild(parent: TTreeNode): Boolean;
    function _getSiblings(node: TTreeNode): Boolean;
  public
    property Tree: TTreeView write SetTree;
    constructor Create(owner: TComponent); reintroduce;
  end;

    { TV }

  TV = class(TForm)
				ActGetFile: TAction;
				ActLoadSelection: TAction;
				ActLoadWords: TAction;
    btmPanelTab2: TPanel;
		Label2: TLabel;
		lblDatabaseName: TLabel;
		mmoWords: TMemo;
		Panel1: TPanel;
		pnlDbOpsFiller: TPanel;
    Splitter1: TSplitter;
    capIterator: TLabel;
    lblIteratorI: TLabel;
    capLvl: TLabel;
    lblLvl: TLabel;
    capRootChar: TLabel;
    lblRootChar: TLabel;
    pgBar: TProgressBar;
		Splitter2: TSplitter;
		Splitter3: TSplitter;
		SQLQuery1: TSQLQuery;
		tabDbOps: TTabSheet;
    topPanelTab2: TPanel;
    edCharString: TEdit;
    BtnBuildTree: TButton;
    pgCtrl: TPageControl;
    tabSheetMain: TTabSheet;
    lblTvuItemCount: TLabel;
    edTvuItmCount: TEdit;
    capMaxCount: TLabel;
    edMaxCount: TEdit;
    tvu: TTreeView;
    ActLst4WordScapes: TActionList;
    ActBldTree: TAction;
    ActPsWordList: TAction;
    lblFinalCount: TLabel;
    Label1: TLabel;
    ActEnableMnMnu: TAction;
    mnMnu: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    CC1: TMenuItem;
    actClose: TAction;
    mnuPsOptions: TMenuItem;
    Buildtree1: TMenuItem;
    Processwordlist1: TMenuItem;
    btnPsWordList: TButton;
		procedure ActLoadSelectionExecute(Sender: TObject);
  procedure ActLoadWordsExecute(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure lblDatabaseNameClick(Sender: TObject);
    procedure tvuChange(Sender: TObject; Node: TTreeNode);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActBldTreeExecute(Sender: TObject);
    procedure ActPsWordListExecute(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure edCharStringKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
		FFileName: TFileName;
    FLst4Words : TStringList;
		procedure ActGetFromDbExecute(Sender: TObject);
		procedure ActWrtWords2WordscapeExecute(Sender: TObject);
    procedure AddTheChildren(Str: string; lvl: Integer; ParmNode: TTreeNode);
		function cleanWordsTable: Boolean;
    function GetFactorial(num: Integer): Integer;
    function CombinationCount(num: Integer): Integer;
    function AddThisLevelsChildren(_str: string; Parent: TTreeNode): TTreeNode;

		function GetLmtClause: UTF8String;
		function ParseLmtClause(var startAt, howMany: Integer): Boolean;

    function PermutationCount(const num_chars, num_diff_chars: Integer;
					const use_3_chars: Boolean): Integer;
		procedure SetLmtClause(AValue: UTF8String);
		procedure OpenDbConnection;
    procedure UpdateProgressBar;
    procedure AddPages;
    procedure FrmPsWordsFormClose(Sender: TObject);
  public
    property FLmtClause: UTF8String read GetLmtClause write SetLmtClause;
  end;

var
  V: TV;

implementation

{$R *.lfm}

var
  //globLevel: SmallInt;
  MaxLevels: Integer;

const
  First = 1;
  SQL_get_words_cnt = 'SET ' + #64 + 'cnt := 0';
  SQL_get_words_W_count = 'select (%scnt := %scnt +1) RowNbr, word from words '
    + 'CROSS JOIN (SELECT %scnt := 0) AS dummy  %s';
  SQL_get_words = 'select word from words %s';

{ TNodeWalker }

procedure TNodeWalker.SetTree(const Value: TTreeView);
begin

end;

destructor TNodeWalker.Destroy;
begin

end;

function TNodeWalker._getFirstChild(parent: TTreeNode): Boolean;
begin

end;

function TNodeWalker._getSiblings(node: TTreeNode): Boolean;
begin

end;

constructor TNodeWalker.Create(owner: TComponent);
begin

end;

function TV.CombinationCount(num: Integer): Integer;
var
  fctrl, i: Integer;
begin
  fctrl := 1;
  i := num - 1;
  while i > 0 do
  begin
    fctrl := fctrl * num;
    Inc(i, -1);
  end;
  Result := fctrl;
end;

procedure TV.edCharStringKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ActBldTree.Execute;
end;

function TV.PermutationCount(const num_chars, num_diff_chars: Integer;
  const use_3_chars: Boolean): Integer;
{
  function TV.PermutationCount(const num_chars, num_diff_chars: Integer;
  const use_3_chars : Boolean): Integer;
  permutation count for 3 taken 3 at a time is 1.
  --------------------- 3 taken 2 at a time is

}
var
  iCnt: Integer;
begin

end;

procedure TV.SetLmtClause(AValue: UTF8String);
begin
  FLmtClause := AValue;
end;

procedure TV.OpenDbConnection;
begin

end;

function TV.GetFactorial(num: Integer): Integer;
var
  fctrl: Integer;
begin
  fctrl := num;
  num := num - 1;
  while num > 1 do
  begin
    fctrl := fctrl * num;
  end;
  Result := fctrl;
end;

function CleanDuplicateChars(Str: string): string;
var
  rslt: string;
  i: Integer;
begin
  rslt := '';
  Str := AnsiUpperCase(Str);
  for i := 1 to Length(Str) do
    if (Str[i] >= 'A') and (Str[i] <= 'Z') and (not rslt.Contains(Str[i])) then
      rslt := Concat(rslt, Str[i]);
  Result := rslt;
end;

function CleanString(Str: string): string;
var
  rslt: string;
  i: Integer;
begin
  rslt := '';
  Str := AnsiUpperCase(Str);
  for i := 1 to Length(Str) do
    if (Str[i] >= 'A') and (Str[i] <= 'Z') then
      rslt := Concat(rslt, Str[i]);
  Result := rslt;
end;

procedure TV.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TV.FrmPsWordsFormClose(Sender: TObject);
begin
  FrmPsWordsFile.Free;
end;

procedure TV.ActPsWordListExecute(Sender: TObject);
begin
  if FrmPsWordsFile = nil then
    FrmPsWordsFile := TFrmPsWords2DBController.Create(self);
  FrmPsWordsFile.Position := poMainFormCenter;
  FrmPsWordsFile.Show;
end;

procedure TV.AddPages;
var
  i: Integer;
  Str: string;
begin
  Str := edCharString.Text;
  i := pgCtrl.PageCount - 1;
  while i > 1 do
  begin
    pgCtrl.Pages[i].Free;
    { TStringGrid and TPanel need to be freed }
    Inc(i, -1);
  end;

end;

procedure TV.ActBldTreeExecute(Sender: TObject);
var
  i, lvl: Integer;
  Str: string;
  Node, firstNode: TTreeNode;
begin
  AddPages;
  edTvuItmCount.Text := '';
  Str := CleanString(edCharString.Text);
  if Length(Str) = 0 then
    Exit;

  pgBar.Min := 0;
  pgBar.Position := 0;
  pgBar.Visible := True;

  tvu.Items.Clear;

  try
    begin
      { lst.Count factorial permutation count of the cnaracters of Str }
      MaxLevels := Length(Str);
      // pgBar.Max := CombinationCount(GetFactorial(MaxLevels), MaxLevels);
      pgBar.Max := CombinationCount(MaxLevels);
      edMaxCount.Text := pgBar.Max.ToString;
      edMaxCount.Update;

      {
        this iteration "primes" the tree with the first level from
        the string. I.e., if the string is 'revenge', nodes are
        added to the root of 'r', 'e', 'v', 'e', 'n', 'g' and 'e'.
      }
      firstNode := tvu.Items.AddFirst(nil, Str[1]);
      { the first level does not have to have duplicate letters }
      Str := CleanDuplicateChars(Str);
      for i := 2 to Length(Str) do
      begin
        tvu.Items.Add(firstNode, Str[i]);
        { siblings of firstNode }
      end;
      { restore the string }
      Str := CleanString(edCharString.Text);
      { everything is good here }

      try
        tvu.Items.BeginUpdate;
        Node := tvu.Items.GetFirstNode;
        lvl := 0;
        //globLevel := lvl;
        while Node <> nil do
        begin
          lblRootChar.Caption := Concat('---', Node.Text, '---');
          // tvu.FullExpand;
          // tvu.Items.BeginUpdate;
          AddTheChildren(Str, lvl, Node);
          Node := Node.getNextSibling;
        end;
      finally
        tvu.FullExpand;
        tvu.Select(firstNode);
        firstNode.MakeVisible;
        tvu.Items.EndUpdate;
        tvu.SetFocus;
        edTvuItmCount.Text := tvu.Items.Count.ToString;
        pgBar.Visible := False;
        lblFinalCount.Caption := tvu.Items.Count.ToString;
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

{
  TFrmWordScapes.AddThisLevelsChildren
  parameters:
  _str is the part of the string originally provided by the user that is left
  Parent is the parent node for the branch of the tree
  returns the first node added
}
function TV.AddThisLevelsChildren(_str: string; Parent: TTreeNode): TTreeNode;
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

function TV.GetLmtClause: UTF8String;
begin
  Result := FLmtClause;
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
procedure TV.AddTheChildren(Str: string; lvl: Integer; ParmNode: TTreeNode);
var
  a_node: TTreeNode;
begin

  { remove the ParmNode.Text character from Str to prevent re-use }
  Str := removeParmNodeTextChar(Str, ParmNode.Text[1]);

  Inc(lvl); { each call to AddTheChildren moves us down to another level }
  //globLevel := lvl;
  { but, we can only go to the max levels (the length of the original string }
  if lvl > MaxLevels then
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
  { good to here }

  { add the children for this first node. Add a_node's siblings' children
    in the following step }
  // AddTheChildren(Str, lvl, a_node);

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

procedure TV.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FLst4Words) then
    FLst4Words.Free;
end;

procedure TV.lblDatabaseNameClick(Sender: TObject);
begin

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
  edCharString.SetFocus;
end;

procedure TV.FormCreate(Sender: TObject);
begin
{$IFDEF STAY_TOP}
  SetWindowPos(self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
{$ENDIF}
  Word_Dmod := TWord_Dmod.Create(self);
end;

procedure TV.FormShow(Sender: TObject);
begin
  // MnMnu := nil;
end;

function TV.ParseLmtClause(var startAt, howMany: Integer): Boolean;
var
  i, segSize: Integer;
  iValue, iCode: Integer;
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

procedure TV.ActGetFromDbExecute(Sender: TObject);
var
  q: TSQLQuery;
  i, segSize: Integer;
  s: string;
  tx : TSQLTransaction;
begin
  q := TSQLQuery.Create(self);
  q.DataBase := Word_Dmod.OpenDbConnection(tx);
  q.Transaction := tx;

  lblDatabaseName.Caption := q.DataBase.Name;
  try
    q.SQL.Clear;
    q.SQL.Add(SQL_get_words_cnt);
    q.Prepare;

    try
      tx.StartTransaction;
      q.ExecSQL;
      tx.Commit;
    except
      on E: Exception do
      begin
        ShowMessage(Concat('ActGetFromDbExecute:', sLineBreak, E.Message));
        tx.Rollback;
        raise;
      end;
    end;

    q.SQL.Clear;
    s := Format(SQL_get_words, [FLmtClause]);
    q.SQL.Add(s);
    tx.StartTransaction;
    try
      q.Open;
      if q.RecordCount = 0 then
        Exit;
      mmoWords.Lines.Clear;
      pgBar.Min := 0;
      pgBar.Max := q.RecordCount;
      pgBar.Position := 0;
      i := 0;
      pgBar.Visible := True;
      segSize := q.RecordCount div 100;
      { divide up segments for the pgBar }
      if segSize = 0 then
        segSize := 1;

      while not q.Eof do
      begin
        mmoWords.Lines.Add(q.Fields[0].AsString);
        q.Next;
        Inc(i);
        if (i > 0) and (i mod segSize = 0) then
          pgBar.Position := i;
      end;
    finally
      tx.Rollback;
      q.DataBase.Close(True);
    end;
  finally
    q.Free;
    pgBar.Visible := False;
    q.DataBase.Close(True);
  end;
end;

{
  function TV.cleanWordsTable: boolean;
  A DANGEROUS FUNCTION
}
function TV.cleanWordsTable: Boolean;
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
  if FrmGetDbParamsDlg = nil then
    FrmGetDbParamsDlg := TFrmGetDbParams.Create(self);

  FrmGetDbParamsDlg.Position := poMainFormCenter;
  FrmGetDbParamsDlg.ShowModal;
  FLmtClause := FrmGetDbParamsDlg.FLmtClause;
  ParseLmtClause(startsAt, howMany);
end;

procedure TV.ActLoadWordsExecute(Sender: TObject);
var
  strm: TFileStream;
begin
  ActLoadSelection.Execute;
  try
    strm := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      if not Assigned(FLst4Words)
        FLst4Words := TStringList.Create;
      FLst4Words.LoadFromStream(strm);
    finally
      strm.Free;
    end;
    psTextFile(sLst4Words);
  except
    on E: Exception do
      ShowMessage(Concat('ActLoadWordsExecute: ', sLineBreak, E.Message));
  end;
end;

procedure TV.ActWrtWords2WordscapeExecute(Sender: TObject);
var
  i, rows2Ps: Integer;
  startTime: TTime;
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
  rows2Ps := FLst4Words.Count;
  lblRows2Ps.Caption := rows2Ps.ToString;
  lblRows2Ps.Invalidate;
  pgBar.Position := 0;
  startTime := Now;

  Word_Dmod.DbConn.Trace();
  qry := TSQLQuery.Create(self);   \

  i := 0;

  try
    qry.DataBase := Word_Dmod.OpenDbConnection(tx);
    qry.Transaction := tx;
    qry.SQL.Add(WORDS_INSERT_SQL);

    qry.Params[0].DataType := ftString;
    qry.Prepare;
    pgBar.Visible := True;
    tx.StartTransaction;
    try
      while i < FLst4Words.Count - 1 do
      begin
        if RegEx.IsMatch(FLst4Words.Strings[i]) then
        begin
          FLst4Words.Delete(i);
          Continue;
        end;
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

            lblElapsedTime.Caption := SecondsBetween(Now, startTime).ToString;
            lblElapsedTime.Repaint;
            estimatedTimeOfCompletion(startTime, rows2Ps, i);
          end;
          lblCurRow.Caption := i.ToString;
          lblCurRow.Repaint;
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
