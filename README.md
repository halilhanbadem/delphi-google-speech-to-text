# Delphi Google Speech to Text Component

Hi,

this component has been developed completely free and open source. The main goal here is to meet the weak resource requirement in this regard. With Google Speech to Text technology, one of the many api applications offered by Google, you can transcribe the spoken voices. Its main purpose is to send commands with voice and to process this command in your projects. In the example of this project, a specific file is processed. If you wish, you can record and process instant audio with 3rd party components.

## Requirements
 * Indy Components
 * ssleay32.dll and libeay32.dll


## What To Do With Google Before Delphi
Go to https://cloud.google.com/speech-to-text. Go to console here or click the button that says what you want to try. If you are installing for the first time, it is indicated in the button as "make a test". Complete the setups. Credit card information may be requested during installation. My suggestion is to create a virtual card and define certain limit cards. It will give you a 90-day trial period. Don't be afraid if automatic billing has been stopped; your service will end when it is finished. After enabling the API, create a service account:

![image](https://user-images.githubusercontent.com/17130294/115894044-811ee280-a461-11eb-98cc-0090b221c3d8.png)


![image](https://user-images.githubusercontent.com/17130294/115893954-6c424f00-a461-11eb-8fa2-349c13fadccb.png)

After the service is created, go to the service details. Send a new key creation request from the "Keys" tab and download your json file as below:

![image](https://user-images.githubusercontent.com/17130294/115894204-aca1cd00-a461-11eb-9c06-09d9cd5ff239.png)

#### ⚠️ This file is important to us. When you open the content of the file, make sure that your "service e-mail address" has your private key value. ⚠️

This file corresponds to the "Private Key File" value on the component side.

## Component Setup
Define all source files in Delphi:
![image](https://user-images.githubusercontent.com/17130294/115894705-3d78a880-a462-11eb-9a4a-3a424b35088f.png)


After this, install the dpk file with Delphi. Then create a project.

#### ⚠️ You can also perform the next steps with the demo. ⚠️

 * Add one hbGoogle component to your project.
 * Add a button and come to the onclick event.
 * for hbGoogle; Define the PrivateKeyFile property value, the path to the json file we downloaded from Google.
 * For the VoiceFile property value, define the path to the sound file. Remember; The file should have wav extension and 16000hz.
 * If the audio file is not suitable, it will give you an error.
 * The SpeechLanguage value is for the language. Indicates which language the sound belongs to.

Sample code:

```
hbGoogle1.SpeechLanguage := 'tr-TR';
hbGoogle1.PrivateKeyFile := 'delphisestenyazi.json';
hbGoogle1.VoiceFile := 'temp.wav';
ShowMessage(hbGoogle1.SpeechToText); 
```

That's it! The return will come back to you in writing.

## Some Warnings

 * Please make sure that the sound recording is 16000hz and its original wav extension. You can use FFMpeg.
 * Excessive or incorrect use may have occurred in the codes. I will fix these issues over time.. Since I am making open source codes as a hobby; I can be interested in my work whenever I find time.
 * Please create an issue for your problems.
 * It only supports VCL.
 * Developed and tested with Delphi 10.4.2.

## Resources & Thanks
Due to the unique projects it has presented to everyone;<br>
https://github.com/grijjy/DelphiGoogleAPI <br>
Due to the codes that help with JWT;<br>
https://github.com/paolo-rossi/delphi-jose-jwt<br>
For signing RSA;<br>
https://github.com/SirAlex/delphi-jose-jwt<br>
And...<br>
Thank you very much to "Remy Lebeau" who came before me with every research.

