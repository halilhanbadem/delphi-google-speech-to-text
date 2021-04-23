{
  Developer: Halil Han BADEM.
  Github: https://github.com/halilhanbadem
  Release Date: 23/04/2021
  Note; It is free and exchangeable. Please, if you are going to use the codes in an article, I would like you to cite the source.
}

unit Google.JWT;

interface

uses
 System.NetEncoding,
 Windows,
 SysUtils,
 StrUtils,
 DateUtils,
 Classes,
 System.JSON,
 System.IOUtils,
 JOSE.Signing.RSA;


type
 TGoogleJWT = class
    {Sýnýf oluþturucu ve yok edicisi.}
    constructor create;
    destructor destroy; override;

    {JWT için gerekli oluþturma fonksiyonlarý}
    function createHeader: string;
    function createClaim: string;
    function createSignature(Data: String): string;
    function createAllJWT: string;
   private
    {Ýlgili proplarýn deðiþken tanýmlarý.}
    FServiceMail, FYourMail, FScope, FAud, FPEMFilePath: String;
    FExp, FIat: Integer;
   public
    {Google için gerekli bilgiler}
    property serviceMail: string read FServiceMail write FServiceMail;
    property yourMail: string read FYourMail write FYourMail;
    property scope: string read FScope write FScope;
    property Aud: string read FAud write FAud;
    property Exp: integer read FExp write FExp;
    property Iat: integer read FIat write FIat;

    {Google üzerinden indirilen PK12 türünün PEM formatlý dosyanýn hali.}
    property PEMFilePath: string read FPEMFilePath write FPEMFilePath;
    function Base64Encoded(Val: String): String;
 end;

implementation

{ TGoogleJWT }



function TGoogleJWT.Base64Encoded(Val: String): String;
begin
 {String deðeri base64 encode biçimine çevirir}
 Result := TNetEncoding.Base64.Encode(Val);
end;

constructor TGoogleJWT.create;
begin
  inherited;
end;


function TGoogleJWT.createAllJWT: string;
var
 JWT, DigitString: String;
begin
 {JWT için gerekli bilgiler alýnýp base64 ile encode edilip hazýr hale getiriliyor.}
 DigitString := StringReplace(createHeader + '.' + createClaim, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
 JWT := (DigitString + '.' + createSignature(DigitString));
 JWT := StringReplace(JWT, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
 Result := (JWT);
end;

function TGoogleJWT.createClaim: string;
var
 Base64Result: String;
 vJson: TJsonObject;
 jExp, jIat: TJSONNumber;
begin
 {Google için claim alaný oluþturulur. Ýsteðin olduðu bölümdür.}
  exp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(IncSecond(Now, exp)));
  iat :=  DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now));

  vJson := TJSONObject.Create;
  jExp := TJSONNumber.Create(Exp);
  jIat := TJSONNumber.Create(Iat);
  try
    vJson.AddPair('iss', serviceMail);
    vJson.AddPair('scope', scope);
    vJson.AddPair('aud', aud);
    vJson.AddPair('exp', jExp);
    vJson.AddPair('iat', jIat);
    Base64Result := vJson.Format();

    Base64Result := UTF8ToUnicodeString(Base64Result);
    Base64Result := Trim(Base64Result);
    Base64Result := Base64Encoded(Base64Result);
    Result := Base64Result;
  finally
   FreeAndNil(vJson);
  end;
end;

function TGoogleJWT.createHeader: string;
var
 Base64Result: String;
begin
 {standart jwt json tümleci}
  Base64Result := '{"alg":"RS256","typ":"JWT"}';
  Base64Result := UTF8ToUnicodeString(Base64Result);
  Base64Result := Trim(Base64Result);
  Base64Result := Base64Encoded(Base64Result);
  Result := Base64Result;
end;

function TGoogleJWT.createSignature(Data: String): string;
var
 PEMByte: TStringList;
 fJson: TJSONValue;
 RSASign: TRSA;
begin
 {json dosyasý byte türüne dönüþtürülüp sonrasýnda base64 ile encode edilir.}
 PEMByte := TStringList.Create;
 RSASign := TRSA.Create;
 try
  PEMByte.LoadFromFile(PEMFilePath);
  fJson := TJSONObject.ParseJSONValue(PEMByte.Text);
  Result := TNetEncoding.Base64.EncodeBytesToString(RSASign.Sign(TEncoding.UTF8.GetBytes(Trim(Data)), TEncoding.UTF8.GetBytes(fJson.GetValue<string>('private_key')), RS256));
 finally
   FreeAndNil(fJson);
   PEMByte.Free;
   RSASign.Free;
 end;
end;

destructor TGoogleJWT.destroy;
begin
  inherited Destroy;
end;



end.
