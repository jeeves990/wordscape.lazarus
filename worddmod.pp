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
    //procedure DataModuleCreate(Sender: TObject);
  private

  public
    function OpenDbConnection(out param_dbTx: TSQLTransaction): TMySQL57Connection;
    constructor Create(Sender : TComponent);
  end;

const
  WORDS_INSERT_SQL = 'insert into words (word) values (:word)';
  LMT2_1000 = ' Limit 0,1000 ';
  LMTLOADALL = ' ';
  LMTSELECT = ' Limit %s, %s ';
  COMMA = #44;
  SPACE = #32;
  DOUBLEQUOTE = '"';
  NOTASSIGNED_INT = -9999999;

var
  Word_Dmod: TWord_Dmod;

implementation

{$R *.lfm}

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

constructor TWord_Dmod.Create(Sender : TComponent);
begin
  try
    inherited Create(Sender);
    //ShowMessage(Sender.ClassName);
	except  on E: Exception do
    ShowMessage(Concat('TWord_Dmod.Create: ', E.Message));
	end;
end;

end.
