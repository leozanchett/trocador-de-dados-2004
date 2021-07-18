unit model.configuracaoFirebird;

interface

uses
  interfaces.configConexao, System.IniFiles;

  type
    TConfigFirebird = class(TInterfacedObject, iConfigConexao)
      private
        FIniFile: TIniFile;
      public
        function getUsuario: String;
        function getSenha: String;
        function getDriver: String;
        function CreateIni: iConfigConexao;
        procedure SetConfiguracao(const _AUsuario, _ASenha: String);
        class function New: iConfigConexao;
        destructor Destroy; override;

    end;

implementation

uses
  Vcl.Forms, System.SysUtils;

{ TConfigFirebird }

function TConfigFirebird.CreateIni: iConfigConexao;
begin
  Result := Self;
  FIniFile := TIniFile.Create(Application.ExeName+'.ini');
end;

destructor TConfigFirebird.Destroy;
begin
  freeandnil(FIniFile);
  inherited;
end;

function TConfigFirebird.getDriver: String;
begin
  Result := 'FB';
end;

function TConfigFirebird.getSenha: String;
begin
  Result := FIniFile.ReadString('Firebird', 'senha', '');
end;

function TConfigFirebird.getUsuario: String;
begin
  Result := FIniFile.ReadString('Firebird', 'usuario', '');
end;

class function TConfigFirebird.New: iConfigConexao;
begin
  Result := self.Create;
end;

procedure TConfigFirebird.SetConfiguracao(const _AUsuario, _ASenha: String);
begin
  FIniFile.WriteString('Firebird', 'usuario', _AUsuario);
  FIniFile.WriteString('Firebird', 'senha', _ASenha);
end;

end.
