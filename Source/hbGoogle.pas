unit hbGoogle;

interface

uses
 Classes,
 StrUtils,
 SysUtils,
 Google.JWT,
 Google.Request,
 System.NetEncoding;


type
 ThbGoogle = class(TComponent)
   private
    FDeveloper, FLanguage, FEncoding, FPrivateKey, FVoiceFile: String;
    FRateHertz, FTokenExp: Integer;
    FGoogleRequest: TGoogleRequest;
   public
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; Override;
    function SpeechToText: String;
   published
    property SpeechLanguage: String read FLanguage write FLanguage;
    property SpeechRateHertz: Integer read FRateHertz write FRateHertz default 16000;
    property SpeechEncoding: String read FEncoding write FEncoding;
    property TokenExpired: Integer read FTokenExp write FTokenExp default 3600;
    property PrivateKeyFile: String read FPrivateKey write FPrivateKey;
    property VoiceFile: String read FVoiceFile write FVoiceFile;
    property CVersion: String read FDeveloper;
 end;

 procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('hbGoogle', [ThbGoogle]);
end;

constructor ThbGoogle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGoogleRequest := TGoogleRequest.Create;
  TokenExpired := 3600;
  SpeechRateHertz := 16000;
  SpeechLanguage := 'en-EN';
  SpeechEncoding := 'LINEAR16';
  FDeveloper := 'v1.0 | Dev. Halil Han BADEM';
end;

destructor ThbGoogle.Destroy;
begin
  FGoogleRequest.destroy;
  inherited Destroy;
end;

function ThbGoogle.SpeechToText: String;
var
 xVoiceFile: TMemoryStream;
 Base64File: String;
begin
  if Trim(PrivateKeyFile) = '' then
  begin
   raise Exception.Create('Please set an information file.');
  end;

  if Trim(VoiceFile) = '' then
  begin
   raise Exception.Create('Please set an voice file.');
  end;

  if ExtractFileExt(PrivateKeyFile) <> '.json' then
  begin
    raise Exception.Create('In order to get values such as service name and private key, the json file provided through the Google console is required.');
  end;

  if ExtractFileExt(VoiceFile) <> '.wav' then
  begin
    raise Exception.Create('Currently, only 16000hz sounds with wav extensions are accepted.');
  end;

 xVoiceFile := TMemoryStream.Create;
 try
  xVoiceFile.LoadFromFile(VoiceFile);
  Base64File := StringReplace(TNetEncoding.Base64.EncodeBytesToString(xVoiceFile.Memory, xVoiceFile.Size), sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
  Result := FGoogleRequest.getSpeechToText(Base64File, FGoogleRequest.getToken(PrivateKeyFile, TokenExpired), SpeechEncoding, speechRateHertz.ToString, SpeechLanguage);
 finally
  xVoiceFile.Free;
 end;
 end;

end.
