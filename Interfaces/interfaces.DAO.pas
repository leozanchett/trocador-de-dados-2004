unit interfaces.DAO;

interface

uses
  FireDAC.Comp.Client, interfaces.configConexao;

type
  iDaoFiredac = interface
    ['{C50A9F37-2BE3-49DB-A972-B1047EF5A9B8}']
    function Conectar(const _ACaminhoDADOS: String; const _IConfigConexao: iConfigConexao): iDaoFiredac;
    function Conexao: TFDConnection;
  end;

implementation

end.
