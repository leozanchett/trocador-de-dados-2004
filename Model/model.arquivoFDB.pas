unit model.arquivoFDB;

interface

uses
  Datasnap.DBClient, interfaces.arquivos, model.consts;

type
   TArquivosFDB = class(TInterfacedObject, iTipoArquivo)
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
  Data.DB, System.SysUtils,
  interfaces.acoesarquivos;

{ TArquivosFDB }

function TArquivosFDB.CreateCDS: iTipoArquivo;
begin
   Result := Self;
   FCDS := TClientDataSet.Create(nil);
   FCDS.FieldDefs.Add('CHAVEEMP', ftInteger);
   FCDS.FieldDefs.Add('RAZAOSOCIAL', ftString, 188);
   FCDS.FieldDefs.Add('NOMEARQUIVO', ftString, 203);
   FCDS.FieldDefs.Add('TAMANHO', ftString, 100);
   FCDS.FieldDefs.Add('CAMINHOCOMPLETOARQUIVO', ftString, 500);
   FCDS.FieldDefs.Add('BYTES', ftInteger);
   FCDS.CreateDataSet;
end;

destructor TArquivosFDB.Destroy;
begin
   FreeAndNil(FCDS);
  inherited;
end;

function TArquivosFDB.ExtensaoArquivo: TTipoProcuraArquivo;
begin
   Result := tpFDB;
end;

function TArquivosFDB.getCDS: TClientDataSet;
begin
   Result := FCDS;
end;

class function TArquivosFDB.new: iTipoArquivo;
begin
   Result := Self.Create;
end;

end.
