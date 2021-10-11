unit ClientPackets;

interface

uses
  Windows,SysUtils,ServerPackets,DataTables,Clients,VectorTypes,MapController;

procedure pProtocolVersion(A:Array of byte; id:HWND);
procedure pCharacterNew(A:Array of byte; id:HWND);
procedure pCharacterCreate(A:Array of byte; id:HWND);
procedure pCharacterDelete(A:Array of byte; id:HWND);
procedure pCharacterSelected(A:Array of byte; id:HWND);
procedure pEnterWorld(A:Array of byte; id:HWND);
procedure pMoveBackwardToLocation(A:Array of byte; id:TClientId);
procedure pSay(A:Array of byte; id:HWND);
//
procedure AdminPack(A:Array of byte; id:HWND);

implementation

procedure pProtocolVersion(A:Array of byte; id:HWND);
begin
  //
end;

procedure pCharacterNew(A:Array of byte; id:HWND);
begin
  //
end;

procedure pCharacterCreate(A:Array of byte; id:HWND);
begin
  //
end;

procedure pCharacterDelete(A:Array of byte; id:HWND);
begin
  //
end;

procedure pCharacterSelected(A:Array of byte; id:HWND);
begin
  //
end;

procedure pEnterWorld(A:Array of byte; id:HWND);
begin
  //
end;

procedure pMoveBackwardToLocation(A:Array of byte; id:TClientId);
var
  Target,Current:TVector3f;
begin
  Move(A[7],Target[0],4);
  Move(A[11],Target[1],4);
  Move(A[15],Target[2],4);
  Move(A[19],Current[0],4);
  Move(A[23],Current[1],4);
  Move(A[27],Current[2],4);
  Map.UpdatePos(Target,Current,id);
 // ClientsArray.SetPos(Target,id[0]);
 // ClientsArray.UpdatePos(Target,current,id[0]);
 // pMoveToLocation(id[0],Target,Current,id[0]);
    if DebugMode then Writeln(Format('Client: %d -> Server  Packet: pMoveBackwardToLocation',[id[0]]));
end;

procedure pSay(A:Array of byte; id:HWND);
begin
  //
end;


procedure AdminPack(A:Array of byte; id:HWND);
begin
  //не трогать пакет!!
end;

end.
