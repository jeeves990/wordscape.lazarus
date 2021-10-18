program WordScapesProj;

{$MODE Delphi}

uses
  Interfaces, // this includes the LCL widgetset
  Forms,
  WordScapes
  ;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TV, V);
  Application.Run;
end.



