unit Test_buf_dataset_open;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, memds, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, DBCtrls, DBGrids, ExtCtrls, ActnList, Menus;

type

  { TTest_bufDataset_open }

  TTest_bufDataset_open = class(TForm)
				ActionLoadMmo : TAction;
				ActionLoadBufDs : TAction;
				Actions : TActionList;
    MemDb: TBufDataset;
    MemDbid: TAutoIncField;
    MemDbword: TStringField;
    dbg: TDBGrid;
    dbName: TDBNavigator;
    dSrc: TDataSource;
		MemDataset1 : TMemDataset;
		MenuItem1 : TMenuItem;
		MenuItem2 : TMenuItem;
    mmo: TMemo;
    pnl_db_back: TPanel;
    pgCtrl: TPageControl;
		pgBar : TProgressBar;
		db_popup : TPopupMenu;
		statBar : TStatusBar;
    tb_dset: TTabSheet;
    tb_mmo: TTabSheet;
		procedure ActionLoadBufDsExecute(Sender : TObject);
    procedure ActionLoadMmoExecute(Sender : TObject);
  private
    procedure LoadBufDataset;
    procedure LoadMemo;

  public

  end;

var
  Test_bufDataset_open: TTest_bufDataset_open;

const
  word_file = 'd:/words.txt';

implementation

uses MemDSLaz;

{$R *.lfm}

{ TTest_bufDataset_open }

procedure TTest_bufDataset_open.ActionLoadMmoExecute(Sender : TObject);
begin
  mmo.Clear;
  try
    LoadMemo;
	finally
    ActionLoadBufDs.Enabled := True;
	end;
end;

procedure TTest_bufDataset_open.ActionLoadBufDsExecute(Sender : TObject);
begin
  try
    LoadBufDataset;
	finally
    ActionLoadBufDs.Enabled := False;
	end;
end;

procedure TTest_bufDataset_open.LoadMemo;
begin
  mmo.Lines.LoadFromFile(word_file);
end;

procedure TTest_bufDataset_open.LoadBufDataset;
var
  i: integer;
  s : String;
  Mem_dset : TMemDataset;
begin
  pgBar.Min := 1;
  pgBar.Max := mmo.Lines.Count -1;
  pgBar.Visible := True;
  //dsrc.DataSet := nil;
  i := 0;

 Mem_dset := TMemDataset.Create(nil);

  try
      Mem_dset.FieldDefs.Add('id',ftInteger);
      Mem_dset.FieldDefs.Add('word',ftString,45);
      Mem_dset.CreateTable;
      Mem_dset.Open;
      try
        while i < mmo.Lines.Count  do
        begin
          if mmo.Lines[i] = '' then
            Continue;
          if i mod 50 = 0 then
          begin
            pgBar.Position := i;
            statBar.SimpleText := Format('Loading record #: %d', [i]);
            Application.ProcessMessages;
					end;
					Mem_dset.Append;
          Mem_dset.FieldByName('id').AsInteger := i + 1;
          s := mmo.Lines[i];
          Mem_dset.FieldByName('word').AsString := mmo.Lines[i];
          Mem_dset.Post;
          Inc(i);
        end;
        Mem_dset.SaveToFile('Mem_dset.txt');  // as long you do not close, you
      except on Ex : Exception do
        begin
          ShowMessage(Format('LoadBufDataset exception at record %d.'
                  +LineEnding +#09 +'Exception %s',
                  [i, Ex.Message]));
        end;

			end;

	finally
    pgBar.Visible := False;
    pgBar.Position := 0;
    statBar.SimpleText := Format('Loaded record count: %d', [i]);
    dsrc.DataSet := Mem_dset;
	end;

end;

end.
