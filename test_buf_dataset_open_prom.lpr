program test_buf_dataset_open_prom;

{$mode objfpc}{$H+}

uses
      {$IFDEF UNIX}
      cthreads,
      {$ENDIF}
      {$IFDEF HASAMIGA}
      athreads,
      {$ENDIF}
      Interfaces, // this includes the LCL widgetset
      Forms, Test_buf_dataset_open, memdslaz
      { you can add units after this };

{$R *.res}

begin
      RequireDerivedFormResource := True;
      Application.Scaled := True;
      Application.Initialize;
			Application.CreateForm(TTest_bufDataset_open, Test_bufDataset_open);
      Application.Run;
end.

