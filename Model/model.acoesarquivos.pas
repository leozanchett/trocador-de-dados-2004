unit model.acoesarquivos;

interface

uses
  interfaces.acoesarquivos, System.Classes, model.consts,
  System.Generics.Collections, interfaces.arquivos, System.Zip;

type
  TAcoesArquivos = class(TinterfacedObject, iAcoesArquivos)
    protected
      function ProcurarArquivos: TDictionary<String, TInfoArquivo>;
    private
      FTamanhoArquivo: Int64;
      FTipoArquivo: iTipoArquivo;
      function ProcurarFDB(const _ADadosNome: String): TInfoArquivo;
      function ProcurarOutros(var _i: byte; const _ADadosNome: String): TInfoArquivo;
    public
       procedure CopiaArquivo(const _ADadosCopiar, _ANovoNome: String);
       function ExcluirArquivo: iAcoesArquivos;
       function RenomearArquivo(const _ADadosRenomear, _ADadosRenomeado: String; const _ADeleteIfExists: boolean): iAcoesArquivos;
       function CapturarBytesArquivo(const _ANomeArquivo: String): iAcoesArquivos;
       function TamanhoArquivoBytes: int64;
       class function New: iAcoesArquivos;
       function ApresentarFormatado(const _ASize: int64): String;
       function SetTipoArquivo(const _ATipoArquivo: iTipoArquivo): iAcoesArquivos;
       function GetTipoArquivo: iTipoArquivo;
       procedure DescompactarArquivo;
       function ZiparArquivo(const _AZip: TZipFile): iAcoesArquivos;
  end;


implementation

uses
  System.IoUtils, Winapi.Windows, Math, System.SysUtils,
  System.StrUtils;

const
     UNIDADE_BYTES: Array [0 .. 8] of string = ('Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB');


{ TDiretorio }

procedure TAcoesArquivos.CopiaArquivo(const _ADadosCopiar, _ANovoNome: String);
begin
   TFile.Copy(_ADadosCopiar, _ANovoNome);
end;

procedure TAcoesArquivos.DescompactarArquivo;
var
  Azip: TZipFile;
  ATamanhoString: Integer;
  UltimosCaracteres: String;
begin
  Azip := TZipFile.Create;
  try
    try
      ATamanhoString := Length(GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString);
      UltimosCaracteres := copy(GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString, ATamanhoString - 3, 4);
      if MatchStr(UltimosCaracteres,['.rar','.zip']) then begin
        Azip.Open(GetTipoArquivo.getCDS.FieldByName('CAMINHOCOMPLETOARQUIVO').AsString, zmReadWrite);
        Azip.ExtractAll(DIRETORIO);
      end else
        raise Exception.Create(GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString + sLineBreak+ 'Não é um arquivo válido para descompactação.');
    except
      on e: Exception do
         raise Exception.Create(e.ToString);
    end;
  finally
    FreeAndNil(Azip);
  end;
end;

function TAcoesArquivos.ExcluirArquivo: iAcoesArquivos;
begin
  Result := Self;
  TFile.Delete(GetTipoArquivo.getCDS.FieldByName('CAMINHOCOMPLETOARQUIVO').AsString);
end;

function TAcoesArquivos.GetTipoArquivo: iTipoArquivo;
begin
  Result := FTipoArquivo;
end;

class function TAcoesArquivos.New: iAcoesArquivos;
begin
   Result := Self.Create;
end;


function TAcoesArquivos.ProcurarArquivos: TDictionary<String, TInfoArquivo>;
var
   ADadosNome, AExtensaoArquivo: String;
   ADicionario: TDictionary<String, TInfoArquivo>;
   AInfoArquivo: TInfoArquivo;
   i: Byte;
begin
   ADicionario := TDictionary<String, TInfoArquivo>.Create;
   i := 0;
   case GetTipoArquivo.ExtensaoArquivo of
      tpFDB: AExtensaoArquivo := '*.FDB';
      tpOutros: AExtensaoArquivo := '*';
   end;
   for ADadosNome in TDirectory.GetFiles(DIRETORIO, AExtensaoArquivo, TSearchOption.soAllDirectories) do begin
      if ADadosNome = DADOSTESTE then
         continue;
      case GetTipoArquivo.ExtensaoArquivo of
        tpFDB : begin
          inc(i);
          ADicionario.Add(i.ToString, ProcurarFDB(ADadosNome));
        end;
        tpOutros : begin
          AInfoArquivo := ProcurarOutros(i, ADadosNome);
          if not AInfoArquivo.CaminhoArquivo.IsEmpty then
            ADicionario.Add(i.ToString, AInfoArquivo);
        end;
      end;

   end;
   Result := ADicionario;
end;

function TAcoesArquivos.ProcurarOutros(var _i: byte; const _ADadosNome: String): TInfoArquivo;
begin
  Result.CaminhoArquivo := EmptyStr;
  if Copy(_ADadosNome, Length(_ADadosNome) - 3, Length(_ADadosNome)) = '.FDB' then
    Exit;
  Inc(_i);
  Result.Tamanho := ApresentarFormatado(CapturarBytesArquivo(_ADadosNome).TamanhoArquivoBytes);
  Result.CaminhoArquivo := _ADadosNome;
  Result.NomeArquivo := _ADadosNome.Replace(DIRETORIO + '\',EmptyStr).Trim;
end;

function TAcoesArquivos.ProcurarFDB(const _ADadosNome: String): TInfoArquivo;
begin
    Result.Tamanho := ApresentarFormatado(CapturarBytesArquivo(_ADadosNome).TamanhoArquivoBytes);
    Result.CaminhoArquivo := _ADadosNome;
    Result.NomeArquivo := _ADadosNome.Replace(DIRETORIO + '\',EmptyStr).Trim;
end;

function TAcoesArquivos.RenomearArquivo(const _ADadosRenomear, _ADadosRenomeado: String; const _ADeleteIfExists: boolean): iAcoesArquivos;
begin
   Result := Self;
   if TFile.Exists(_ADadosRenomeado) and (_ADeleteIfExists) then
      TFile.Delete(_ADadosRenomeado);
   if TFile.Exists(_ADadosRenomear) then
      TFile.Move(_ADadosRenomear, _ADadosRenomeado);
end;


function TAcoesArquivos.SetTipoArquivo(const _ATipoArquivo: iTipoArquivo): iAcoesArquivos;
begin
  Result := Self;
  FTipoArquivo := _ATipoArquivo;
end;

function TAcoesArquivos.TamanhoArquivoBytes: int64;
begin
    Result := FTamanhoArquivo;
end;

function TAcoesArquivos.ZiparArquivo(const _AZip: TZipFile): iAcoesArquivos;
var
  ACaminhoArqParaCompactacao: String;
begin
  result := Self;
  _AZip.Open(GetTipoArquivo.getCDS.FieldByName('CAMINHOCOMPLETOARQUIVO').AsString+'.rar', zmWrite);
  ACaminhoArqParaCompactacao := GetTipoArquivo.getCDS.FieldByName('CAMINHOCOMPLETOARQUIVO').AsString.Replace(GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString, EmptyStr);
  _AZip.Add(ACaminhoArqParaCompactacao+GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString);
end;

function TAcoesArquivos.ApresentarFormatado(const _ASize: int64): String;
var
     i: Cardinal;
begin
   begin
     i := 0;

     while _ASize > Power(1024, i + 1) do
       Inc(i);

     Result := FormatFloat('###0.##', _ASize / Power(1024, i)) + #32 + UNIDADE_BYTES[i];
   end;
end;

function TAcoesArquivos.CapturarBytesArquivo(const _ANomeArquivo: String): iAcoesArquivos;
var
    Ainfo: TWin32FileAttributeData;
begin
  begin
    result := Self;
    if NOT GetFileAttributesEx(PWideChar(_AnomeArquivo), GetFileExInfoStandard, @Ainfo) then
      EXIT;

    FTamanhoArquivo := Int64(Ainfo.nFileSizeLow) or Int64(Ainfo.nFileSizeHigh shl 32);
  end;
end;

end.
