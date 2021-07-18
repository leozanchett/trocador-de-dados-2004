unit model.arquivosOutros;

interface

uses
  interfaces.arquivos, Datasnap.DBClient, model.consts;

type
  TArquivosOutros = class(TInterfacedObject, iTipoArquivo)
        private
           FCDS: TClientDataSet;
        public
           function CreateCDS: iTipoArquivo;
           function getCDS: TClientDataSet;
           class function new: iTipoArquivo;
           destructor Destroy; override;
           function ExtensaoArquivo: TTipoProcuraArquivo;
     end;

implementation

uses
  Data.DB, System.SysUtils,  interfaces.acoesarquivos;

{ TArquivosOutros }

function TArquivosOutros.CreateCDS: iTipoArquivo;
begin
  Result := Self;
  FCDS := TClientDataSet.Create(nil);
  FCDS.FieldDefs.Add('NOMEARQUIVO', ftString, 300);
  FCDS.FieldDefs.Add('TAMANHO', ftString, 100);
  FCDS.FieldDefs.Add('BYTES', ftInteger);
  FCDS.FieldDefs.Add('CAMINHOCOMPLETOARQUIVO', ftString, 500);
  FCDS.CreateDataSet;
end;

destructor TArquivosOutros.Destroy;
begin
  FreeAndNil(FCDS);
  inherited;
end;


function TArquivosOutros.ExtensaoArquivo: TTipoProcuraArquivo;
begin
  Result := tpOutros;
end;

function TArquivosOutros.getCDS: TClientDataSet;
begin
   Result := FCDS;
end;

class function TArquivosOutros.new: iTipoArquivo;
begin
   Result := Self.Create;
end;

end.
