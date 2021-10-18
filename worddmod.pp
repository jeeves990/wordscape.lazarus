unit WordDmod;

{$mode delphi}

interface

uses
  Classes, SysUtils, SQLDB, mysql57conn;

type

 EWordsDbException = class(Exception);
 { TWord_Dmod }

 TWord_Dmod = class(TDataModule)
	DbQuery: TSQLQuery;
	DbQuery1: TSQLQuery;
	DbConn: TMySQL57Connection;
	SQLScript: TSQLScript;
	DbTx: TSQLTransaction;
	procedure DataModuleCreate(Sender: TObject);
 private

 public
  function OpenDbConnection(out param_dbTx : TSQLTransaction): TMySQL57Connection;

 end;

const
  WORDS_INSERT_SQL = 'insert into words (word) values (:word)';
  LMT2_1000 = ' Limit 0,1000 ';
  LMTLOADALL = ' ';
  LMTSELECT = ' Limit %s, %s ';
  COMMA = #44;
  SPACE = #32;

var
  Word_Dmod: TWord_Dmod;

implementation

{$R *.lfm}

{ TWord_Dmod }

procedure TWord_Dmod.DataModuleCreate(Sender: TObject);
begin
  DbTx.StartTransaction;
  DbTx.Rollback;
end;

function TWord_Dmod.OpenDbConnection(out param_dbTx : TSQLTransaction) : TMySQL57Connection;
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

