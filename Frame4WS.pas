unit Frame4WS;

{$MODE Delphi}

interface

uses

  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Grids,
  ExtCtrls;

type
  THackSG = class(TStringGrid);
  T_frame = class(TFrame)
    PnlFrameTop: TPanel;
    sGrid: TStringGrid;
    procedure FrameResize(Sender: TObject);
  end;

implementation

{$R *.lfm}

procedure T_frame.FrameResize(Sender: TObject);
var
  colWidth, sg_width, col_count: Integer;
  sg : TStringGrid;
begin
  if not(Sender is TStringGrid) then
    Exit;
  sg := sGrid;
  colWidth := sg.DefaultColWidth;
  sg.ColWidths[0] := 35;
  sg_width := sg.Width-sg.ColWidths[0];
  col_count := sg_width div colWidth;
  sg.ColCount := col_count;
end;

end.
