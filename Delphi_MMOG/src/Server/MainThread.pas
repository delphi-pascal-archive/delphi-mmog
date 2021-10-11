unit MainThread;

interface
uses
  Classes,
  SysUtils,Clients,VectorGeometry, VectorTypes,ServerPackets;

type
  TMainThread = class(TThread)
  public
    { Public declarations }
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;





implementation

procedure TMainThread.Execute;     
var                                
  x,c,a:integer;
begin
WriteLn('Main Thread Started');
While (true) do
begin



sleep(1); //чтоб процесор не грузился на 100%
end;

end;

end.

