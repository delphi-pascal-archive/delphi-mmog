unit NPCs_List;

interface

uses
  GLObjects;

type
  TNPC = record
    Obj_id:integer;
    type_id:integer;
    x,y,z:integer;
    Mesh:TGLSphere;
  end;


  TNPCList = class
  private
    Slots:integer;
  public
    NPCs:array of TNPC;
    function Add(obj_id, type_id:integer; x,y,z:integer):integer;
    procedure Del(obj_id:integer);
    function CountNPC():integer;
    constructor Create(Count:integer);
    destructor Destroy();
  end;

implementation

{ TNPCList }

function TNPCList.add(obj_id, type_id, x, y, z: integer):integer;
var
  i,m: Integer;
begin
  m:=-1;
  for I := 0 to Slots-1 do
  begin
    if NPCs[i].Obj_id = 0 then
    begin
      NPCs[i].Obj_id:=obj_id;
      NPCs[i].type_id:=type_id;
      NPCs[i].x:=x;
      NPCs[i].y:=y;
      NPCs[i].z:=z;
      Result:=i;
      exit;
    end;
  end;
  Result:=m;
end;

function TNPCList.CountNPC: integer;
var
  I,x: Integer;
begin
  x:=0;
  for I := 0 to Slots-1 do
  begin
    if NPCs[i].Obj_id <> 0 then
    begin
      x:=x+1;
    end;
  end;
  result:=x;
end;

constructor TNPCList.Create(Count: integer);
begin
  inherited Create;
  SetLength(NPCS,Count);
  Slots:=Count;
end;

procedure TNPCList.del(obj_id:integer);
var
  I: Integer;
begin
  for I := 0 to Slots-1 do
  begin
    if NPCs[i].Obj_id = obj_id then
    begin
      NPCs[i].Obj_id:=0;
      NPCs[i].Mesh.Free;
    end;
  end;
end;

destructor TNPCList.Destroy;
begin
  inherited Destroy;
  SetLength(NPCs,0);
  Slots:=0;
end;

end.
