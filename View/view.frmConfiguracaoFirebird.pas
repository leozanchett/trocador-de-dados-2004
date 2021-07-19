unit view.frmConfiguracaoFirebird;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  interfaces.configConexao;

type
  TfrmConfig = class(TForm)
    Panel1: TPanel;
    btnConfirmar: TBitBtn;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FUsuarioAnterior: String;
    FSenhaAnterior: String;
    FConfigConexao: iConfigConexao;
    { Private declarations }
  public
    property ConfigConexao: iConfigConexao read FConfigConexao write FConfigConexao;
    function ConfigsAlteradas: boolean;
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

procedure TfrmConfig.btnConfirmarClick(Sender: TObject);
begin
  if String(edtUsuario.Text).IsEmpty then begin
    ShowMessage('O campo '+lblUsuario.Caption+' não pode ser vazio.');
    exit;
  end;
  if String(edtSenha.Text).IsEmpty then begin
    ShowMessage('O campo '+lblSenha.Caption+' não pode ser vazio.');
    exit;
  end;
  ShowMessage('Alterações aplicadas com sucesso');
  ConfigConexao.SetConfiguracao(edtUsuario.Text, edtSenha.Text);
  Self.Close;
end;

function TfrmConfig.ConfigsAlteradas: boolean;
begin
   Result := (FUsuarioAnterior <> edtUsuario.Text) or (FSenhaAnterior <> edtSenha.Text);
end;

procedure TfrmConfig.FormShow(Sender: TObject);
begin
  edtUsuario.Text := ConfigConexao.getUsuario;
  edtSenha.Text := ConfigConexao.getSenha;
  FUsuarioAnterior := edtUsuario.Text;
  FSenhaAnterior := edtSenha.Text;
end;

end.
