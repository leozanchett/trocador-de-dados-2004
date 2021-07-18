unit controller.acoesarquivos;

interface

uses
  interfaces.controllers, interfaces.acoesarquivos, interfaces.arquivos;

type
  TControllerArquivos = class(TInterfacedObject, iControllerAcoesArquivos)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iControllerAcoesArquivos;
      function AcoesArquivos: iAcoesArquivos;
      function ArquivoFDB: iTipoArquivo;
      function ArquivoOutros: iTipoArquivo;
  end;

implementation

uses
  model.acoesarquivos, model.arquivoFDB, model.arquivosOutros;



{ TMinhaClasse }

function TControllerArquivos.AcoesArquivos: iAcoesArquivos;
begin
  Result := TAcoesArquivos.New;
end;

function TControllerArquivos.ArquivoFDB: iTipoArquivo;
begin
  Result := TArquivosFDB.new;
end;

function TControllerArquivos.ArquivoOutros: iTipoArquivo;
begin
  Result := TArquivosOutros.New;
end;

constructor TControllerArquivos.Create;
begin

end;

destructor TControllerArquivos.Destroy;
begin

  inherited;
end;

class function TControllerArquivos.New: iControllerAcoesArquivos;
begin
   Result := Self.Create;
end;

end.
