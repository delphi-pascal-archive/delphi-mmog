unit sClientThread;

interface

uses
  Classes,
  SysUtils,
  WinSock,
  Clients,
  sPacketHandle,MapController;

const
  BUF_LEN = 65535;


type
  ClientThread = class(TThread)
  public
    Socket:TSocket;
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

procedure ClientThread.Execute;
var
  Buf:Array[0..BUF_LEN-1] of byte;
  aBuf:Array of byte;
  rLen,Len:Word;
  c:TClientId;
begin
  try



  if Socket = INVALID_SOCKET then exit;
  c[0]:=Socket;
  c[1]:=ClientsArray.Add(Socket);   //добавляем клиента в массив клиентов
  ClientsArray.LoadInWorld(c);  //загружаем клиента в мир
  repeat

    rLen:=Recv(Socket,Buf,BUF_LEN,0);

    if rLen<=0 then Break;
    len:=Buf[1]*256+Buf[0];
    if len<=0 then Break;

    SetLength(aBuf,len);
    Move(buf[0],aBuf[0],len);
    PacketParse(aBuf,C);



  until false;
  finally
    ClientsArray.UnLoadInWorld(C); // выгружаем клиента из мира
    ClientsArray.Del(Socket);  // удаляем клиента из массива клиентов
    CloseSocket(Socket);
  end;
end;

end.
