unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLScene, GLObjects, GLCadencer, GLWin32Viewer,
  GLCrossPlatform,  VectorGeometry, VectorTypes, jpeg,
  ScktComp, GLSkydome, GLHUDObjects, GLBitmapFont, GLWindowsFont,
  StdCtrls, ExtCtrls, NPCs_List, Char_List, UserInfo, GLGeomObjects, GLBlur,
  GLMisc;

type

  TFMain = class(TForm)
    Scene: TGLScene;
    SceneViewer: TGLSceneViewer;
    Cadencer: TGLCadencer;
    Camera: TGLCamera;
    Player: TGLDummyCube;
    GLSphere1: TGLSphere;
    GLLightSource1: TGLLightSource;
    Map: TGLPlane;
    World: TGLDummyCube;
    TargetPoint: TGLCube;
    Client: TClientSocket;
    SkyDome: TGLSkyDome;
    GLWindowsBitmapFont1: TGLWindowsBitmapFont;
    info: TGLHUDText;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    NPCType: TGLDummyCube;
    GLCylinder1: TGLCylinder;
    CharType: TGLDummyCube;
    GLCylinder2: TGLCylinder;
    GLMemoryViewer1: TGLMemoryViewer;
    procedure SceneViewerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CadencerProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SceneViewerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  private

  public
    procedure CreateNPCMesh(i: integer);
    procedure CreateCharMesh(i: integer);

  // Клиент -> Сервер
    procedure MoveBackwardToLocation(Target,Current:TVector3f);
  // Сервер -> Клиент
    procedure NewKey(A:Array of byte);
    procedure CharacterSelectionInfo(A:Array of byte);
    procedure CharacterSelected(A:Array of byte);
    procedure CharacterCreateSuccess(A:Array of byte);
    procedure CharacterCreateFail(A:Array of byte);
    procedure UserInfo(A:Array of byte);
    procedure CharInfo(A:Array of byte);
    procedure NpcInfo(A:Array of byte);
    procedure SpawnItem(A:Array of byte);
    procedure DropItem(A:Array of byte);
    procedure DeleteObject(A:Array of byte);
    procedure Say(A:Array of byte);
    procedure MoveToLocation(A:Array of byte);

  end;

var
  FMain: TFMain;
  target,current:TVector3f;
  //
  User:TUser;
  NPC_List:TNPCList;
  Char_List:TCharList;
  //
  MButtonR:boolean;
  mx,my:integer;
  main_buf:Array[0..65535] of byte;
  mLen:integer;
implementation

{$R *.dfm}

procedure TFMain.SceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  t,p:TVector3f;
begin
if Button=TMouseButton(mbleft) then begin
  t:=SceneViewer.Buffer.PixelRayToWorld(x,y);
  p:=player.Position.AsAffineVector;
  MoveBackwardToLocation(t,p);
end;
if Button = TMouseButton(mbRight) then MButtonR:=true;

end;

procedure TFMain.SceneViewerMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if MButtonR = true then Camera.RotateTarget(0,1,1);
end;

procedure TFMain.SceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Button = TMouseButton(mbRight) then MButtonR:=false;
end;

procedure TFMain.CadencerProgress(Sender: TObject; const deltaTime,
  newTime: Double);
const
  speed = 3;
var
  I: Integer;
begin
info.Text:=Format('X=%:f Y=%f Z=%f // X=%:f Y=%f Z=%f',[User.Targ[0],User.Targ[1],User.Targ[2],User.Position[0],User.Position[1],User.Position[2]]);

TargetPoint.Position.AsAffineVector:=User.Targ;
if VectorDistance(User.Targ,User.Position)>1 then
begin
  Player.Position.AsAffineVector:=User.Position;
  Player.AbsoluteDirection:=vectorsubtract(TargetPoint.AbsolutePosition, Player.AbsolutePosition);
  Player.Move(speed*deltaTime);
  User.Position:=Player.Position.AsAffineVector;
end;

for I := 0 to 99 do
begin
  if Char_list.Chars[i].Obj_id<>0 then
  begin
    if VectorDistance(Char_List.Chars[i].Target,Char_List.Chars[i].Position)>1 then
    begin
      Char_List.Chars[i].Mesh.Position.AsAffineVector:=Char_List.Chars[i].Position;
      Char_List.Chars[i].Mesh.Position.AsAffineVector:=vectorsubtract(Char_List.Chars[i].Target, Char_List.Chars[i].Mesh.Position.AsAffineVector);
      Char_List.Chars[i].Mesh.Move(speed*deltaTime);
      Char_List.Chars[i].Position:=Char_List.Chars[i].Mesh.Position.AsAffineVector;
    end;
  end;
end;

end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_RIGHT then Camera.MoveAroundTarget(0, +2);
if key=VK_LEFT then Camera.MoveAroundTarget(0, -2);

//if key=VK_RIGHT then GLSkyDome1.
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
NPC_List:=TNPCList.Create(100);
Char_List:=TCharList.Create(100);
Client.Active:=true;

end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
Client.Close;

Char_List.Destroy;
NPC_List.Destroy;
end;

procedure TFMain.MoveBackwardToLocation(Target,Current:TVector3f);
var
  A:Array of byte;
begin
SetLength(A,$1F);
A[0]:=$1F;
A[2]:=07;
Move(Target[0],A[7],4);
Move(Target[1],A[11],4);
Move(Target[2],A[15],4);
Move(Current[0],A[19],4);
Move(Current[1],A[23],4);
Move(Current[2],A[27],4);
Client.Socket.SendBuf(A[0],$1F);
end;

procedure TFMain.Button1Click(Sender: TObject);
begin
Fmain.Caption:=Format('x=%f y=%f z=%f / x=%f y=%f z=%f',[Char_list.Chars[0].Target[0],
Char_list.Chars[0].Target[1],Char_list.Chars[0].Target[2],Char_list.Chars[0].Position[0],
Char_list.Chars[0].Position[1],Char_list.Chars[0].Position[2] ])

end;

procedure TFMain.Button2Click(Sender: TObject);
begin
button2.Caption:=inttostr(Char_List.CountChars);
end;

procedure TFMain.Button3Click(Sender: TObject);
begin
NPC_List.Del(1);
end;

procedure TFMain.ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  A,X,T:Array of byte;
  xLen,aLen,tLen,i:integer;
begin
  xLen:=Socket.ReceiveLength; 
  SetLength(x,xLen);
  Socket.ReceiveBuf(x[0],xLen);
  Move(x[0],main_buf[MLen],xLen);
  mLen:=mLen+xLen;
  if MLen<2 then exit;
  repeat
  SetLength(A,0);
  aLen:=main_buf[1]*256+main_buf[0];
  if aLen > mLen then exit;
  SetLength(A,aLen);
  Move(main_buf[0],A[0],aLen);
  tLen:=mLen-aLen;
  SetLength(T,tLen);
  Move(main_buf[aLen],T[0],tLen);
  FillChar(main_buf,tlen*8,0);
  Move(t[0],main_buf[0],tLen);
  mLen:=tLen;
  case A[2] of
      $01: NewKey(A);
      $02: ;
      $03: CharacterSelectionInfo(A);
      $04: CharacterSelected(A);
      $05: CharacterCreateSuccess(A);
      $06: CharacterCreateFail(A);
      $07: UserInfo(A);
      $08: CharInfo(A);
      $09: NpcInfo(A);
      $0A: SpawnItem(A);
      $0B: DropItem(A);
      $0C: DeleteObject(A);
      $0D: Say(A);
      $0E: MoveToLocation(A);
  end;
  until aLen < 0;

end;

procedure TFMain.CreateNPCMesh(i: integer);
begin
NPC_List.NPCs[i].Mesh:=TGLSphere.CreateAsChild(Scene.Objects);
NPC_List.NPCs[i].Mesh.Position.SetPoint(NPC_List.NPCs[i].x,NPC_List.NPCs[i].y,NPC_List.NPCs[i].z);
end;

procedure TFMain.CreateCharMesh(i: integer);
begin
Char_List.Chars[i].Mesh:=TGLSphere.CreateAsChild(Scene.Objects);
Char_List.Chars[i].Mesh.Position.AsAffineVector:=Char_List.Chars[i].Position;
end;

procedure TFMain.MoveToLocation(A: array of byte);
var
  obj_id,CrL,NpL:integer;
  Targ,Cur:TVector3f;
begin
  Move(A[3],obj_id,4);
  Move(A[7],Targ[0],4);
  Move(A[11],Targ[1],4);
  Move(A[15],Targ[2],4);
  Move(A[19],Cur[0],4);
  Move(A[23],Cur[1],4);
  Move(A[27],Cur[2],4);

  if User.Obj_id=Obj_id then
  begin
    User.Targ:=Targ;
    User.Position:=Cur;
    exit;
  end;
  CrL:=Char_List.index(obj_id);
  if CrL<>-1 then
  begin
    Char_List.Chars[CrL].Target:=Targ;
    Char_List.Chars[CrL].Position:=Cur;
  end;




end;

procedure TFMain.NpcInfo(A: array of byte);
var
  obj_id,type_id,x,y,z,i:integer;
begin
Move(A[3],obj_id,4);
Move(A[7],type_id,4);
Move(A[12],x,4);
Move(A[16],y,4);
Move(A[20],z,4);
i:=NPC_List.Add(obj_id,type_id,x,y,z);
if i<>-1 then CreateNPCMesh(i);
end;

procedure TFMain.CharacterCreateFail(A: array of byte);
begin
  //
end;

procedure TFMain.CharacterCreateSuccess(A: array of byte);
begin
  //
end;

procedure TFMain.CharacterSelected(A: array of byte);
begin
  //
end;

procedure TFMain.CharacterSelectionInfo(A: array of byte);
begin
  //
end;

procedure TFMain.CharInfo(A: array of byte);
var
  Pos:TVector3f;
  obj_id,i:integer;
begin
  Move(A[3],Pos[0],4);
  Move(A[7],Pos[1],4);
  Move(A[11],Pos[2],4);
  Move(A[15],obj_id,4);
  i:=Char_List.add(obj_id,Pos);
  if i<>-1 then CreateCharMesh(i);
end;

procedure TFMain.DeleteObject(A: array of byte);
var
  Obj_id,CrL:integer;
begin
  Move(A[3],Obj_id,4);
  CrL:=Char_List.index(obj_id);
  if CrL<>-1 then
  begin
    Char_List.Del(Obj_id);
  end;
end;

procedure TFMain.DropItem(A: array of byte);
begin
  //
end;

procedure TFMain.NewKey(A: array of byte);
begin
  //
end;

procedure TFMain.Say(A: array of byte);
begin
  //
end;

procedure TFMain.SpawnItem(A: array of byte);
begin
  //
end;

procedure TFMain.UserInfo(A: array of byte);
var
  Pos:TVector3f;
begin
  Move(A[3],Pos[0],4);
  Move(A[7],Pos[1],4);
  Move(A[11],Pos[2],4);
  Move(A[19],User.Obj_id,4);
  User.Targ:=Pos;
  User.Position:=Pos;
end;

procedure TFMain.ClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
    Edit1.Text := 'Ошибка сети...';
    ErrorCode:=0;
end;

end.
