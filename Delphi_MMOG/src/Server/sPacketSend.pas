unit sPacketSend;

interface

uses
  Windows,Winsock;

procedure PacketSend(A:Array of byte; Len:Integer; s:TSocket);

implementation

procedure PacketSend(A:Array of byte; Len:Integer; s:TSocket);
begin
  Send(S,A,Len,0);
end;

end.
