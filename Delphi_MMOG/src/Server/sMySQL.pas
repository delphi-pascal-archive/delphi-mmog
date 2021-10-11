unit sMySQL;

interface

uses
  SysUtils,MySQL,MySQLClasses,sConfig;

procedure LoadSQL();

procedure UnLoadSQL();

var
  SQL:IMySQL;
implementation

procedure LoadSQL();
begin
  SQL:=TMySQL.Create;
  SQL.Host:=LOCAL_HOST;
  SQL.Port:=MYSQL_PORT;
  SQL.User:=msUser;
  SQL.Password:=msPass;
  if not SQL.Connect then
  begin
    WriteLn(Format('[---1] #%d - %s', [SQL.ErrorCode, SQL.ErrorMessage]));
    UnLoadSQL();
    halt(1);
    exit;
  end;
  SQL.Database := msBase;
  if SQL.Database <> msBase then //если не равны значит открытие
  begin                              //базы данных не прошло...
    WriteLn(Format('[---2] #%d - %s', [SQL.ErrorCode, SQL.ErrorMessage]));
    UnLoadSQL();
    halt(1);
    Exit;
  end;

end;

procedure UnLoadSQL();
begin
  SQL.Disconnect;
  //SQL.Free;
end;

end.
