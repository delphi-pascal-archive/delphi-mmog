unit Clients;

interface

uses
  windows,VectorGeometry, VectorTypes, ServerPackets;

const
  MAX_POS_DIST = 50;

type
  TClientId = array[0..1] of integer; // первый int это obj_id клиента = id сокета
                                      // второй int это позиция клиента в массиве клиентов
  TClient = array of record
    id:TClientId;
    Key:integer;
    Status:byte;
    Moved:boolean;
    Position:TVector3f;    // позиция клиента (не точная)
 //   ViewNPCs:Array[0..99] of integer; //массив НПСов которых видит клиент
 //   ViewChars:Array[0..99] of integer; //массив игроков которых видит клиент
 //  ViewItems:Array[0..99] of integer; //массив вещей которые видит клиент
  end;

  TClients = class
  private
    C_Max:integer;
  public
    Client:TClient;
    function Add(id:HWND):integer;
    procedure Del(id:HWND);
    function Index(id:HWND):Integer;
    ////////
    procedure SetPos(Position:TVector3f; id: HWND);

    procedure LoadInWorld(id:TClientid);
    procedure UnLoadInWorld(id:TClientid);

    constructor Create(max:integer);
    destructor Free;
  end;




var
  ClientsArray:TClients;
implementation

uses MapController;

function TClients.Add(id: HWND):integer;
var
  I: Integer;
begin
  for I := 0 to c_Max - 1 do
  begin
    if Client[i].id[0] = 0 then
    begin
      Client[i].id[0]:=id;
      Client[i].id[1]:=id;
      exit;
    end;
  end;
end;

procedure TClients.Del(id: HWND);
var
  I: Integer;
begin
  for I := 0 to c_Max - 1 do
  begin
    if Client[i].id[0] <> 0 then
    begin
      if (Client[i].id[0]=id) then
      begin
        Client[i].id[0]:=0;
        Client[i].id[1]:=0;
        exit;
      end;
    end;
  end;
end;

function TClients.Index(id:HWND):integer;
var
  I: Integer;
begin
  Result:=-1;
  for I := 0 to c_Max - 1 do
  begin
    if (Client[i].id[0] <> 0) then
    begin
      if (Client[i].id[0]=id) then
      begin
        Result:=i;
        exit;
      end;
    end;
  end;
end;

procedure TClients.SetPos(Position:TVector3f; id: HWND);
var
  c:integer;
begin
  c:=Index(id);
  Client[c].Position:=Position;
  Client[c].Moved:=True;
end;

constructor TClients.Create;
begin
  inherited Create;
  SetLength(Client,Max);
  c_max:=Max;
end;

destructor TClients.Free;
begin
  SetLength(Client,0);
  inherited Destroy;
end;

procedure TClients.LoadInWorld(id: TClientid);
begin
  Map.Add_Char_InWorld(id);  //
  Map.Send_pCharInfo(id);
end;

procedure TClients.UnLoadInWorld(id: TClientid);
begin
  Map.Send_DelChar(id);
  Map.Del_Char_InWorld(id);
end;

end.
