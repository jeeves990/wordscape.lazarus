unit WordDmod;

{$mode delphi}
{$DEFINE DEBUG}

interface

uses
  Classes, SysUtils, SQLDB, PQConnection, odbcconn, Dialogs,
  mysql57conn, mysql80conn, LMessages, LCLIntf, Messages;

type

  EWordsDbException = class(Exception);
  TCallbackMethod = procedure(msg: TMessage) of object;
  { TWord_Dmod }

  TWord_Dmod = class(TDataModule)
    DbConn: TMySQL57Connection;
    DbTx: TSQLTransaction;
		qry : TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
  private

  public
    function OpenDbConnection(out param_dbTx: TSQLTransaction): TMySQL57Connection;

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
  LM_GET_MAIN_WINDOW_HANDLE = LM_USER +2;
  LM_TEST_THE_HANDLE = LM_USER +3;

var
  Word_Dmod: TWord_Dmod;
  {$IFDEF DEBUG}
  test_file_name : TFileName;
  {$ENDIF}

function multiple_chars(_s : String; multiplier : Integer): String;

implementation

{$R *.lfm}

function multiple_chars(_s : String; multiplier : Integer): String;
var
  i : Integer;
begin
  Result := EmptyStr;
  for i := 1 to multiplier do
    Result := Result +_s;
end;

function build_tst_file_name : String;
var
  dt, cwd : String;
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

function TWord_Dmod.OpenDbConnection(
  out param_dbTx: TSQLTransaction): TMySQL57Connection;
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

initialization
  {$IFDEF DEBUG}
  test_file_name := build_tst_file_name;
  {$ENDIF}

end.
