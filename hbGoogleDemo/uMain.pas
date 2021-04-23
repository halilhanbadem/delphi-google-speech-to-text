unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, hbGoogle;

type
  TfMain = class(TForm)
    btnGetText: TButton;
    edtPrivateKey: TEdit;
    Label1: TLabel;
    edtVoiceFile: TEdit;
    Label3: TLabel;
    btnPrivateKey: TButton;
    btnVoiceFile: TButton;
    Voice: TOpenDialog;
    PrivateKey: TOpenDialog;
    hbGoogle1: ThbGoogle;
    procedure btnGetTextClick(Sender: TObject);
    procedure btnPrivateKeyClick(Sender: TObject);
    procedure btnVoiceFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.btnGetTextClick(Sender: TObject);
begin
 if Trim(edtPrivateKey.Text) = ''  then
 begin
  ShowMessage('Please select private key!');
  exit;
 end;

 if Trim(edtVoiceFile.Text) = ''  then
 begin
  ShowMessage('Please select voice file!');
  exit;
 end;

 hbGoogle1.SpeechLanguage := 'tr-TR';
 hbGoogle1.PrivateKeyFile := edtPrivateKey.Text;
 hbGoogle1.VoiceFile := edtVoiceFile.Text;
 ShowMessage(hbGoogle1.SpeechToText);
end;

procedure TfMain.btnPrivateKeyClick(Sender: TObject);
begin
 if PrivateKey.Execute then
 begin
   edtPrivateKey.Text := PrivateKey.FileName;
 end;
end;

procedure TfMain.btnVoiceFileClick(Sender: TObject);
begin
 if Voice.Execute then
 begin
   edtVoiceFile.Text := Voice.FileName;
 end;
end;

end.
