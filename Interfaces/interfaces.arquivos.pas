unit interfaces.arquivos;

interface

uses
   Datasnap.DBClient, model.consts;

type

   TInfoArquivo = record
      NomeArquivo: String;
      Tamanho: String;
      CaminhoArquivo: String;
    end;

   iTipoArquivo = interface
      ['{0A512577-755C-458B-BFDC-BF4EF00016CC}']
      function ExtensaoArquivo: TTipoProcuraArquivo;
      function CreateCDS: iTipoArquivo;
      function getCDS: TClientDataSet;
      function NomeArquivo: String;
      function CaminhoCompletoArquivo: String;
end;

implementation

end.
