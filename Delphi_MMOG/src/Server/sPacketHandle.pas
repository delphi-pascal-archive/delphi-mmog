unit sPacketHandle;

interface

Uses
  Windows,clients,
  ClientPackets;

procedure PacketParse(A:Array of byte; id:TClientId);

implementation

procedure PacketParse(A:Array of byte; id:TClientId);
begin
  case A[2] of
    $01: pProtocolVersion(A,id[0]);
    $02: pCharacterNew(A,id[0]);
    $03: pCharacterCreate(A,id[0]);
    $04: pCharacterDelete(A,id[0]);
    $05: pCharacterSelected(A,id[0]);
    $06: pEnterWorld(A,id[0]);
    $07: pMoveBackwardToLocation(A,id);
    $08: pSay(A,id[0]);
    //$FF: AdminPack(A,id);
  end;




end;




end.
