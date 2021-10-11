{*******************************************************}
{                                                       }
{        ���������� ��� ������ � MySQL *                }
{                                                       }
{               �����: ������� �������                  }
{                      www.vitaliy.org                  }
{                                                       }
{*******************************************************}
{ ������������ ����������:                              }
{ ������ ����������� ������� ���������������� ��������� }
{ �� �������� "AS IS", ��� �����-���� ��������.         }
{ �� ����������� ��� �� ���� ����.                      }
{ �� ������ �������� ������������ ��� � ����� ��������. }
{*******************************************************}
{ *  ������������ ������ ��������� ����� ����� �� ����� }
{ ������� �������  � �������  "�������"/"MySQL Console" }
{ ������ ������ �������� �� ���������������� ���������. }
{ ����� ���������: ������� ��������(riff#rin.ru). ����� }
{ ������ ��������� ������ �������: "� � �� ������ ���". }
{ ������ 1.1              ������� ������ � ����� �����. }
{*******************************************************}

unit MySQLClasses;

interface

uses Windows, SysUtils,  MySQL;

type
  TNotifyEvent = procedure(Sender: TObject) of object;
  IMySQLQuery = interface;

  IMySQL = interface(IInterface)
    function GetConnected: Boolean;
    function GetConnectionCount: Integer;
    function GetMySQL: PMySQL;
    function GetDatabase: string;
    function GetHost: string;
    function GetPassword: string;
    function GetPort: Integer;
    function GetUser: string;
    function GetAffectedRows: Integer;
    function GetOnConnect: TNotifyEvent;
    function GetOnDisconnect: TNotifyEvent;
    procedure SetConnected(Value: Boolean);
    procedure SetPort(Value: Integer);
    procedure SetHost(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetDatabase(const Value: string);
    procedure SetUser(const Value: string);
    procedure SetOnConnect(Value: TNotifyEvent);
    procedure SetOnDisconnect(Value: TNotifyEvent);

    function Connect: Boolean;
    procedure Disconnect;
    function ExecSQL(const SQL: String): Boolean;
    function Query(const SQL: string): IMySQLQuery;
    function ErrorCode: Integer;
    function ErrorMessage: string;
    function GetStatus: string;

    property AffectedRows: Integer read GetAffectedRows;
    property Connected: Boolean read GetConnected write SetConnected;
    property ConnectionCount: Integer read GetConnectionCount;
    property MySQL: PMySQL read GetMySQL;
    property Port: Integer read GetPort write SetPort;
    property Host: string read GetHost write SetHost;
    property User: string read GetUser write SetUser;
    property Password: string read GetPassword write SetPassword;
    property Database: string read GetDatabase write SetDatabase;
    property OnConnect: TNotifyEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TNotifyEvent read GetOnDisconnect write SetOnDisconnect;
    //property OnQuery: TOnQueryEvent read FOnQuery write FOnQuery;
  end;

  IMySQLQuery = interface(IInterface)
    function GetMySQL: IMySQL;
    function GetFieldCount: Integer;
    function GetRecNo: Integer;
    function GetRecordCount: Integer;
    function GetFieldName(Index: Integer): string;
    function GetField(Index: Integer): pmysql_field;
    function GetFieldIndex(const Name: string): Integer;
    function GetValues(FieldNo: Integer): string;
    function GetValueByName(const FieldName: string): string;

    function FetchRow(ARecNo: Integer = -1): Boolean;
    procedure GoToRow(ARecNo: Integer);

    property MySQL: IMySQL read GetMySQL;
    property RecNo: Integer read GetRecNo;
    property RecordCount: Integer read GetRecordCount;
    property FieldCount: Integer read GetFieldCount;
    property FieldIndex[const Name: string]: Integer read GetFieldIndex;
    property FieldName[Index: Integer]: string read GetFieldName;
    property Fields[Index: Integer]: pmysql_field read GetField;
    property Values[FieldNo: Integer]: string read GetValues; default;
    property ValueByName[const FieldName: string]: string read GetValueByName;
  end;

  TMySQL = class(TInterfacedObject, IMySQL)
  private
    FConnectionCount: Integer;
    FMySQL: pmysql;
    FPort: Integer;
    FPassword: string;
    FDatabase: string;
    FHost: string;
    FUser: string;
    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    //FOnQuery: TOnQueryEvent;

    { IMySQL }
    function GetConnected: Boolean;
    function GetConnectionCount: Integer;
    function GetMySQL: PMySQL;
    function GetDatabase: string;
    function GetHost: string;
    function GetPassword: string;
    function GetPort: Integer;
    function GetUser: string;
    function GetAffectedRows: Integer;
    function GetOnConnect: TNotifyEvent;
    function GetOnDisconnect: TNotifyEvent;
    procedure SetConnected(Value: Boolean);
    procedure SetPort(Value: Integer);
    procedure SetHost(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetDatabase(const Value: string);
    procedure SetUser(const Value: string);
    procedure SetOnConnect(Value: TNotifyEvent);
    procedure SetOnDisconnect(Value: TNotifyEvent);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    { IMySQL }
    function Connect: Boolean; virtual;
    procedure Disconnect; virtual;
    function ExecSQL(const SQL: String): Boolean; virtual;
    function Query(const SQL: string): IMySQLQuery;
    function ErrorCode: Integer;
    function ErrorMessage: string;
    function GetStatus: string;

    { IMySQL }
    property AffectedRows: Integer read GetAffectedRows;
    property Connected: Boolean read GetConnected write SetConnected default False;
    property ConnectionCount: Integer read GetConnectionCount;
    property MySQL: PMySQL read GetMySQL;
    property Port: Integer read GetPort write SetPort default 3306;
    property Host: string read GetHost write SetHost;
    property User: string read GetUser write SetUser;
    property Password: string read GetPassword write SetPassword;
    property Database: string read GetDatabase write SetDatabase;
    property OnConnect: TNotifyEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TNotifyEvent read GetOnDisconnect write SetOnDisconnect;
    //property OnQuery: TOnQueryEvent read FOnQuery write FOnQuery;
  end;

  TMySQLQuery = class(TInterfacedObject, IMySQLQuery)
  private
    FRecNo: Integer;
    FRecordCount: Integer;
    FFieldCount: Integer;
    FMySQL: IMySQL;
    FRow: pmysql_row;
    FRes: pmysql_res;
    FFields: pmysql_fields;
  private
    {IMySQLQuery}
    function GetMySQL: IMySQL;
    function GetFieldCount: Integer;
    function GetRecNo: Integer;
    function GetRecordCount: Integer;
    function GetFieldName(Index: Integer): string;
    function GetField(Index: Integer): pmysql_field;
    function GetFieldIndex(const Name: string): Integer;
    function GetValues(FieldNo: Integer): string;
    function GetValueByName(const FieldName: string): string;
  public
    constructor Create(AMySQL: IMySQL; ARes: pmysql_res);
    destructor Destroy; override;
  public
    {IMySQLQuery}
    function FetchRow(ARecNo: Integer = -1): Boolean;
    procedure GoToRow(ARecNo: Integer);
    {IMySQLQuery}  
    property MySQL: IMySQL read GetMySQL;
    property RecNo: Integer read GetRecNo;
    property RecordCount: Integer read GetRecordCount;
    property FieldCount: Integer read GetFieldCount;
    property FieldIndex[const Name: string]: Integer read GetFieldIndex;
    property FieldName[Index: Integer]: string read GetFieldName;
    property Fields[Index: Integer]: pmysql_field read GetField;
    property Values[FieldNo: Integer]: string read GetValues; default;
    property ValueByName[const FieldName: string]: string read GetValueByName;
  end;

function MySQLStr(Str: String): String;
function MySQLInsertId(MySQL: IMySQL): Integer;

implementation

function MySQLInsertId(MySQL: IMySQL): Integer;
begin
  Result := mysql_insert_id(MySQL.MySQL);
end;

function MySQLStr(Str: String): String;
var
  I: Longint;
begin
  for I := Length(Str) downto 1 do
    if (Str[I] = '''') then
      Insert('\', Str, I);
  Result := '''' + Str + '''';
end;

{ TMySQL }

constructor TMySQL.Create;
begin
  inherited;
  FConnectionCount := 0;
  FPort := 3306;
  FHost := 'localhost';
end;

destructor TMySQL.Destroy;
begin
  Disconnect;
  inherited;
end;

function TMySQL.Connect: Boolean;
begin
  Connected := True;
  Result := Connected;
end;

procedure TMySQL.Disconnect;
begin
  Connected := False;
end;

procedure TMySQL.SetConnected(Value: Boolean);
var
  FConnected: Boolean;
  FConnection: pmysql;
begin
  if Value then
  begin
    if FConnectionCount = 0 then //���� ��� ��� �����������, ��
    begin
      if FPort = 0 then FPort := 3306;
      try
        FMySQL := mysql_init(nil);
        FConnection := mysql_real_connect(FMySQL, PChar(FHost), PChar(FUser),
          PChar(FPassword), PChar(FDatabase), FPort, nil, 0); //����������� � MySQL
        FConnected := FConnection <> nil;
      except
        FConnected := False;
      end;

    end else
      FConnected := True; //���� fconnectioncount > 0 ������
                          //�����-�� �� ��� ������ ������������
    if FConnected then
       Inc(FConnectionCount);

    if FConnectionCount = 1 then
      if Assigned(FOnConnect) then FOnConnect(Self);
  end else
  begin
    if FConnectionCount > 0 then
    begin
      Dec(FConnectionCount);

      if FConnectionCount = 0 then
      begin
        mysql_close(FMySQL);
        if Assigned(FOnDisconnect) then FOnDisconnect(Self);
      end;
    end;
  end;
end;

{
  ���������� ���������� �����, ���������� ��������� �������� UPDATE,
  ��������� ��������� �������� DELETE ���
  ����������� ��������� �������� INSERT.
  ����� ���� ������� ���������� ����� mysql_query() ��� ������ UPDATE, DELETE
  ��� INSERT.
  ��� ������ SELECT mysql_affected_rows() �������� ���������� mysql_num_rows().

  ������������ ��������:
  ����� ����� ������ ���� ����� ���������� �����, ������������ ����������� ���
  �����������. ���� ���������, ��� �� ���� �� ������� �� ���� ��������� ���
  ������� UPDATE, �� ���� �� ����� �� ������� � ������������ WHERE � ������
  ������� ��� ��� �� ���� ������ ��� �� ��� ��������.
  �������� -1 ����������, ��� ������ ������ ��������� ������ ��� ��� ���
  ������� SELECT ������� mysql_affected_rows() ���� ������� ������ ���?��
  ������� mysql_store_result().
}
function TMySQL.GetAffectedRows: Integer;
begin
  if not Connected then
  begin
    Result := 0;
    Exit;
  end;

  Result := mysql_affected_rows(FMySQL);
end;

function TMySQL.GetConnected: Boolean;
begin
  Result := FConnectionCount > 0;
end;

function TMySQL.GetConnectionCount: Integer;
begin
  Result := FConnectionCount;
end;

function TMySQL.GetDatabase: string;
begin
  Result := FDatabase;
end;

function TMySQL.GetHost: string;
begin
  Result := FDatabase;
end;

function TMySQL.GetMySQL: PMySQL;
begin
  Result := FMySQL;
end;

function TMySQL.GetOnConnect: TNotifyEvent;
begin
  Result := FOnConnect;
end;

function TMySQL.GetOnDisconnect: TNotifyEvent;
begin
  Result := FOnDisconnect;
end;

function TMySQL.GetPassword: string;
begin
  Result := FPassword;
end;

function TMySQL.GetPort: Integer;
begin
  Result := FPort;
end;

function TMySQL.GetStatus: string;
begin
  Result := string(mysql_sqlstate(FMySQL));
end;

function TMySQL.GetUser: string;
begin
  Result := FUser;
end;

{
  ��������� ������ SQL, ��������� � ���������.
  ������ ������ ������ �������� �� ����� ������� SQL.
  ������ ��������� � ���� ������� � �������� ����������� ���������
  ����� � ������� (';') ��� \g.

  ������� �� ����� �������������� ��� ��������, ���������� �������� ������;

  ������������ ��������
  True ��� �������� ���������� �������. False, ���� ��������� ������.
}
function TMySQL.ExecSQL(const SQL: String): Boolean;
begin
  if not Connected then
  begin
    Result := False;
    Exit;
  end;

  {
    ��� ��������, ���������� �������� ������ ���������� ������������
    ������� mysql_real_query()
    (�������� ������ ����� ��������� ������ '\0', ������� mysql_query()
    �������������� ��� ��������� ������ �������)
  }
  Result := mysql_query(FMySQL, PChar(SQL)) = 0;
end;

{
  ��������� ������ SQL, ��������� � ���������.
  ������ ������ ������ �������� �� ����� ������� SQL.
  ������ ��������� � ���� ������� � �������� ����������� ���������
  ����� � ������� (';') ��� \g.

  ������� �� ����� �������������� ��� ��������, ���������� �������� ������;

  ������������ ��������
  IMySQLQuery ��� �������� ���������� �������. nil, ���� ��������� ������,
  ��� ��� ������ ������.
}
function TMySQL.Query(const SQL: string): IMySQLQuery;
var
  FRes: pmysql_res;
begin
  if not Connected then
  begin
    Result := nil;
    Exit;
  end;

  if (mysql_query(FMySQL, PChar(SQL)) = 0) then
  begin
    FRes := mysql_store_result(FMySQL);
    if FRes <> nil then
      Result := TMySQLQuery.Create(Self, FRes)
    else
      Result := nil;
  end else
    Result := nil;
  //if Assigned(FOnQuery) then FOnQuery(Self, sql);
end;

function TMySQL.ErrorCode: Integer;
begin
  Result := mysql_errno(FMySQL);
end;

function TMySQL.ErrorMessage: string;
begin
  Result := string(mysql_error(FMySQL));
end;

procedure TMySQL.SetPort(Value: Integer);
begin
  if Connected then Exit;
  FPort := Value;
end;

procedure TMySQL.SetHost(const Value: string);
begin
  if Connected then Exit;
  FHost := Value;
end;

procedure TMySQL.SetOnConnect(Value: TNotifyEvent);
begin
  FOnConnect := Value;
end;

procedure TMySQL.SetOnDisconnect(Value: TNotifyEvent);
begin
  FOnDisconnect := Value;
end;

procedure TMySQL.SetUser(const Value: string);
begin
  if Connected then Exit;
  FUser := Value;
end;

procedure TMySQL.SetPassword(const Value: string);
begin
  if Connected then Exit;
  FPassword := Value;
end;

{ ������������ � ���� ������. }
procedure TMySQL.SetDatabase(const Value: string);
begin
  if FDatabase = Value then Exit;

  if Value = '' then
  begin
    FDatabase := '';
    Exit;
  end;

  if Connected then
  begin
    if mysql_select_db(FMySQL, PChar(Value)) <> 0 then
      Exit;
  end;

  FDatabase := Value;
end;

{ TMySQLQuery }

constructor TMySQLQuery.Create(AMySQL: IMySQL; ARes: pmysql_res);
begin
  FRecNo := -1;
  FMySQL := AMySQL;
  FRes := ARes;
  FRecordCount := mysql_num_rows(FRes);
  FFieldCount := mysql_num_fields(FRes);
  FFields := mysql_fetch_fields(FRes);
end;

destructor TMySQLQuery.Destroy;
begin
  mysql_free_result(FRes);
  inherited;
end;

procedure TMySQLQuery.GoToRow(ARecNo: Integer);
begin
  if (ARecNo < 0) then ARecNo := 0
  else
  if (ARecNo >= RecordCount) then ARecNo := RecordCount - 1;

  mysql_data_seek(FRes, ARecNo);
  FRecNo := ARecNo;
  FRow := nil;
end;

{
  ���� ARecNo = -1 :
     ��������� ��������� ������ � �������������� ������ ������.
     (���� ������� ������ ��� �����������, �� ����������� ����� ������ ������.)
  ���� ARecNo <> -1 :
    ������� ������� � ������ ARecNo � ��������� � �� ��������������� ������ ������.
    (����������� ������ ����� ��������� �������� FetchRow)

  ������� ���������� True ���� ������� ������� ������ � False � ������ �������.
}
function TMySQLQuery.FetchRow(ARecNo: Integer = -1): Boolean;
begin
  if (ARecNo > -1) then
  begin
    GoToRow(ARecNo);
    FRecNo := FRecNo - 1;
  end;
  
  FRow := mysql_fetch_row(FRes);
  if FRow <> nil then
  begin
    Inc(FRecNo);
    Result := True;
  end else
    Result := False;
end;

function TMySQLQuery.GetValues(FieldNo: Integer): string;
begin
  if FRow <> nil then
    Result := StrPas(FRow[FieldNo]);
end;

function TMySQLQuery.GetValueByName(const FieldName: string): string;
var
  Index: Integer;
begin
  Index := GetFieldIndex(FieldName);
  if Index < 0 then
    Result := ''
  else
    Result := GetValues(Index);
end;

function TMySQLQuery.GetField(Index: Integer): pmysql_field;
begin
  if (Index < 0) or (Index >= FFieldCount) then
    Result := nil
  else
    Result := @FFields[Index];
end;

function TMySQLQuery.GetFieldCount: Integer;
begin
  Result := FFieldCount;
end;

function TMySQLQuery.GetRecNo: Integer;
begin
  if FRow = nil then
    Result := -1
  else
    Result := FRecNo;
end;

function TMySQLQuery.GetRecordCount: Integer;
begin
  Result := FRecordCount;
end;

function TMySQLQuery.GetFieldIndex(const Name: string): Integer;
begin
  for Result := 0 to FieldCount-1 do
    if String(Fields[Result].name) = Name then
      exit;
  Result := -1;
end;

function TMySQLQuery.GetFieldName(Index: Integer): string;
begin
  Result := string(Fields[Index].name);
end;

function TMySQLQuery.GetMySQL: IMySQL;
begin
  Result := FMySQL;
end;

end{$WARNINGS OFF}.
{
  ������ 1.0
  ----------
  [*]  ������ ��������� ������. (������� �����������)

  ������ 1.1
  ----------
  [*] TMySQL ��������� � IMySQL.
  ������:
      var
        MySQL: IMySQL;
      begin
        MySQL := TMySQL.Create;
        MySQL.Uset := 'root';
        ...... � ����� ��� ������
        ������� �� ������������ MyQSL �� ����
      end;

  [+] �������� FConnectionCount.
      ����� ���������� IMySQL.Connect, ��� �������! ����������, �������
      FConnectionCount �������������, IMySQL.Disconnect - ������� �����������.
      ������� ����������� ���������� ������ ����� ������� = 1,
      o��������� - ����� c������ = 0.

  [*] ������� property Fields
  [*] procedure Connect; ������� �� function Connect: Boolean; virtual;
  [*] ���������� FetchRow
}
