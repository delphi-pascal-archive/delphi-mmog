unit mSQL;
interface

uses SysUtils,MySQLClasses,sConfig;

procedure LoadSQL();
procedure FreeSQL();


var
  SQL:TMySQL;
implementation

procedure LoadSQL();
begin
  SQL:=TMySQL.Create;
  SQL.Host:=msHost;
  SQL.Port:=msPort;
  SQL.User:=msUser;
  SQL.Password:=msPass;
  if not SQL.Connect then
  begin
    Writeln(Format('%d: %s',[SQL.ErrorCode,SQL.ErrorMessage]));
    halt(1);
  end;
  SQL.Database:=msBase;
    if SQL.Database<>msBase then
  begin
    Writeln(Format('%d: %s',[SQL.ErrorCode,SQL.ErrorMessage]));
    halt(1);
  end;
end;

procedure FreeSQL();
begin
  SQL.Disconnect;
  SQL.Free;
end;

end.
