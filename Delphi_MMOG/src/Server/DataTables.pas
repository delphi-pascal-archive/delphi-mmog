unit DataTables;
interface

{
// Тут будут записи со статическими данными + их загрузка из базы
// Spawn
//
//
}

uses
  Windows,SysUtils,mSQL,MySQLClasses;

type
  TSpawnlist = array of record
    npc_id:integer;
    x,y,z:integer;
  end;

procedure Data_Load;
procedure Data_Free;

procedure Spawnlist_Load;

Var
  Spawnlist:TSpawnlist;

implementation

procedure Data_Load;
begin
Spawnlist_Load;
end;

procedure Spawnlist_Load;
var
  q:IMySQLQuery;
  i:integer;
begin
  q:=SQL.Query('SELECT * FROM `spawnlist`;');
  SetLength(Spawnlist,q.RecordCount);
  for i:=0 to q.RecordCount-1 do
  begin
    q.FetchRow(i);
    Spawnlist[i].npc_id:=StrToInt(q.ValueByName['npc_id']);
    Spawnlist[i].x:=StrToInt(q.ValueByName['loc_x']);
    Spawnlist[i].y:=StrToInt(q.ValueByName['loc_y']);
    Spawnlist[i].z:=StrToInt(q.ValueByName['loc_z']);
  end;
  WriteLn('Load Spawn: ',q.RecordCount);
end;








procedure Data_Free;
begin

end;


end.
