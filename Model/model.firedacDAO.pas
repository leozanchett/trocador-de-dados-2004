unit model.FiredacDAO;

interface

uses
  interfaces.DAO, FireDAC.Comp.Client, Firedac.Stan.Def, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys.FB, FireDAC.VCLUI.Wait,
  interfaces.configConexao;

type
  TFiredacDAO = class(TInterfacedObject, iDaoFiredac)
    private
      FFIredacConexao : TFDConnection;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iDaoFiredac;
      function Conectar(const _ACaminhoDADOS: String; const _IConfigConexao: iConfigConexao): iDaoFiredac;
      function Conexao: TFDConnection;
  end;

implementation

uses
  System.SysUtils, Vcl.Forms;


{ TMinhaClasse }

function TFiredacDAO.Conectar(const _ACaminhoDADOS: String; const _IConfigConexao: iConfigConexao): iDaoFiredac;
begin
   Result := Self;
   try
     FFIredacConexao := TFDConnection.Create(Application);
     FFIredacConexao.Close;
     FFIredacConexao.Params.Clear;
     FFIredacConexao.Params.DriverID := _IConfigConexao.getDriver;
     FFIredacConexao.Params.Database := _ACaminhoDADOS;
     FFIredacConexao.Params.UserName := _IConfigConexao.getUsuario;
     FFIredacConexao.Params.Password := _IConfigConexao.getSenha;
     FFIredacConexao.Connected := True;
     FFIredacConexao.LoginPrompt := false;
   except
    on e: Exception do
      exit;
   end;
end;

function TFiredacDAO.Conexao: TFDConnection;
begin
  Result := FFIredacConexao;
end;

constructor TFiredacDAO.Create;
begin

end;

destructor TFiredacDAO.Destroy;
begin

  inherited;
end;

class function TFiredacDAO.New: iDaoFiredac;
begin
    Result := Self.Create;
end;

end.
