unit Char_List;

interface

uses
  GLObjects,VectorTypes;

type
  TChar = record
    Obj_id:integer;
    Target:TVector3f;
    Position:TVector3f;
    Mesh:TGLSphere;
  end;


  TCharList = class
  private
    Slots:integer;
  public
    Chars:array of TChar;
    function add(obj_id:integer; Pos:TVector3f):integer;
    function index(obj_id:integer):integer;
    procedure Del(obj_id:integer);
    function CountChars():integer;
    constructor Create(Count:integer);
    destructor Destroy();
  end;

implementation

{ TCharList }

function TCharList.add(obj_id:integer; Pos:TVector3f):integer;
var
  i,m: Integer;
begin
  m:=-1;
  for I := 0 to Slots-1 do
  begin
    if Chars[i].Obj_id = 0 then
    begin
      Chars[i].Obj_id:=obj_id;
      Chars[i].Position:=Pos;
      Chars[i].Target:=Pos;
      Result:=i;
      exit;
    end;
  end;
  Result:=m;
end;

function TCharList.CountChars: integer;
var
  I,x: Integer;
begin
  x:=0;
  for I := 0 to Slots-1 do
  begin
    if Chars[i].Obj_id <> 0 then
    begin
      x:=x+1;
    end;
  end;
  result:=x;
end;

constructor TCharList.Create(Count: integer);
begin
  inherited Create;
  SetLength(Chars,Count);
  Slots:=Count;
end;

procedure TCharList.del(obj_id:integer);
var
  I: Integer;
begin
  for I := 0 to Slots-1 do
  begin
    if Chars[i].Obj_id = obj_id then
    begin
      Chars[i].Obj_id:=0;
      Chars[i].Mesh.Free;
    end;
  end;
end;

destructor TCharList.Destroy;
begin
  inherited Destroy;
  SetLength(Chars,0);
  Slots:=0;
end;

function TCharList.index(obj_id:integer):integer;
var
  i:integer;
begin
  result:=-1;
  for I := 0 to Slots-1 do
  begin
    if (Chars[i].Obj_id <> 0) and (Chars[i].Obj_id = obj_id) then
    begin
      result:=i;
      exit;
    end;
  end;
end;

end.
