unit uFormMain;


interface

uses
  Windows, SysUtils, Forms, Dialogs, Classes, Controls, StdCtrls, WinSock,
  uReceiveThread;

type
  TChatForm = class(TForm)
    GroupBox1: TGroupBox;
    LabelServerPort: TLabel;
    LabelServerState: TLabel;
    EditServerPort: TEdit;
    BtnStartServer: TButton;
    MemoMessages: TMemo;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    EditMessage: TEdit;
    Label2: TLabel;
    EditSendAddr: TEdit;
    Label3: TLabel;
    BtnSend: TButton;
    EditSendPort: TEdit;
    LabelSendPort: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnStartServerClick(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
  private
    fSendSocket : TSocket;
  public
    procedure AddMessageToLog(const aMsg: string);
    procedure OnStopServer;
  end;

var
  ChatForm: TChatForm;

// funcs
  function GetErrorString: string;

implementation
{$R *.DFM}

function GetErrorString: string;
var
  Buffer: array[0..2047] of Char;
begin
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, WSAGetLastError, $400,
    @Buffer, SizeOf(Buffer), nil);
  Result := Buffer;
end;

procedure TChatForm.AddMessageToLog(const aMsg: string);
begin
  MemoMessages.Lines.Add(aMsg);
  MemoMessages.SelStart := Length(MemoMessages.Text);
end;

procedure TChatForm.OnStopServer;
begin
  LabelServerPort.Enabled := True;
  EditServerPort.Enabled := True;
  BtnStartServer.Enabled := True;
  LabelServerState.Caption := 'state 2';
end;

procedure TChatForm.FormCreate(Sender: TObject);
var
  WSAData : TWSAData;
  Addr  : TSockAddr;
  AddrLen : Integer;
begin
  if WSAStartup($101, WSAData) <> 0 then
  begin
    MessageDlg('error0 to WinSock', mtError, [mbOK], 0);
    Application.Terminate;
  end;
  OnStopServer;
  fSendSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if fSendSocket = INVALID_SOCKET then
  begin
    MessageDlg('Error1:'#13#10 + GetErrorString, mtError, [mbOK], 0);
    Exit;
  end;
  FillChar(Addr.sin_zero, SizeOf(Addr.sin_zero), 0);
  Addr.sin_family := AF_INET;
  Addr.sin_addr.S_addr := INADDR_ANY;
  Addr.sin_port := 0;
  if bind(fSendSocket, Addr, SizeOf(Addr)) = SOCKET_ERROR then
  begin
    MessageDlg('Error 2:'#13#10 + GetErrorString, mtError, [mbOK], 0);
    Exit;
  end;
  AddrLen := SizeOf(Addr);
  if getsockname(fSendSocket, Addr, AddrLen) = SOCKET_ERROR then
  begin
    MessageDlg('Error3:'#13#10 + GetErrorString, mtError, [mbOK], 0);
    Exit;
  end;
  LabelSendPort.Caption := 'State 1: ' + IntToStr(ntohs(Addr.sin_port));
end;

procedure TChatForm.BtnStartServerClick(Sender: TObject);
var
  ServerSocket  : TSocket;
  ServerAddr  : TSockAddr;
begin
  FillChar(ServerAddr.sin_zero, SizeOf(ServerAddr.sin_zero), 0);
  ServerAddr.sin_family := AF_INET;
  ServerAddr.sin_addr.S_addr := INADDR_ANY;
  ServerAddr.sin_port := htons(StrToInt(EditServerPort.Text));
  if ServerAddr.sin_port = 0 then
  begin
    MessageDlg('error 4 1-65535', mtError, [mbOK], 0);
    Exit;
  end;
  ServerSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if ServerSocket = INVALID_SOCKET then
  begin
    MessageDlg('Error 5:'#13#10 + GetErrorString, mtError, [mbOK], 0);
    Exit;
  end;
  if bind(ServerSocket, ServerAddr, SizeOf(ServerAddr)) = SOCKET_ERROR then
  begin
    MessageDlg('error 6:'#13#10 + GetErrorString, mtError, [mbOK], 0);
    closesocket(ServerSocket);
    Exit;
  end;
  TReceiveThread.Create(ServerSocket);
  LabelServerPort.Enabled := False;
  EditServerPort.Enabled := False;
  BtnStartServer.Enabled := False;
  LabelServerState.Caption := 'State 3';
end;

procedure TChatForm.BtnSendClick(Sender: TObject);
var
  SendAddr: TSockAddr;
  Msg     : string;
  SendRes : Integer;
begin
  FillChar(SendAddr.sin_zero, SizeOf(SendAddr.sin_zero), 0);
  SendAddr.sin_family := AF_INET;
  SendAddr.sin_addr.S_addr := inet_addr(PChar(EditSendAddr.Text));
  if SendAddr.sin_addr.S_addr = INADDR_NONE then
  begin
    MessageDlg('"' +EditSendAddr.Text + '" ερρορ 6', mtError, [mbOK], 0);
    Exit;
  end;
  SendAddr.sin_port := htons(StrToInt(EditSendPort.Text));
  Msg := EditMessage.Text;
  if Length(Msg) = 0 then
    SendRes := sendto(fSendSocket, Msg, 0, 0, SendAddr, SizeOf(SendAddr))
  else
    SendRes := sendto(fSendSocket, Msg[1], Length(Msg), 0, SendAddr, SizeOf(SendAddr));
  if SendRes < 0 then
    MessageDlg('error 7:'#13#10 + GetErrorString, mtError, [mbOK], 0)
  else
    AddMessageToLog('Έστειλα στον ' + EditSendAddr.Text + ':' + EditSendPort.Text+'[' + Msg+']');
end;

end.
