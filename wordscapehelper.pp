unit WordscapeHelper;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type

	{ TTestFile }

  TTestFile = class
  private
    Fl : TextFile;
    work_str : String;
  public
    constructor Create(fileName : String);
    destructor Destroy;
    function Open : Boolean;
    procedure Close;
    function Build_file_name : String;
	end;

function GetFactorial(num: Integer): Integer;
function CombinationCount(num, takeAt: Integer): Integer;
function PermutationCount(const num, takeAt: Integer) : Integer;
function PermutationCount_ex(const num, takeAt, minLen: Integer) : Integer;
function CleanDuplicateChars(Str: string): string;
function CleanString(Str: string): string;

implementation


function PermutationCount(const num, takeAt: Integer) : Integer;
var
  numerator, denominator: Integer;
begin
  numerator := GetFactorial(num);
  denominator := GetFactorial(num - takeAt);
  Result := numerator div denominator;
end;

function CombinationCount(num, takeAt: Integer): Integer;
var
  numerator, demoninator, takeAtFact: Integer;
begin

  numerator := GetFactorial(num);
  takeAtFact := GetFactorial(takeAt);
  demoninator := takeAtFact * GetFactorial(num - takeAt);

  Result := numerator div demoninator;
end;

function GetFactorial(num: Integer): Integer;
var
  fctrl: Integer;
begin
  fctrl := 1;
  while num > 1 do
  begin
    fctrl := fctrl * num;
    Dec(num)
  end;
  Result := fctrl;
end;

function PermutationCount_ex(const num, takeAt, minLen : Integer) : Integer;
(*
 * function PermutationCount_ex: extended permutation count; i.e., sum
 *      of PermutationCount(num, takeAt) thence,
 *      PermutationCount(num, takeAt -1) ... until takeAt = minLen -1
 *)
var
  tkAt : Integer;
begin
  tkAt := takeAt;
  Result := 0;
  while tkAt >= minLen do
  begin
  	Result := Result +PermutationCount(num, tkAt);
    Dec(tkAt);
	end;
end;

function CleanDuplicateChars(Str: string): string;
var
  rslt: string;
  slst : TStringList;
  i, x: Integer;
begin
  rslt := '';
  slst := TStringList.Create;
  Str := AnsiUpperCase(Str);
  try
    for i := 1 to Length(Str) do
      if Str[i] in ['A'..'Z'] then
      begin
        x := slst.IndexOf(Str[i]);
        if x < 0 then
        begin
          slst.Add(Str[i]);
          rslt := Concat(rslt, Str[i]);
        end;
			end;
		Result := rslt;

	finally
    slst.Free;
	end;
  //for i := 1 to Length(Str) do
  //  if (Str[i] >= 'A') and (Str[i] <= 'Z') and (not rslt.Contains(Str[i])) then
  //    rslt := Concat(rslt, Str[i]);
  //Result := rslt;
end;

function CleanString(Str: string): string;
{
  just cleans whatever non-alpha chars from the Str:String
}
var
  rslt: string;
  i: Integer;
begin
  rslt := '';
  Str := AnsiUpperCase(Str);
  for i := 1 to Length(Str) do
  if Str[1] in ['A'..'Z'] then
      rslt := Concat(rslt, Str[i]);
	Result := rslt;
end;

{ TTestFile }

constructor TTestFile.Create(fileName : String);
begin
  if fileName = EmptyStr then
  begin

	end;
  AssignFile(Fl, fileName);
end;

destructor TTestFile.Destroy;
begin

end;

function TTestFile.Open : Boolean;
begin

end;

procedure TTestFile.Close;
begin

end;

function TTestFile.Build_file_name : String;
begin

end;


end.

