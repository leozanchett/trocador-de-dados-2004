unit view.renomearArquivo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  interfaces.acoesarquivos;

type
  TfrmRenomarArquivo = class(TForm)
    Edit1: TEdit;
    Panel1: TPanel;
    btnCancelar: TButton;
    Panel2: TPanel;
    btnConfirmar: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FInterfaceArquivo : iAcoesArquivos;
    FHouveAlteracao: boolean;
    FExtensaoArquivo: String;
    { Private declarations }
  public
    property IArquivo: iAcoesArquivos read FInterfaceArquivo write FInterfaceArquivo;
    property HouveAlteracao: boolean read FHouveAlteracao write FHouveAlteracao;
    { Public declarations }
  end;

var
  frmRenomarArquivo: TfrmRenomarArquivo;

implementation

uses
  model.consts;

{$R *.dfm}

procedure TfrmRenomarArquivo.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmRenomarArquivo.btnConfirmarClick(Sender: TObject);
begin
  if not String(Edit1.Text).IsEmpty then begin
    IArquivo.RenomearArquivo(DIRETORIO+'\'+Edit1.Text+FExtensaoArquivo);
    HouveAlteracao := true;
    self.Close;
  end else
    ShowMessage('O nome do arquivo não pode ficar vazio');
  Edit1.SetFocus;
end;

procedure TfrmRenomarArquivo.FormShow(Sender: TObject);
begin
  FExtensaoArquivo := Copy(IArquivo.GetTipoArquivo.NomeArquivo, Length(IArquivo.GetTipoArquivo.NomeArquivo) -3, Length(IArquivo.GetTipoArquivo.NomeArquivo));
  HouveAlteracao := false;
  Edit1.Text := IArquivo.GetTipoArquivo.NomeArquivo.Replace(FExtensaoArquivo, '');
end;

end.
