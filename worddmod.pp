unit WordDmod;

{$mode delphi}
{$DEFINE DEBUG}

interface

uses
  Classes, SysUtils, SQLDB, PQConnection, odbcconn, Dialogs,
  mysql57conn, mysql80conn, LMessages, LCLIntf, Messages, fgl,
  Grids, ExtCtrls, Contnrs;

type
  { TPgBarOps }
  TPgBarOps = record
    arg, max, step : Integer;
	end;

  EWordsDbException = class(Exception);
  TCallbackMethod = procedure(msg: TMessage) of object;
  TObjectListCallbackMethod = procedure(lst: TObjectList) of object;
  TStringListCallbackMethod = procedure(lst: TStringList) of object;
  TStringStreamCallbackMethod = procedure(lst: TStringStream) of object;
  TMemoryStreamCallbackMethod = procedure(strm: TMemoryStream) of object;

  TFileStreamCallbackMethod = procedure(fl: TFileStream) of object;
  TStringCallbackMethod = procedure(str : String) of object;
  TPgBarCallbackMethod = procedure(rec : TPgBarOps) of object;
  TTimerTimeoutMethod = procedure(Sender : TObject) of object;
  TIntegerCallbackMethod = procedure(_int_ : Integer) of object;

  { TWord_Dmod }

  TWord_Dmod = class(TDataModule)
    DbConn: TMySQL57Connection;
    DbTx: TSQLTransaction;
    qry: TSQLQuery;
		Gen_timer : TTimer;
    procedure DataModuleCreate(Sender: TObject);
  private

  protected
  public
    function OpenDbConnection(out param_dbTx: TSQLTransaction): TMySQL57Connection;
		procedure Gen_timer_OnTimer(Sender : TObject);
  end;

	{ TMyObjList }

  TMyObjList = class (TObjectList)
    procedure Free; reintroduce;
	end;

  { TLeafList_file }
  TLeafList_file = class(TFileStream)
    FFileName : String;
    FStr_len : Integer;
    FDir : TFileName;

    public
      constructor Create(const str_len : Integer); reintroduce;
      //function Read_next : String;
      //procedure Write(const str : String);
	end;

  { TLeafList_file_list }
  TLeafList_file_list = class(TObjectList)
    public
      constructor Create(file_count : Integer);
	end;

  //TTreeNodeList = specialize TFPGList<TTreenode>;
  TTreeNodeList =  TFPGObjectList<TTreenode>;

var
  MainFormHandle: THandle;

const
  WORDS_INSERT_SQL = 'insert into words (word) values (:word)';
  LMT2_1000 = ' Limit 0,1000 ';
  LMTLOADALL = ' ';
  LMTSELECT = ' Limit %s, %s ';
  COMMA = #44;
  SPACE = #32;
  DOUBLEQUOTE = '"';

  LM_POP_RAW_WORDS = LM_USER + 1;
  LM_GET_MAIN_WINDOW_HANDLE = LM_USER + 2;
  LM_TEST_THE_HANDLE = LM_USER + 3;

  MAX_COL_VALUE_STR_LEN = 4800;

var
  Word_Dmod: TWord_Dmod;
  {$IFDEF DEBUG}
  test_file_name: TFileName;

  {$ENDIF}

function multiple_chars(_s: string; multiplier: integer): string;
procedure Clear_string_grid(sgrid : TStringGrid;
                            col_count : integer = 1;
                            row_count : integer = 1;
                            fixed_col_count : integer = 1;
                            fixed_row_count : integer = 1);


var
  Temp_dir, Temp_file_name : AnsiString;

procedure Get_temp_file_name;

implementation

{$R *.lfm}

procedure Get_temp_file_name;
begin
  Temp_dir := GetTempDir;  // build a temporary directory private to me
  Temp_file_name := GetTempFileName(Temp_dir, 'WordScape-');
end;

function multiple_chars(_s: string; multiplier: integer): string;
var
  i: integer;
begin
  Result := EmptyStr;
  for i := 1 to multiplier do
    Result := Result + _s;
end;

procedure Clear_string_grid(sgrid : TStringGrid;
                        col_count : integer; row_count : integer;
			fixed_col_count : integer; fixed_row_count : integer);
begin
  sgrid.Clear;
  sgrid.ColCount := col_count;
  sgrid.RowCount := row_count;
  sgrid.FixedCols := fixed_col_count;
  sgrid.FixedRows := fixed_row_count;
end;

function build_tst_file_name: string;
var
  dt, cwd: string;
begin
  dt := FormatDateTime('YYYYMMDD-hh-nn', Now);
  cwd := GetCurrentDir;
  Result := dt + '--Test_file.txt';
  Result := ConcatPaths([cwd, Result]);
end;

procedure Button1Click(Sender: TObject);
var
  Texto: string;
  Output: array [1..20] of byte;
  i: integer;
begin
  Texto := '';
  for i := 1 to 20 do
    Texto := Texto + IntToHex(Output[i], 1);
  ShowMessage(Texto);

end;

{ TLeafList_file_list }

constructor TLeafList_file_list.Create(file_count : Integer);
var
  i : Integer;
  obj : TLeafList_file;
begin
  inherited Create(True);
  i := 0;
  while i < file_count do
  begin
    obj := TLeafList_file.Create(i +2);
    self.Add(obj);
    Inc(i)
	end;
end;

{ TMyObjList }

procedure TMyObjList.Free;
begin
  while Count > 0 do
    if self[0] <> nil then
      self.Remove(self[0]);
end;

{ TWord_Dmod }

procedure TWord_Dmod.DataModuleCreate(Sender: TObject);
var
  tx: TSQLTransaction;
begin
  try
    try
      OpenDbConnection(tx);
      DbTx.DataBase := DbConn;
      DbTx.StartTransaction;
      DbTx.Rollback;
    except
      on e: Exception do
        ShowMessage(e.Message);
    end;
  finally
    DbConn.Close(True);
  end;
end;

procedure TWord_Dmod.Gen_timer_OnTimer(Sender : TObject);
begin

end;

function TWord_Dmod.OpenDbConnection(out param_dbTx: TSQLTransaction):
TMySQL57Connection;
begin
  if not DbConn.Connected then
    DbConn.Open; // (connStr);
  if not DbConn.Connected then
    raise EWordsDbException.Create('Database connection failed')
  else
  begin
    param_dbTx := DbTx;
    Result := DbConn;
  end;
end;

{ TLeafList_file }

constructor TLeafList_file.Create(const str_len : Integer);
begin
  Get_temp_file_name;
  FDir := Temp_dir;
  FFileName := Temp_file_name;
  inherited Create(FFileName, fmOpenReadWrite);
end;



initialization
  {$IFDEF DEBUG}
  test_file_name := build_tst_file_name;
  {$ENDIF}

end.








