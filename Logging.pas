unit Logging;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, Grids, StdCtrls;

type
  TFrmLogging = class(TForm)
    sGrid: TStringGrid;
    lblLogFileName: TLabel;
    edLogFileName: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure SetFileName(S: string);
    function GetFileName: string;
    procedure SetWriteLog(S: string);

  var
    LogFileName: string;
    LogFile: TextFile;
  public
    { Public declarations }
    property FWriteLog: string write SetWriteLog;
    property FLogFileName: string read GetFileName write SetFileName;
  end;

var
  FrmLogging: TFrmLogging;

implementation

{$R *.lfm}

procedure TFrmLogging.SetWriteLog(S: string);
var
  dt: TDateTime;
begin
  Append(LogFile);
  try
    dt := Now;
    WriteLn(LogFile, Concat(DateTimeToStr(dt), sLineBreak, S));
    sGrid.RowCount := sGrid.RowCount + 1;
    sGrid.Cells[sGrid.RowCount - 1, 0] := DateTimeToStr(dt);
    sGrid.Cells[sGrid.RowCount - 1, 1] := S;
    sGrid.Row := sGrid.RowCount - 1;
    Repaint;
  finally
    CloseFile(LogFile);
  end;
end;

procedure TFrmLogging.SetFileName(S: string);

begin
  LogFileName := S;

  AssignFile(LogFile, LogFileName);
  try
    try
      ReWrite(LogFile);
    except
      on ex: Exception do
        try
          begin
            S := ExtractFileName(S);
            LogFileName := Concat('c:\documents\', ExtractFileName(S));
            AssignFile(LogFile, LogFileName);
            ReWrite(LogFile);
          end;
        except
          on ex: Exception do
            Abort;
        end;
    end;
  finally
    begin
      edLogFileName.Text := LogFileName;
    end;
  end;
  CloseFile(LogFile);
end;

procedure TFrmLogging.FormCreate(Sender: TObject);
begin
  sGrid.RowCount := 0;
  sGrid.ColCount := 0;
end;

function TFrmLogging.GetFileName: string;
begin
  Result := LogFileName;
end;

end.
