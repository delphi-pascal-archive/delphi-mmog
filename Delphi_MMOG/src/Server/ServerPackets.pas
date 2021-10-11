unit ServerPackets;

interface

uses
  Windows,SysUtils,sPacketSend,VectorTypes;

procedure pNewKey();
procedure pCharacterSelectionInfo();
procedure pCharacterSelected();
procedure pCharacterCreateSuccess();
procedure pCharacterCreateFail();
procedure pUserInfo(obj_id:integer; Pos:TVector3f; id:HWND);
procedure pCharInfo(obj_id:integer; Pos:TVector3f; id:HWND);
procedure pNpcInfo(obj_id,type_id:integer; Pos:TVector3f; id:HWND);
procedure pSpawnItem();
procedure pDropItem();
procedure pDeleteObject(obj_id:integer; id:HWND);
procedure pSay();
procedure pMoveToLocation(obj_id:integer; Targ,Cur:TVector3f; id:HWND);


const
  DebugMode = true;




implementation

procedure pNewKey();
var
  A:Array of byte;
begin
  //
end;

procedure pCharacterSelectionInfo();
var
  A:Array of byte;
begin
  //
end;

procedure pCharacterSelected();
var
  A:Array of byte;
begin
  //
end;

procedure pCharacterCreateSuccess();
var
  A:Array of byte;
begin
  //
end;

procedure pCharacterCreateFail();
var
  A:Array of byte;
begin
  //
end;

procedure pUserInfo(obj_id:integer; Pos:TVector3f; id:HWND);
var
  A:Array of byte;
begin
  SetLength(A,23);
  A[0]:=$17;
  A[2]:=$07;
  Move(Pos[0],A[3],4);
  Move(Pos[1],A[7],4);
  Move(Pos[2],A[11],4);
  Move(obj_id,A[19],4);
  PacketSend(A,23,id);
  if DebugMode then Writeln(Format('Server -> Client: %d Packet: pUserInfo',[id]));
end;

procedure pCharInfo(obj_id:integer; Pos:TVector3f; id:HWND);
var
  A:Array of byte;
begin
  SetLength(A,$17);
  A[0]:=$17;
  A[2]:=$08;
  Move(Pos[0],A[3],4);
  Move(Pos[1],A[7],4);
  Move(Pos[2],A[11],4);
  Move(obj_id,A[15],4);
  PacketSend(A,$17,id);
    if DebugMode then Writeln(Format('Server -> Client: %d Packet: pCharInfo',[id]));
end;

procedure pNpcInfo(obj_id,type_id:integer; Pos:TVector3f; id:HWND);
var
  A:Array of byte;
begin
SetLength(A,$18);
A[0]:=$18;
A[2]:=$09;
Move(obj_id,A[3],4);
Move(type_id,A[7],4);
a[11]:=$01;
Move(Pos[0],A[12],4);
Move(Pos[1],A[16],4);
Move(Pos[2],A[20],4);
PacketSend(A,$18,id);
  if DebugMode then Writeln(Format('Server -> Client: %d Packet: pNpcInfo',[id]));
end;

procedure pSpawnItem();
var
  A:Array of byte;
begin
  //
end;

procedure pDropItem();
var
  A:Array of byte;
begin
  //
end;

procedure pDeleteObject(obj_id:integer; id:HWND);
var
  A:Array of byte;
begin
SetLength(A,$0B);
A[0]:=$0B;
A[2]:=$0C;
Move(obj_id,A[3],4);
PacketSend(A,$0B,id);
end;

procedure pSay();
var
  A:Array of byte;
begin
  //
end;

procedure pMoveToLocation(obj_id:integer; Targ,Cur:TVector3f; id:HWND);
var
  A:Array of byte;
begin
SetLength(A,$1F);
A[0]:=$1F;
A[2]:=$0E;
Move(Obj_id,A[3],4);
Move(Targ[0],A[7],4);
Move(Targ[1],A[11],4);
Move(Targ[2],A[15],4);
Move(Cur[0],A[19],4);
Move(Cur[1],A[23],4);
Move(Cur[2],A[27],4);
PacketSend(A,$1F,id);
  if DebugMode then Writeln(Format('Server -> Client: %d Packet: pMoveToLocation',[id]));
end;

end.
