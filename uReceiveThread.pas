unit uReceiveThread;

interface

uses
  SysUtils, Classes, WinSock;

type
  TReceiveThread = class(TThread)
  private
    fLogMsg : string;
    fSocket : TSocket;
    procedure DoLogMessage;
  protected
    procedure Execute; override;
    procedure LogMessage(const Msg: string);
  public
    constructor Create(aServerSocket: TSocket);
  end;

implementation

uses
  uFormMain;

{ TReceiveThread }

constructor TReceiveThread.Create(aServerSocket: TSocket);
begin
  fSocket := aServerSocket;
  inherited Create(False);
end;

procedure TReceiveThread.Execute;
var
  Buffer    : array[0..65506] of Byte;
  RecvAddr  : TSockAddr;
  RecvLen, AddrLen  : integer;
  Msg : string;
begin
  repeat
    AddrLen := SizeOf(RecvAddr);
    RecvLen := recvfrom(FSocket, Buffer, SizeOf(Buffer), 0, RecvAddr, AddrLen);
    if RecvLen < 0 then
    begin
      LogMessage('error :' + GetErrorString);
      Synchronize(ChatForm.OnStopServer);
      Break;
    end;
    SetLength(Msg, RecvLen);

    if RecvLen > 0 then
      move(Buffer, Msg[1], RecvLen);
    LogMessage('data: ' + inet_ntoa(RecvAddr.sin_addr) + ':' +
      IntToStr(ntohs(RecvAddr.sin_port)) + ': ' + Msg);
  until False;
  closesocket(fSocket);
end;

procedure TReceiveThread.LogMessage(const Msg: string);
begin
  fLogMsg := Msg;
  Synchronize(DoLogMessage);
end;

procedure TReceiveThread.DoLogMessage;
begin
  ChatForm.AddMessageToLog(fLogMsg);
end;

end.
