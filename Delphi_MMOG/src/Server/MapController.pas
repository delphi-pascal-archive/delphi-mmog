unit MapController;
interface

uses windows,sysutils,clients,ServerPackets, VectorGeometry, VectorTypes;
{
 это замена потоковой обработки расстояния до нпс в юните MainThread

 потребляет:
 8байт * 100 * 128^2 = 12,5мб
}

const
  CHARS_COUNT   = 100; //кол-во игроков в массиве куска карты
  NPC_COUNT     = 100; //кол-во NPC в массиве куска карты (не используется)
  ZONE_COUNT    = 128; //кол-во кусков карты по X и Y
  ZONE_SIZE     = 100; //размер куска карты
type
  TMap_Piece = record
    Chars:array of TClientId;
    //NPCs:array of


  end;

  TMMO_map = class
  private
    World:array of array of TMap_Piece;
  public
    constructor Create;
    destructor Destoy;
    procedure Add_Char_InWorld(id:TClientId);
    procedure Send_pCharInfo(id:TClientId);
    procedure Send_DelChar(id:TClientid);
    procedure Del_Char_InWorld(id:TClientid);
    procedure UpdatePos(Targ:TVector3f; Pos:TVector3f; id:TClientId);
  end;

var
  map:TMMO_map;
implementation

{ TMMO_map }

procedure TMMO_map.Add_Char_InWorld(id: TClientId);
var
  Pos:TVector3f; 
  x,y,i:integer;
begin
  pos:=clientsarray.Client[id[1]].Position;
  x:=(Trunc(Pos[0]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  y:=(Trunc(Pos[2]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  for i:=0 to CHARS_COUNT-1 do
  begin
    if World[x][y].Chars[i][0]=0 then
    begin
      World[x][y].Chars[i]:=id;
      exit;
    end;
  end;
end;

constructor TMMO_map.Create;
var
  x,y:integer;
begin
  inherited Create;
  SetLength(World,ZONE_COUNT,ZONE_COUNT);
  for x:=0 to ZONE_COUNT-1 do
  begin
    for y:=0 to ZONE_COUNT-1 do
    begin
      SetLength(World[x][y].Chars,CHARS_COUNT);
    end;
  end;
end;

procedure TMMO_map.Del_Char_InWorld(id: TClientid);
var
  pos:TVector3f;
  x,y,i:integer;
begin
  pos:=clientsarray.Client[id[1]].Position;
  x:=(Trunc(Pos[0]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  y:=(Trunc(Pos[2]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  for i:=0 to CHARS_COUNT-1 do
  begin
    if (World[x][y].Chars[i][0]<>0) and (World[x][y].Chars[i][0]=id[0]) then
    begin
      World[x][y].Chars[i][0]:=0;
      World[x][y].Chars[i][1]:=0;
      exit;
    end;
  end;
end;

destructor TMMO_map.Destoy;
begin
  SetLength(World,0,0);
  inherited Destroy;
end;

procedure TMMO_map.Send_DelChar(id: TClientid);
var
  pos:TVector3f;
  x,y,i:integer;
begin
  pos:=clientsarray.Client[id[1]].Position;
  x:=(Trunc(Pos[0]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  y:=(Trunc(Pos[2]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  for i:=0 to CHARS_COUNT-1 do
  begin
    if (World[x][y].Chars[i][0]<>0) and (World[x][y].Chars[i][0]<>id[0]) then
    begin
     pDeleteObject(id[0],World[x][y].Chars[i][0]);
    end;
  end;
end;

procedure TMMO_map.Send_pCharInfo(id: TClientId);
var
  pos:TVector3f;
  x,y,i:integer;
begin
  pos:=clientsarray.Client[id[1]].Position;
  x:=(Trunc(Pos[0]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  y:=(Trunc(Pos[2]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  pUserInfo(id[0],Pos,id[0]);
  for i:=0 to CHARS_COUNT-1 do
  begin
    if (World[x][y].Chars[i][0]<>0) and (World[x][y].Chars[i][0]<>id[0]) then
    begin
     pCharInfo(id[0],Pos,World[x][y].Chars[i][0]);
     pCharInfo(ClientsArray.Client[World[x][y].Chars[i][1]].id[0],ClientsArray.Client[World[x][y].Chars[i][1]].Position,id[0])
    end;
  end;
end;

procedure TMMO_map.UpdatePos(Targ:TVector3f; Pos: TVector3f; id: TClientId);
var
  tx,cx,ty,cy,i:integer;
begin
  cx:=(Trunc(Pos[0]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  cy:=(Trunc(Pos[2]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  tx:=(Trunc(targ[0]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  ty:=(Trunc(targ[2]) div (ZONE_SIZE div 2) + (ZONE_COUNT div 2));
  writeln(format('x=%d y=%d',[tx,ty]));
  if (abs(tx-cx)<1) and (abs(ty-cy)<1) then
  begin
  for i:=0 to CHARS_COUNT-1 do
  begin
    if World[cx][cy].Chars[i][0]<>0 then
    begin
     pMoveToLocation(id[0],Targ,Pos,World[cx][cy].Chars[i][0]);
    end;
  end;
  end;
end;

end.
