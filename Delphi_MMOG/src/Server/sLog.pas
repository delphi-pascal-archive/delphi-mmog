unit sLog;
interface

uses
  Windows;

//procedure s_Log(const S: string);

implementation
{
procedure s_Log(const S: string);
var
NewStr: string;
begin
SetLength(NewStr, Length(S));
CharToOem(PChar(S), PChar(NewStr));
Writeln(NewStr);
end;
}
end.
