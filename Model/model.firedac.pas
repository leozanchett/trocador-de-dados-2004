unit model.firedac;

interface

uses
  interfaces.firedac, interfaces.DAO, FireDAC.Comp.Client, Datasnap.DBClient;
type
   TModelFiredac = class (TInterfacedObject, iFireDac)
      public
         constructor Create;
         destructor Destroy; override;
         function SelectRazaoSocial(_ADAOFiredac: iDaoFiredac): TClientDataset;
         class function Novo: iFireDac;
   end;

implementation

uses
  Data.DB, FireDac.Dapt, System.SysUtils;


{ TModelFiredac }

class function TModelFiredac.Novo: iFireDac;
begin
   Result := Self.Create;
end;

function TModelFiredac.SelectRazaoSocial(_ADAOFiredac: iDaoFiredac): TClientDataset;
begin
   try
      _ADAOFiredac.Conexao.ExecSQL('SELECT CHAVE, RAZAOSOCIAL FROM EMPRESA ORDER BY CHAVE DESC', TDataSet(Result));
   except
      on e: Exception do
         exit;
   end;
end;

constructor TModelFiredac.Create;
begin

end;

destructor TModelFiredac.Destroy;
begin

  inherited;
end;


end.
