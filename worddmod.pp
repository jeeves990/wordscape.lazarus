unit WordDmod;

{$mode delphi}

interface

uses
  Classes, SysUtils, SQLDB, PQConnection, odbcconn, Dialogs,
  mysql57conn, mysql80conn;

type

  EWordsDbException = class(Exception);
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

var
  Word_Dmod: TWord_Dmod;

implementation

{$R *.lfm}

procedure Button1Click(Sender: TObject);
var
  Texto: string;
  Output: array [1..20] of byte;
  i: integer;
begin
  //Hash := TDCP_sha1.Create(nil);
  //Hash.Init;
  //Hash.UpdateStr('j33ves99');
  //
  //
  //Hash.Final(Output);
  //Hash.Free;


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

end.
