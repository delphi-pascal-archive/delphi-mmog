unit RusOLMSQL;

interface

uses MySQLClasses;

type
  TResult=array of array of Variant;

procedure Init;
function Query(q:string):TResult;
procedure Close;

implementation

const
  host='russiaonline.sytes.net';
  user='RusOLServ';
  pass='fjdhlfagfgjk';
  base='rogame';

var
  mc:TMySQL;

procedure Init;
begin
  mc:=TMySQL.Create;
  mc.Host:=host;
  mc.Port:=3306;
  mc.User:=user;
  mc.Password:=pass;
  mc.Connect;
  mc.Database:=base;
end;

function Query(q:string):TResult;
var
  mq:IMySQLQuery;
  i,j:integer;
begin
  mq:=mc.Query(q);
  SetLength(Result,mq.RecordCount);
  for i:=0 to mq.RecordCount-1 do begin
    SetLength(Result[i],mq.FieldCount);
    mq.FetchRow(i);
    for j:=0 to mq.FieldCount-1 do begin
      Result[i][j]:=mq.Values[j];
    end;
  end;
end;

procedure Close;
begin
  mc.Disconnect;
  mc.Free;
end;

end.
