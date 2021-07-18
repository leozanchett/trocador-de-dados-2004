unit interfaces.configConexao;

interface

type
  iConfigConexao = interface
    ['{920B3A66-639C-4ADD-B93E-EDF4A3957F82}']
    function getUsuario: String;
    function getSenha: String;
    function getDriver: String;
    function CreateIni: iConfigConexao;
    procedure SetConfiguracao(const _AUsuario, _ASenha: String);
  end;

implementation

end.
