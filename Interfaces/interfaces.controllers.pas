unit interfaces.controllers;

interface

uses
  interfaces.firedac, interfaces.acoesarquivos, interfaces.DAO,
  interfaces.arquivos, interfaces.configConexao;

type
  iControllerFiredac = interface
    ['{872C0F08-80CC-49A2-BF4B-03C29ED463BB}']
    function Firedac: iFireDac;
  end;

  iControllerAcoesArquivos = interface
    ['{0D09CE6D-32B7-4C71-9D5F-1201AE2CBE2A}']
    function AcoesArquivos: iAcoesArquivos;
    function ArquivoFDB: iTipoArquivo;
    function ArquivoOutros: iTipoArquivo;
  end;

  iControllerFiredacDAO = interface
    ['{30FE2DDE-0655-4E36-9C6F-0938C2B89BFB}']
    function FiredacDAO: iDaoFiredac;
    function ConfigFirebird: iConfigConexao;
  end;

implementation

end.
