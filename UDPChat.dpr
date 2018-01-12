program UDPChat;

uses
  Forms,
  uFormMain in 'uFormMain.pas' {ChatForm},
  uReceiveThread in 'uReceiveThread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DEMO by Monax - Простейший UPD-чат';
  Application.CreateForm(TChatForm, ChatForm);
  Application.Run;
end.
