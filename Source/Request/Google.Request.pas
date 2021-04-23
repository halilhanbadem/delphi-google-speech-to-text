{
  Developer: Halil Han BADEM.
  Github: https://github.com/halilhanbadem
  Release Date: 23/04/2021
  Note; It is free and exchangeable. Please, if you are going to use the codes in an article, I would like you to cite the source.
}

unit Google.Request;

interface

uses
 Classes,
 System.IOUtils,
 SysUtils,
 StrUtils,
 DateUtils,
 Google.JWT,
 Windows,
 System.Net.URLClient,
 System.Net.HttpClient,
 System.Net.HttpClientComponent,
 System.NetEncoding,
 System.JSON,
 Vcl.StdCtrls,
 ClipBrd;

type
 TGoogleRequest = class
    constructor create;
    destructor destroy;
    function getToken(PEMFile: String; Exp: Integer): String;
    function getSpeechToText(WAVBase64, Token, encoding, rate, language: String): String;
   private
    RequestClient: TNetHTTPClient;
    RequestComp: TNetHTTPRequest;
    GoogleJWT: TGoogleJWT;
   public

 end;

resourcestring
 GoogleAuthLink = 'https://www.googleapis.com/oauth2/v4/token';


implementation

{ TGoogleRequest }


constructor TGoogleRequest.create;
begin
 RequestClient := TNetHTTPClient.Create(nil);
 RequestComp := TNetHTTPRequest.Create(nil);
 RequestComp.Client := RequestClient;
 GoogleJWT := TGoogleJWT.create;
end;

destructor TGoogleRequest.destroy;
begin
  RequestComp.Free;
  RequestClient.Free;
  GoogleJWT.Destroy;
  inherited Destroy;
end;



function TGoogleRequest.getSpeechToText(WAVBase64, Token, encoding, rate, language: String): String;
var
 dJson, aJson, mJson: TJSONObject;
 cJson: TJSONValue;
 JSON, rJSON: String;
 RequestStream: TStringStream;
begin
 dJson := TJSONObject.Create;
 aJson := TJSONObject.Create;
 mJson := TJSONObject.Create;
 try
   dJson.AddPair('encoding', encoding);
   dJson.AddPair('sampleRateHertz', rate);
   dJson.AddPair('languageCode', language);
   dJson.AddPair('enableWordTimeOffsets', 'false');
   mJson.AddPair('config', dJson);
   aJson.AddPair('content', WAVBase64);
   mJson.AddPair('audio', aJson);
   JSON := mJson.Format;
   Clipboard.AsText := JSON;
   RequestComp.CustomHeaders['Authorization'] := 'Bearer ' + Token;
   RequestComp.CustomHeaders['Content-Type'] := 'application/json';
   RequestStream := TStringStream.Create(JSON);
   rJSON := RequestComp.Post('https://speech.googleapis.com/v1/speech:recognize', RequestStream).ContentAsString();
   cJson := TJSONObject.ParseJSONValue(rJSON);

   try

    Result := cJson.GetValue<string>('results[0].alternatives[0].transcript');
   except
    Result := 'empty/error';
   end;
 finally
   FreeAndNil(mJson);
   CJSON.Free;
   FreeAndNil(RequestStream);
 end;
end;

function TGoogleRequest.getToken(PEMFile: String; Exp: Integer): String;
var
 Sonuc: String;
 RequestBody, InfoText: TStringList;
 gJson, rJson: TJSONValue;
 VarMi: Boolean;
begin
  with GoogleJWT do
  begin
    InfoText := TStringList.Create;
    InfoText.LoadFromFile(PEMFile);
    rJson := TJSONObject.ParseJsonValue(InfoText.Text);
    serviceMail := rJson.GetValue<string>('client_email');
    scope := 'https://www.googleapis.com/auth/cloud-platform';
    Aud := 'https://www.googleapis.com/oauth2/v4/token';
    Exp := Exp;
    PEMFilePath := PEMFile;

    RequestBody := TStringList.Create;
    try
     RequestBody.Add('grant_type=' + ('urn:ietf:params:oauth:grant-type:jwt-bearer'));
     RequestBody.Add('assertion=' + createAllJWT);
     RequestClient.ContentType := 'application/x-www-form-urlencoded';
     Sonuc := RequestClient.Post(GoogleAuthLink, RequestBody).ContentAsString();
     gJson := TJSONObject.ParseJSONValue(Sonuc);
     try
      try
       Result := gJson.GetValue<string>('access_token');
      except
        Result := 'error';
      end;
     finally
      FreeAndNil(gJson);
     end;
    finally
      RequestBody.Free;
      InfoText.Free;
      FreeAndNil(rJson);
    end;
  end;
end;


end.
