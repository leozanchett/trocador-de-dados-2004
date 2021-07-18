unit interfaces.acoesarquivos;

interface

uses
  System.Classes, System.Generics.Collections, interfaces.arquivos, System.Zip;

type
   iAcoesArquivos = interface
      ['{6A74C31F-DED4-46CB-9230-2A459F40249E}']
      procedure CopiaArquivo(const _ADadosCopiar, _ANovoNome: String);
      function ExcluirArquivo: iAcoesArquivos;
      function RenomearArquivo(const _ADadosRenomear, _ADadosRenomeado: String; const _ADeleteIfExists: boolean): iAcoesArquivos;
      function CapturarBytesArquivo(const _ANomeArquivo: String): iAcoesArquivos;
      function TamanhoArquivoBytes: int64;
      function ApresentarFormatado(const _ASize: int64): String;
      function SetTipoArquivo(const _ATipoArquivo: iTipoArquivo): iAcoesArquivos;
      function GetTipoArquivo: iTipoArquivo;
      function ProcurarArquivos: TDictionary<String, TInfoArquivo>;
      function ZiparArquivo(const _AZip: TZipFile): iAcoesArquivos;
      procedure DescompactarArquivo;
   end;

implementation

end.
