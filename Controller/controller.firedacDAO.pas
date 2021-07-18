unit controller.firedacDAO;

interface

uses
  interfaces.controllers, interfaces.DAO, interfaces.configConexao;

type
  TControllerFiredacDAO = class(TInterfacedObject, iControllerFiredacDAO)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iControllerFiredacDAO;
      function FiredacDAO: iDaoFiredac;
      function ConfigFirebird: iConfigConexao;
  end;

implementation

uses
  model.FiredacDAO, model.configuracaoFirebird;

{ TControllerFiredacDAO }

function TControllerFiredacDAO.ConfigFirebird: iConfigConexao;
begin
  Result := TConfigFirebird.New;
end;

constructor TControllerFiredacDAO.Create;
begin

end;

destructor TControllerFiredacDAO.Destroy;
begin

  inherited;
end;

function TControllerFiredacDAO.FiredacDAO: iDaoFiredac;
begin
   Result := TFiredacDAO.New;
end;

class function TControllerFiredacDAO.New: iControllerFiredacDAO;
begin
   Result := Self.Create;
end;

end.
