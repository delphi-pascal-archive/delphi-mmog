unit sConfig;
interface

uses
  SysUtils,IniFiles;

procedure LoadINI();

var
  msPort,sPort,sMaxUser:integer;
  msHost,msUser,msPass,msBase,sHost:string;
implementation

var
ini:TIniFile;

procedure LoadINI();
begin
 ini:=TiniFile.Create('.\main.ini');
 sMaxUser:=ini.ReadInteger('Main','MaxUser',100);
 sHost:=ini.ReadString('Main','Host','127.0.0.1');
 sPort:=ini.ReadInteger('Main','Port',7700);
 msPort:=ini.ReadInteger('DB','Port',3306);
 msHost:=ini.ReadString('DB','Host','localhost');
 msUser:=ini.ReadString('DB','User','');
 msPass:=ini.ReadString('DB','Pass','');
 msBase:=ini.ReadString('DB','Base','');
 ini.Free;
end;



end.
