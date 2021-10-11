program Client;

uses
  Forms,
  main in 'main.pas' {FMain},
  NPCs_List in 'NPCs_List.pas',
  Char_List in 'Char_List.pas',
  UserInfo in 'UserInfo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
