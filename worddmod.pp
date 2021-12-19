unit WordDmod;

{$mode delphi}
{$DEFINE DEBUG}

interface

uses
  Classes, SysUtils, SQLDB, BufDataset, DB, memds, PQConnection, odbcconn,
  Dialogs, mysql57conn, mysql80conn, LMessages, LCLIntf, Messages, fgl, Grids,
  ExtCtrls, Contnrs;

type
  { TPgBarOps }
  TPgBarOps = record
    arg, max, step: integer;
  end;

  EWordsDbException = class(Exception);
  TCallbackMethod = procedure(msg: TMessage) of object;
  TObjectListCallbackMethod = procedure(lst: TObjectList) of object;
  TStringListCallbackMethod = procedure(lst: TStringList) of object;
  TStringStreamCallbackMethod = procedure(lst: TStringStream) of object;
  TMemoryStreamCallbackMethod = procedure(strm: TMemoryStream) of object;

  TFileStreamCallbackMethod = procedure(fl: TFileStream) of object;
  TStringCallbackMethod = procedure(str: string) of object;
  TPgBarCallbackMethod = procedure(rec: TPgBarOps) of object;
  TTimerTimeoutMethod = procedure(Sender: TObject) of object;
  TIntegerCallbackMethod = procedure(_int_: integer) of object;
  TStatBarCallbackMethod = procedure(msg: string) of object;

const
  INIT_PGBAR = -1;
  MARQUEE_PGBAR = 0;
  STEP_PGBAR = 1;

type
  { TWord_Dmod }

  TWord_Dmod = class(TDataModule)
    sqlConn: TMySQL57Connection;
    qry: TSQLQuery;
    tx: TSQLTransaction;
    //WordBufList: TStringList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  public
    StatBarCallback: TStatBarCallbackMethod;
    PgBarCallback: TPgBarCallbackMethod;

    procedure Populate_WordBufList(lst: TStrings);
    function Open_word_db : Boolean;
    function Close_word_db : Boolean;
		function Do_exec_sql(_sql : String) : Boolean;
  end;

  { TMyObjList }

  TMyObjList = class(TObjectList)
    procedure Free; reintroduce;
  end;

  { TLeafList_file }
  TLeafList_file = class(TFileStream)
    FFileName: string;
    FStr_len: integer;
    FDir: TFileName;

  public
    constructor Create(const str_len: integer); reintroduce;
  end;

  { TLeafList_file_list }
  TLeafList_file_list = class(TObjectList)
  public
    constructor Create(file_count: integer);
  end;

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

  MAX_SQL_PARM_LEN = 16000;
  ALPHA_CHARS = ['A'..'Z', 'a'..'z'];

var
  Word_Dmod: TWord_Dmod;
  {$IFDEF DEBUG}
  test_file_name: TFileName;

  {$ENDIF}

function multiple_chars(_s: string; multiplier: integer): string;
procedure Clear_string_grid(sgrid: TStringGrid;
  col_count: integer = 1;
  row_count: integer = 1;
  fixed_col_count: integer = 1;
  fixed_row_count: integer = 1);


var
  Temp_dir, Temp_file_name: ansistring;
  WordsFile: TFileName;

procedure Get_temp_file_name;
function isRowEmpty(grid: TStringGrid; row : Integer) : Boolean;

implementation

uses StrUtils;

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

procedure Clear_string_grid(sgrid: TStringGrid;
  col_count: integer; row_count: integer;
  fixed_col_count: integer; fixed_row_count: integer);
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

function isRowEmpty(grid: TStringGrid; row : Integer) : Boolean;
var
  col : Integer;
begin
  Result := True;
  for col := 0 to grid.ColCount -1 do
     if grid.Cells[col, row] > '' then
       begin
         Result := False;
         Exit;
		   end;
end;


{ TLeafList_file_list }

constructor TLeafList_file_list.Create(file_count: integer);
var
  i: integer;
  obj: TLeafList_file;
begin
  inherited Create(True);
  i := 0;
  while i < file_count do
  begin
    obj := TLeafList_file.Create(i + 2);
    self.Add(obj);
    Inc(i);
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
begin
  StatBarCallback := nil;
  PgBarCallback := nil;
  sqlConn.Close(True);
end;

procedure TWord_Dmod.DataModuleDestroy(Sender: TObject);
begin
  //FreeAndNil(WordBufList);
end;

procedure TWord_Dmod.Populate_WordBufList(lst: TStrings);
var
  i: integer;
  pbRec: TPgBarOps;
begin
  //WordBufList.AddStrings(lst);
  //i := WordBufList.Count;
  //Exit;
end;

function TWord_Dmod.Open_word_db : Boolean;
var
  i : Integer;
begin
  sqlConn.Open;
  Result := sqlConn.Connected;
  i := 0;
  if Result then Exit;

  repeat
      Sleep(250);
      sqlConn.Open;
      Result := sqlConn.Connected;
      if Result then
        Exit;
  until i = 5;

  raise EDatabaseError.Create('TWord_Dmod.Open_word_db: failed to open');
end;

function TWord_Dmod.Close_word_db : Boolean;
begin
  sqlConn.Close(True);
  Result := not sqlConn.Connected;
end;

function TWord_Dmod.Do_exec_sql(_sql : String): Boolean;
var
  q : TSQLQuery;
begin
  Result := False;
  q := TSQLQuery.Create(self);
  try
    q.DataBase := sqlConn;
    q.Transaction := tx;
    q.SQL.Text := _sql;
    try
        q.ExecSQL;
        Word_Dmod.tx.Commit;
        Result := True;
		except
      on Ex : EDatabaseError do
      begin
        if AnsiContainsText(Ex.Message, 'duplicate') then
          Exit;

        ShowMessage('TV.ActAdd_2_dbExecute: database exception: ' +Ex.Message);
        Word_Dmod.tx.Rollback;
			end;
			on Ex : Exception do
      begin
        ShowMessage('TV.ActAdd_2_dbExecute: unknown exception: ' +Ex.Message);
        tx.Rollback;
			end;
		end;
	finally
    q.Free;
	end;

end;

{ TLeafList_file }

constructor TLeafList_file.Create(const str_len: integer);
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
