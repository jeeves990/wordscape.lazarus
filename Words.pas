unit Words;
(*
    unit Words is the controller for LoadWordsFromFile2DB which actually
    get words from their containing text file in into the database.
    This is a preliminary function and should not be needed more than
    once per installation.
*)
{$MODE Delphi}

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, ComCtrls, SQLDB, DB, ExtCtrls,
  DateUtils, Menus, LoadWordsFromFile2DB;

type

	{ TFrmPsWords2DBController }

  TFrmPsWords2DBController = class(TForm)
    mmoWords: TMemo;
    ToolBar1: TToolBar;
    Acts4Words: TActionList;
    ActLoadWords: TAction;
    ActProcess: TAction;
    ActClose: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ActGetFile: TAction;
    OpnFlDlg: TOpenDialog;
    ToolButton4: TToolButton;
    ActOpnDb: TAction;
    ToolButton5: TToolButton;
    Panel1: TPanel;
    pgBar: TProgressBar;
    ToolButton6: TToolButton;
    ActWrtWords2Wordscape: TAction;
    ActLoad1st1000: TAction;
    MnMnuWords: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Findtextfile1: TMenuItem;
    Loadwordsfromfile1: TMenuItem;
    Writetodatabase1: TMenuItem;
    Opendatabase1: TMenuItem;
    Writewordstodatabase1: TMenuItem;
    ActLoadAll: TAction;
    ActLoadSelection: TAction;
    Makeselection1: TMenuItem;
    N2: TMenuItem;
    Splitter1: TSplitter;
    Button1: TButton;
    PnlInfoEncompass: TPanel;
    PnlDbInfo: TPanel;
    capDbName: TLabel;
    lblDatabaseName: TLabel;
    capRows2Ps: TLabel;
    lblRows2Ps: TLabel;
    capCurRow: TLabel;
    lblCurRow: TLabel;
    capStartTime: TLabel;
    lbllblStartTime: TLabel;
    capElapsedTime: TLabel;
    lblElapsedTime: TLabel;
    capEstTmOfCompletion: TLabel;
    lblEstTmOfCompletion: TLabel;
    capElapsTmToRemaining: TLabel;
    lblElapsTmToRemaining: TLabel;
    capMinutes: TLabel;
    Label1: TLabel;
    PnlTxtFileInfo: TPanel;
    capFilename: TLabel;
    lblTextFileName: TLabel;
    procedure ActCloseExecute(Sender: TObject);
    procedure ActLoadWordsExecute(Sender: TObject);
    procedure ActGetFileExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure ActOpnDbExecute(Sender: TObject);
    procedure ActWrtWords2WordscapeExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Close1Click(Sender: TObject);
    procedure ActLoadSelectionExecute(Sender: TObject);
  private
    FileName: UTF8String;
    FLst4Words: TStringList;
    FrmLoadFileDlg: TFrmLoadWordsFromFile2DB;
    procedure SetFlName(Value: UTF8String);
    function GetFlName: UTF8String;
    procedure psTextFile(var sl: TStringList);
    function cleanWordsTable: boolean;
    function estimatedTimeOfCompletion(startTime: TTime;
      txTotal, rowsProcessed: Integer): TDateTime;
  published
    property FFileName: UTF8String read GetFlName write SetFlName;

  end;

var
  FrmPsWordsFile: TFrmPsWords2DBController;

implementation

{$R *.lfm}

uses
  WordDmod;

procedure TFrmPsWords2DBController.SetFlName(Value: UTF8String);
begin
  if FileName = '' then
    ActGetFile.Execute
  else
    FileName := Value;
end;

procedure TFrmPsWords2DBController.ActGetFileExecute(Sender: TObject);
begin
  ActLoadWords.Enabled := False;
  try
    if OpnFlDlg.Execute then
    begin
      FileName := OpnFlDlg.FileName;
      lblTextFileName.Caption := FileName;
      ActLoadWords.Enabled := True;
    end
    else
    begin
      ShowMessage(Concat(FFileName, ' not found.'));
      lblTextFileName.Caption := 'No file found';
    end;
  finally
  end;
end;

function TFrmPsWords2DBController.GetFlName: UTF8String;
begin
  Result := FileName;
end;

procedure TFrmPsWords2DBController.psTextFile(var sl: TStringList);
var
  i: Integer;
begin
  mmoWords.Lines.Clear;
  mmoWords.Visible := False;
  pgBar.Min := 0;
  pgBar.Max := sl.Count;
  pgBar.Position := 0;
  i := 0;
  try
    pgBar.Visible := True;
    while i < sl.Count - 1 do
    begin
      //if RegEx.IsMatch(sl.Strings[i]) then
      //begin
      //  sl.Delete(i);
      //  Continue;
      //end;
      //mmoWords.Lines.Add(sl.Strings[i]); // process the line
      //if i mod 100 = 0 then
      //begin
      //  pgBar.Position := i;
      //  if i = 1000 then
      //    Break;
      //end;
      //Inc(i);
    end;
  finally
    mmoWords.Visible := True;
    pgBar.Visible := False;
  end;
end;

procedure TFrmPsWords2DBController.ActCloseExecute(Sender: TObject);
begin
  FreeAndNil(FrmLoadFileDlg);
  Close;
end;

procedure TFrmPsWords2DBController.ActLoadSelectionExecute(Sender: TObject);
begin
  if FrmLoadFileDlg = nil then
    FrmLoadFileDlg := TFrmLoadWordsFromFile2DB.Create(self);

  FrmLoadFileDlg.Position := poMainFormCenter;
  FrmLoadFileDlg.ShowModal;
end;

procedure TFrmPsWords2DBController.ActLoadWordsExecute(Sender: TObject);
var
  strm: TFileStream;
begin
  ActLoadSelection.Execute;
  try
    strm := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
    try
      FLst4Words.LoadFromStream(strm);
    finally
      strm.Free;
    end;
    psTextFile(FLst4Words);
  except
    on E: Exception do
      ShowMessage(Concat('ActLoadWordsExecute: ', sLineBreak, E.Message));
  end;
end;

//procedure TFrmPsWords2DBController.ActOpnDbExecute(Sender: TObject);
// DEPRECATED: use Word_Dmod.OpenDbConnection(tx);
//var
//  fdConn: TSQLConnection;
//  opnDlg: TFrmLoadWordsFromFile2DB;
//begin
//  try
//    opnDlg := TFrmLoadWordsFromFile2DB.Create(self);
//    opnDlg.ShowModal;
//  finally
//    opnDlg.Free;
//  end;
//  fdConn := Word_Dmod.DbConn;
//  try
//    if not fdConn.Connected then
//      fdConn.Open; // (connStr);
//  finally
//    if not fdConn.Connected then
//      lblDatabaseName.Caption := 'Database connection failed'
//    else
//      //lblDatabaseName.Caption := fdConn.ConnectionName;
//  end;
//end;

function TFrmPsWords2DBController.estimatedTimeOfCompletion(startTime: TTime;
  txTotal, rowsProcessed: Integer): TDateTime;
var
  psTimeSoFar: TTime;
  rowsRemaining: Integer;
  segmentsRemaining: Integer;
  TimeAtEndOfProcessing: TDateTime;
  timeRemaining: Double;
begin
  psTimeSoFar := Now - startTime; // it took this much time
  rowsRemaining := txTotal - rowsProcessed;
  // so how many remaining segments the size of rowsRemaining are there?
  if rowsProcessed = 0 then
    Exit;
  segmentsRemaining := rowsRemaining div rowsProcessed; // is how many.
  // so,
  TimeAtEndOfProcessing := Now + (segmentsRemaining * psTimeSoFar);
  Result := TimeAtEndOfProcessing;
  lblEstTmOfCompletion.Caption := DateTimeToStr(TimeAtEndOfProcessing);

  timeRemaining := segmentsRemaining * psTimeSoFar;

  // lblElapsTmToRemaining.Caption := (Round(Frac(timeRemaining)*60)).ToString;
end;

{
  function TFrmPsWords2DBController.cleanWordsTable: boolean;

}
function TFrmPsWords2DBController.cleanWordsTable: boolean;
const
  SQL = 'delete from words';
var
  qry: TSQLQuery;
  tx: TSQLTransaction;
  fdConn: TSQLConnection;
begin
  Result := False;

  qry := TSQLQuery.Create(self);
  qry.DataBase := Word_Dmod.OpenDbConnection(tx);
  try
    qry.SQL.Add(SQL);
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

procedure TFrmPsWords2DBController.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmPsWords2DBController.ActWrtWords2WordscapeExecute(Sender: TObject);
var
  i, rows2Ps: Integer;
  startTime: TTime;
  tx: TSQLTransaction;
  qry : TSQLQuery;
begin
  if not cleanWordsTable then
    Exit;
  pgBar.Min := 0;
  pgBar.Max := FLst4Words.Count;
  rows2Ps := FLst4Words.Count;
  lblRows2Ps.Caption := rows2Ps.ToString;
  lblRows2Ps.Invalidate;
  pgBar.Position := 0;
  startTime := Now;
  i := 0;

  qry := TSQLQuery.Create(self);
  try
    qry.DataBase := Word_Dmod.OpenDbConnection(tx);
    qry.SQL.Add(WORDS_INSERT_SQL);
    qry.Params[0].DataType := ftString;
    qry.Prepare;
    pgBar.Visible := True;
    tx.StartTransaction;
    try
      while i < FLst4Words.Count - 1 do
      begin
        //if RegEx.IsMatch(FLst4Words.Strings[i]) then
        begin
          FLst4Words.Delete(i);
          Continue;
        end;
{$IFDEF SEEWORDS}
        mmoWords.Lines.Add(sLst4Words.Strings[i]);
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

procedure TFrmPsWords2DBController.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FLst4Words.Free;
  Action := caFree;
end;

procedure TFrmPsWords2DBController.FormCreate(Sender: TObject);
begin
  FileName := 'words.txt';
  //RegEx := TRegEx.Create(RegexPattern);
  FLst4Words := TStringList.Create;
end;

end.
