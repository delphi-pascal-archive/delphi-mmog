program Server;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  WinSock,
  sClientThread,
  Clients,
  MainThread,
  sPacketSend in 'sPacketSend.pas',
  sConfig in 'sConfig.pas',
  sLog in 'sLog.pas',
  mSQL in 'mSQL.pas',
  DataTables in 'DataTables.pas',
  ServerPackets in 'ServerPackets.pas',
  ClientPackets in 'ClientPackets.pas',
  MapController in 'MapController.pas';

var
  CT:ClientThread;
  Data:WSAdata;
  ConnSocket,ListSocket:TSocket;
  ListAddr:TSockAddr;
  Main:TMainThread;
begin
    try
      LoadINI();
      //LoadSQL();
      map:=TMMO_Map.Create;
      //Data_Load;
      ClientsArray:=TClients.Create(sMaxUser);
      Main:=TMainThread.Create(False);
      Main.Priority:=tpLowest;
      Main.Resume;
      WSAstartup(2,Data);
      ListSocket:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
      ListAddr.sin_family:=AF_INET;
      ListAddr.sin_port:=htons(sPort);
      ListAddr.sin_addr.S_addr:=Inet_Addr(PChar(sHost));
      bind(ListSocket,ListAddr,SizeOf(ListAddr));
      listen(ListSocket,SOMAXCONN);
      WriteLn(Format('Server bind: %s:%d',[sHost,sPort]));
      repeat
        ConnSocket:=accept(ListSocket,nil,nil);
        CT:=ClientThread.Create(False);
        CT.Socket:=ConnSocket;
        CT.FreeOnTerminate:=true;
        CT.Priority:=tpLowest;
        CT.Resume;
      until false;
    finally
      map.Free;
      WSACleanup;
      //FreeSQL();
      ClientsArray.Free;
    end;
end.
