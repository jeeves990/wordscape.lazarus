unit ClassT4T_frames;

{$MODE Delphi}

interface

uses Windows, Messages, SysUtils,
  Variants, Classes, Contnrs,
  Graphics, Controls, Forms, Dialogs, Grids, ExtCtrls,
  StdCtrls, ComCtrls, Frame4WS;

type
  TFrameContent = class(TFrame)
    panel: TPanel;
    sGrid: TStringGrid;
    constructor Create(str: string; aOwner: TComponent); overload;
    destructor Destroy;
  private
    constructor Create(aOwner: TComponent); overload;
  end;

  TSpecTabSheet = class(TTabSheet)
    frameContent: TFrameContent;
    constructor Create(str: string; aOwner: TComponent);
    destructor Destroy;
  end;

  TLstOfFrames = class(TObjectList)
    destructor Destroy;
    constructor Create(str: string; aOwner: TComponent);
    procedure Add(str: string; tab_: TSpecTabSheet = nil);
  end;

implementation

constructor TSpecTabSheet.Create(str: string; aOwner: TComponent);
begin
  inherited Create(aOwner);
  frameContent := TFrameContent.Create(str, aOwner);
  frameContent.Align := alClient;
end;

destructor TSpecTabSheet.Destroy;
begin
  frameContent.Free;
  inherited;
end;

constructor TLstOfFrames.Create(str: string; aOwner: TComponent);
begin
  inherited Create;
end;

procedure TLstOfFrames.Add(str: string; tab_: TSpecTabSheet = nil);
var
  a: TSpecTabSheet;
begin
  if tab_ = nil then
    a := TSpecTabSheet.Create(str, nil);
  inherited Add(Pointer(a));
end;

destructor TLstOfFrames.Destroy;
var
  i: Integer;
begin
  i := Count - 1;
  while Count > 0 do
  begin
    try
      Items[i].Free;
      Inc(i, -1);
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
        raise;
        break;
      end;
    end;
  end;
  inherited Destroy;
end;

constructor TFrameContent.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  panel := TPanel.Create(aOwner);
  sGrid := TStringGrid.Create(aOwner);
end;

constructor TFrameContent.Create(str: string; aOwner: TComponent);
begin
  Create(aOwner);
  panel.Caption := Trim(str);
end;

destructor TFrameContent.Destroy;
begin
  panel.Free;
  sGrid.Free;
  inherited Destroy;
end;

end.
