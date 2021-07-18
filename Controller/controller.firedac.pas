unit controller.firedac;

interface

uses
  interfaces.controllers, interfaces.firedac;

type
  TControllerFiredac = class(TInterfacedObject, iControllerFiredac)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iControllerFiredac;
      function Firedac: iFireDac;
  end;

implementation

uses
  model.firedac;

{ TControllerFiredac }

constructor TControllerFiredac.Create;
begin

end;

destructor TControllerFiredac.Destroy;
begin

  inherited;
end;

function TControllerFiredac.Firedac: iFireDac;
begin
  Result := TModelFiredac.Novo;
end;

class function TControllerFiredac.New: iControllerFiredac;
begin
    Result := Self.Create;
end;

end.
