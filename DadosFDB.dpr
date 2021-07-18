program DadosFDB;

uses
  Vcl.Forms,
  model.consts in 'Model\model.consts.pas',
  model.acoesarquivos in 'Model\model.acoesarquivos.pas',
  model.firedac in 'Model\model.firedac.pas',
  view.frmUteis in 'View\view.frmUteis.pas' {Form1},
  interfaces.acoesarquivos in 'Interfaces\interfaces.acoesarquivos.pas',
  interfaces.Firedac in 'Interfaces\interfaces.Firedac.pas',
  interfaces.DAO in 'Interfaces\interfaces.DAO.pas',
  controller.firedac in 'Controller\controller.firedac.pas',
  interfaces.controllers in 'Interfaces\interfaces.controllers.pas',
  controller.acoesarquivos in 'Controller\controller.acoesarquivos.pas',
  model.firedacDAO in 'Model\model.firedacDAO.pas',
  controller.firedacDAO in 'Controller\controller.firedacDAO.pas',
  interfaces.arquivos in 'Interfaces\interfaces.arquivos.pas',
  model.arquivoFDB in 'Model\model.arquivoFDB.pas',
  model.arquivosOutros in 'Model\model.arquivosOutros.pas',
  view.frmConfiguracaoFirebird in 'View\view.frmConfiguracaoFirebird.pas' {frmConfig},
  interfaces.configConexao in 'Interfaces\interfaces.configConexao.pas',
  model.configuracaoFirebird in 'Model\model.configuracaoFirebird.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.Run;
end.
