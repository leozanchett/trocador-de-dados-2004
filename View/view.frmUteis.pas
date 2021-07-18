unit view.frmUteis;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXPanels, Data.DB, Vcl.Grids, Vcl.DBGrids, interfaces.acoesarquivos,
  interfaces.firedac, Datasnap.DBClient, interfaces.DAO, Vcl.Imaging.GIFImg, System.Zip,
  Vcl.Buttons, System.StrUtils, interfaces.arquivos, interfaces.configConexao;

type
  TTipoArquivo = (tpFDB, tpOutros);

  TForm1 = class(TForm)
    Panel1: TPanel;
    btnVoltarDadosAnterior: TButton;
    btnUsarDadosTeste: TButton;
    DBGrid1: TDBGrid;
    edtTotal: TEdit;
    Label1: TLabel;
    btnExcluir: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    btnRefreshGrid: TButton;
    Image1: TImage;
    btnZipar: TButton;
    btnGuardarDados: TButton;
    Label2: TLabel;
    pnlTop: TPanel;
    rgArquivos: TRadioGroup;
    edtCaminhoDir: TEdit;
    btnDescompacatar: TBitBtn;
    btnConfigurarConexao: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnUsarDadosTesteClick(Sender: TObject);
    procedure btnVoltarDadosAnteriorClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnRefreshGridClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnZiparClick(Sender: TObject);
    procedure btnGuardarDadosClick(Sender: TObject);
    procedure rgArquivosClick(Sender: TObject);
    procedure btnDescompacatarClick(Sender: TObject);
    procedure btnConfigurarConexaoClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FTipoArquivoFDB: iTipoArquivo;
    FConfigConexao: iConfigConexao;
    FTipoArquivoOutros: iTipoArquivo;
    FInterfaceArquivo: iAcoesArquivos;
    FFiredac: iFiredac;
    FFiredacDAO: iDaoFiredac;
    FDataSource: TDataSource;
    procedure MontarGrid(const _ANecessarioMapearDiretorio: Boolean;  _AFocus: Boolean = true);
    procedure EventoOnProgress(Sender: TObject; FileName: string; Header: TZipHeader; Position: Int64);
    procedure GridFDB(const _ANecessarioMapearDiretorio: boolean; const _AFocus: boolean = true);
    procedure MontarColunasGridArquivos;
    procedure MontarColunasOutros;
    procedure GridOutros(const _ANecessarioMapearDiretorio: boolean);
    procedure ConfigInicial;
    procedure ControlarDisponiblidadeComponentes;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  MSG_OPERACAO = 'Operação concluída';
  MGS_EXCECAO = 'Houve uma exceção:';

var
  Form1: TForm1;

implementation

uses
  model.consts, controller.acoesarquivos,
  controller.firedac, controller.firedacDAO,
  System.Generics.Collections, System.RegularExpressions, Math,
  view.frmConfiguracaoFirebird;

{$R *.dfm}

procedure TForm1.btnConfigurarConexaoClick(Sender: TObject);
var
  AformConfig: TFrmConfig;
begin
  AformConfig := TfrmConfig.Create(nil);
  try
    AformConfig.ConfigConexao := FConfigConexao;
    AformConfig.ShowModal;
    ControlarDisponiblidadeComponentes;   
  finally
    AformConfig.Free;
  end;
end;

procedure TForm1.btnDescompacatarClick(Sender: TObject);
begin
  try
    FInterfaceArquivo.DescompactarArquivo;
    MontarGrid(True);
    ShowMessage(MSG_OPERACAO);
  except
    on e: Exception do
      ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
  end;
end;

procedure TForm1.btnExcluirClick(Sender: TObject);
begin
   try
    FInterfaceArquivo.ExcluirArquivo;
    ShowMessage(MSG_OPERACAO);
    // TODO -oLeo: Bolar uma maneira de não precisar mapear os arquivos novamente, alterar apenas o client no grid.
    MontarGrid(true);
   except
      on e: Exception do
         ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
   end;
end;

procedure TForm1.btnGuardarDadosClick(Sender: TObject);
var
  Azip: TZipFile;
begin
  Azip := TZipFile.Create;
  try
    try
      Azip.OnProgress := EventoOnProgress;
      try
        FInterfaceArquivo.ZiparArquivo(Azip).ExcluirArquivo;
      except
        on e: Exception do begin
          ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
          Exit;
        end;
      end;
      Label2.Visible := false;
      Image1.Visible := true;
    except
      on e: Exception do
         ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
    end;
    MontarGrid(true);
    ShowMessage(MSG_OPERACAO);
  finally
    FreeAndNil(Azip);
  end;

end;

procedure TForm1.btnRefreshGridClick(Sender: TObject);
begin
  MontarGrid(true);
end;

procedure TForm1.btnUsarDadosTesteClick(Sender: TObject);

   procedure ApagarDadosAnteriorRetornandoODadosAtual;
   begin
      FInterfaceArquivo.
      RenomearArquivo(DADOSATUAL, DADOSANTERIOR, true).
      CopiaArquivo(DADOSTESTE, DADOSATUAL);
      MontarGrid(true);
      ShowMessage(MSG_OPERACAO);
   end;

begin
  try
    if FInterfaceArquivo.GetTipoArquivo.getCDS.Locate('NOMEARQUIVO', 'DADOSANTERIOR.FDB', []) then begin
      if MessageDlg('Ao trazer o DADOSTESTE, o DADOSANTERIOR será excluído, deseja prosseguir ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ApagarDadosAnteriorRetornandoODadosAtual;
    end else
      ApagarDadosAnteriorRetornandoODadosAtual;
  except
    on e: Exception do
       ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
   end;
end;

procedure TForm1.btnVoltarDadosAnteriorClick(Sender: TObject);
begin
   try
      if not FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty then begin
         if FInterfaceArquivo.GetTipoArquivo.getCDS.Locate('NOMEARQUIVO', 'DADOSANTERIOR.FDB', [])  then begin
            FInterfaceArquivo.
             RenomearArquivo(DADOSATUAL, DADOSRENOMEADO, true).
               RenomearArquivo(DADOSANTERIOR, DADOSATUAL, false).
                 RenomearArquivo(DADOSRENOMEADO, DADOSANTERIOR, false);
            MontarGrid(true);
            ShowMessage(MSG_OPERACAO);
         end else
         ShowMessage('DADOSANTERIOR não localizado.');
      end else
        ShowMessage('DADOSANTERIOR não localizado.');
   except
      on e: Exception do
         ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
   end;
end;

procedure TForm1.btnZiparClick(Sender: TObject);
var
  Azip: TZipFile;
begin
   Azip := TZipFile.Create;
   try
      Azip.OnProgress := EventoOnProgress;
      try
        FInterfaceArquivo.ZiparArquivo(Azip);
      except
         on e: Exception do begin
            ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
            Exit;
         end;
      end;
      MontarGrid(true);
      ShowMessage(MSG_OPERACAO);
      Label2.Visible := false;
      Image1.Visible := true;
   finally
      FreeAndNil(Azip);
   end;
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
var
  ANomeDisponivel: String;
  AUnderlie: String;
  ADadosSelecionado: String;
begin
   try
     AUnderlie := EmptyStr;
     ANomeDisponivel := EmptyStr;
     ADadosSelecionado := FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString;
     if ADadosSelecionado <> 'DADOS.FDB' then begin
        repeat
           AUnderlie := AUnderlie + '_';
           ANomeDisponivel := AUnderlie + 'DADOS.FDB';
        until not FInterfaceArquivo.GetTipoArquivo.getCDS.Locate('NOMEARQUIVO', ANomeDisponivel, []);
        FInterfaceArquivo.RenomearArquivo(DADOSATUAL, DIRETORIO+'\'+ANomeDisponivel, false).
        RenomearArquivo(DIRETORIO+'\'+ADadosSelecionado, DADOSATUAL, false);
        MontarGrid(true);
        ShowMessage(MSG_OPERACAO);
     end;
   except
      on e: Exception do
         ShowMessage(MGS_EXCECAO+sLineBreak+e.ToString);
   end;
end;

procedure TForm1.EventoOnProgress(Sender: TObject; FileName: string;  Header: TZipHeader; Position: Int64);
begin
  Image1.Visible := false;
  Label2.Visible := true;
  Application.ProcessMessages;
  // Exibe a porcentagem de compactação do arquivo
  Label2.Caption := FormatFloat('#.## %', Position / Header.UncompressedSize * 100);
end;

procedure TForm1.GridOutros(const _ANecessarioMapearDiretorio: boolean);
var
   AListaDeDados: TDictionary<String, TInfoArquivo>;
   AInfo: TInfoArquivo;
begin
  if _ANecessarioMapearDiretorio then begin
    FInterfaceArquivo.GetTipoArquivo.getCDS.EmptyDataSet;
    AlistaDeDados := FInterfaceArquivo.ProcurarArquivos;
    try
      for AInfo in AListaDeDados.Values do begin
        FInterfaceArquivo.GetTipoArquivo.getCDS.Insert;
        FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('CAMINHOCOMPLETOARQUIVO').AsString := AInfo.CaminhoArquivo;
        FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('BYTES').AsInteger := FInterfaceArquivo.CapturarBytesArquivo(AInfo.CaminhoArquivo).TamanhoArquivoBytes;
        FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString := AInfo.NomeArquivo;
        FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('TAMANHO').AsString := AInfo.Tamanho;
        FInterfaceArquivo.GetTipoArquivo.getCDS.Post;
      end;
    finally
      FreeAndNil(AListaDeDados);
    end;
  end;
  with FInterfaceArquivo.GetTipoArquivo.getCDS.Aggregates.Add do begin
    AggregateName := 'bytesTotal';
    name := 'bytesTotal';
    Expression := 'SUM(BYTES)';
    Active := true;
  end;
  if not FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty then
    edtTotal.Text := FInterfaceArquivo.ApresentarFormatado(FInterfaceArquivo.GetTipoArquivo.getCDS.Aggregates.Items[0].Value)
  else
    edtTotal.Text := '0';
end;

procedure TForm1.GridFDB(const _ANecessarioMapearDiretorio: boolean; const _AFocus: boolean = true);
var
   AInfo: TInfoArquivo;
   AListaArquivos: TDictionary<String, TInfoArquivo>;
   AFiredacDAO: iDaoFiredac;
   AClsRazaoSocial: TClientDataSet;
   ANomeArquivoAnt: String;
begin
  if _ANecessarioMapearDiretorio then begin
    ANomeArquivoAnt := EmptyStr;
    FInterfaceArquivo.GetTipoArquivo.getCDS.EmptyDataSet;
    AListaArquivos := FInterfaceArquivo.ProcurarArquivos;
    try
      for AInfo in AListaArquivos.Values do begin
        AFiredacDAO := FFiredacDAO.Conectar(AInfo.CaminhoArquivo, FConfigConexao);
        if FFiredacDAO.Conexao.Connected then begin
          AClsRazaoSocial := FFiredac.SelectRazaoSocial(AFiredacDAO);
          try
            if Assigned(AClsRazaoSocial) then begin
              while not AClsRazaoSocial.Eof do begin
                FInterfaceArquivo.GetTipoArquivo.getCDS.insert;
                if not (ANomeArquivoAnt = AInfo.NomeArquivo) then
                  FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('BYTES').AsInteger :=  FInterfaceArquivo.CapturarBytesArquivo(AInfo.CaminhoArquivo).TamanhoArquivoBytes
                else
                  FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('BYTES').AsInteger := 0;
                ANomeArquivoAnt := AInfo.NomeArquivo;
                FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('CHAVEEMP').AsInteger := AClsRazaoSocial.FieldByName('CHAVE').AsInteger;
                FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('RAZAOSOCIAL').AsString := AClsRazaoSocial.FieldByName('RAZAOSOCIAL').AsString;
                FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('NOMEARQUIVO').AsString :=  AInfo.NomeArquivo;
                FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('TAMANHO').AsString := AInfo.Tamanho;
                FInterfaceArquivo.GetTipoArquivo.getCDS.FieldByName('CAMINHOCOMPLETOARQUIVO').AsString := AInfo.CaminhoArquivo;
                FInterfaceArquivo.GetTipoArquivo.getCDS.Post;
                AClsRazaoSocial.Next;
              end;
            end;
          finally
            AFiredacDAO.Conexao.Close;
            if Assigned(AClsRazaoSocial) then
              FreeAndNil(AClsRazaoSocial);
          end;
          with FInterfaceArquivo.GetTipoArquivo.getCDS.Aggregates.Add do begin
            AggregateName := 'bytesTotal';
            name := 'bytesTotal';
            Expression := 'SUM(BYTES)';
            Active := true;
          end;
        end;
      end;
      // linka no grid
      DBGrid1.DataSource := FDataSource;
      FDataSource.DataSet := FInterfaceArquivo.GetTipoArquivo.getCDS;
      FInterfaceArquivo.GetTipoArquivo.getCDS.Locate('NOMEARQUIVO','DADOS.FDB', []);
      if _AFocus then
        DBGrid1.SetFocus;
    finally
      FreeAndNil(AListaArquivos);
    end;
  end;
  if not FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty then
    edtTotal.Text := FInterfaceArquivo.ApresentarFormatado(FInterfaceArquivo.GetTipoArquivo.getCDS.Aggregates.Items[0].Value)
  else
    edtTotal.Text := '0';
end;


procedure TForm1.MontarGrid(const _ANecessarioMapearDiretorio: Boolean;  _AFocus: Boolean = true);
begin
   case TTipoArquivo(rgArquivos.ItemIndex) of
      tpFDB: begin
        FInterfaceArquivo.SetTipoArquivo(FTipoArquivoFDB);
        MontarColunasGridArquivos;
        GridFDB(_ANecessarioMapearDiretorio, _AFocus);
      end;
      tpOutros: begin
        FInterfaceArquivo.SetTipoArquivo(FTipoArquivoOutros);
        MontarColunasOutros;
        GridOutros((_ANecessarioMapearDiretorio) or (FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty));
      end;
   end;
   btnUsarDadosTeste.Enabled := TTipoArquivo(rgArquivos.ItemIndex) = tpFDB;
   btnVoltarDadosAnterior.Enabled := TTipoArquivo(rgArquivos.ItemIndex) = tpFDB;
   btnDescompacatar.Enabled := (TTipoArquivo(rgArquivos.ItemIndex) = tpOutros) and (not FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty);
   btnZipar.Enabled := not FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty;
   btnExcluir.Enabled := not FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty;
   btnGuardarDados.Enabled :=  not FInterfaceArquivo.GetTipoArquivo.getCDS.IsEmpty;
   DBGrid1.DataSource.DataSet := FInterfaceArquivo.GetTipoArquivo.getCDS;
end;

procedure TForm1.rgArquivosClick(Sender: TObject);
begin
   MontarGrid(False);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   Timer1.Enabled := False;
   if FConfigConexao.getUsuario.IsEmpty then
    btnConfigurarConexao.Click;
end;

procedure TForm1.MontarColunasOutros;
begin
   DBGrid1.Columns.Clear;

   DBGrid1.Columns.Add;
   DBGrid1.Columns[0].FieldName := 'NOMEARQUIVO';
   DBGrid1.Columns[0].Title.Caption := 'NOME DO ARQUIVO';
   DBGrid1.Columns[0].Width := 350;

   DBGrid1.Columns.Add;
   DBGrid1.Columns[1].FieldName := 'TAMANHO';
   DBGrid1.Columns[1].Title.Caption := 'TAMANHO';
   DBGrid1.Columns[1].Width := 198;
end;

procedure TForm1.MontarColunasGridArquivos;
begin
   DBGrid1.Columns.Clear;

   DBGrid1.Columns.Add;
   DBGrid1.Columns[0].FieldName := 'CHAVEEMP';
   DBGrid1.Columns[0].Title.Caption := 'CHAVE EMP.';
   DBGrid1.Columns[0].Width := 70;
   DBGrid1.Columns[0].Alignment := taLeftJustify;

   DBGrid1.Columns.Add;
   DBGrid1.Columns[1].FieldName := 'RAZAOSOCIAL';
   DBGrid1.Columns[1].Title.Caption := 'RAZÃO SOCIAL';
   DBGrid1.Columns[1].Width := 188;

   DBGrid1.Columns.Add;
   DBGrid1.Columns[2].FieldName := 'NOMEARQUIVO';
   DBGrid1.Columns[2].Title.Caption := 'NOME DADOS';
   DBGrid1.Columns[2].Width := 227;

   DBGrid1.Columns.Add;
   DBGrid1.Columns[3].FieldName := 'TAMANHO';
   DBGrid1.Columns[3].Title.Caption := 'TAMANHO';
   DBGrid1.Columns[3].Width := 198;
end;

procedure TForm1.ControlarDisponiblidadeComponentes;
var
  i: Integer;
begin
  for I := 0 to pred(Form1.ComponentCount) do begin
    if (Form1.Components[i] is TButton) and (Form1.Components[i].Tag <> 1) then    
      TButton(Form1.Components[i]).Enabled := not (FConfigConexao.getUsuario + FConfigConexao.getSenha).Trim.IsEmpty;
    if Form1.Components[i] is TBitBtn then
      TBitBtn(Form1.Components[i]).Enabled := not (FConfigConexao.getUsuario + FConfigConexao.getSenha).Trim.IsEmpty;;
    if Form1.Components[i] is TRadioGroup then
      TRadioGroup(Form1.Components[i]).Enabled := not (FConfigConexao.getUsuario + FConfigConexao.getSenha).Trim.IsEmpty;;
  end;
    
end;

procedure TForm1.ConfigInicial;
begin
  FFiredac := TControllerFiredac.New.Firedac;
  FFiredacDAO := TControllerFiredacDAO.New.FiredacDAO;  FTipoArquivoFDB := TControllerArquivos.New.ArquivoFDB.CreateCDS;
  FTipoArquivoOutros := TControllerArquivos.New.ArquivoOutros.CreateCDS;
  FInterfaceArquivo := TControllerArquivos.New.AcoesArquivos;
  FDataSource := TDataSource.Create(Self);
  MontarGrid(True, false);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  FConfigConexao := TControllerFiredacDao.New.ConfigFirebird.CreateIni;
  if (FConfigConexao.getUsuario + FConfigConexao.getSenha).Trim.IsEmpty then begin
    ControlarDisponiblidadeComponentes;
    btnConfigurarConexao.Font.Style := [fsBold];
    btnConfigurarConexao.Font.Color := clRed;
    btnConfigurarConexao.Font.Size := 7;
    exit;
  end;
  ConfigInicial;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DBGrid1.SetFocus;
  (Image1.Picture.Graphic as TGIFImage).Animate := True;
   Form1.DoubleBuffered := True;
end;

end.
