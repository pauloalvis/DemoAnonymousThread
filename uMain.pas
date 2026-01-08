unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmPrincipal = class(TForm)
    btnProcessarLote: TButton;
    btnCancelar: TButton;
    MemoLog: TMemo;
    procedure btnProcessarLoteClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    // Guardamos a referência para poder cancelar se necessário
    FThreadProcessamento: TThread;
    procedure Log(Msg: string);
    procedure OnThreadTerminate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.Log(Msg: string);
begin
  MemoLog.Lines.Add(Format('[%s] %s', [FormatDateTime('hh:mm:ss', Now), Msg]));
end;

procedure TfrmPrincipal.btnProcessarLoteClick(Sender: TObject);
var
  // VARIÁVEL LOCAL: Normalmente, ela morreria no fim deste procedure.
   Progresso, NumeroDoLote: Integer;
begin
  // Simulamos a criação de um ID de lote único
  NumeroDoLote := Random(9000) + 1000;

  Log(Format('🚀 Iniciando preparação do Lote #%d...', [NumeroDoLote]));
  btnProcessarLote.Enabled := False;
  btnCancelar.Enabled := True;

  // CRIAÇÃO DA THREAD ANÔNIMA
  FThreadProcessamento := TThread.CreateAnonymousThread(procedure
  var
    I: Integer;
    FoiCancelado: Boolean;
  begin
    // --- INÍCIO DA THREAD ---
    // Perceba: Estamos usando "NumeroDoLote" aqui dentro.
    // O Delphi "capturou" essa variável para nós (Closure).

    Sleep(1000); // Simula carga inicial
    FoiCancelado := False;
    for I := 1 to 5 do
    begin
      // Verifica se o usuário pediu para cancelar
      if TThread.CheckTerminated then
      begin
        FoiCancelado := True;
        Break;
      end;

      // Atualiza uma variável local que será capturada pelo Anonymous Method
      Progresso := i;

      // Atualiza UI de forma segura
      TThread.Queue(nil,
        procedure
        begin
          // A closure funciona até dentro do Queue!
          frmPrincipal.Log(Format('Lote #%d: Processando nota %d/5...', [NumeroDoLote, Progresso]));
        end);

      Sleep(1000); // Simula trabalho pesado (emitir nota, calcular imposto)
    end;

    // Mensagem final
    TThread.Queue(nil, procedure
    begin
       if not FoiCancelado then
         frmPrincipal.Log(Format('✅ Lote #%d finalizado com sucesso!', [NumeroDoLote]))
       else
         frmPrincipal.Log(Format('⚠️ Lote #%d cancelado pelo usuário.', [NumeroDoLote]));
    end);
  end);

  FThreadProcessamento.OnTerminate := OnThreadTerminate;
  FThreadProcessamento.Start;
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
  if Assigned(FThreadProcessamento) then
  begin
    Log('Solicitando cancelamento...');
    FThreadProcessamento.Terminate;
  end;
end;

procedure TfrmPrincipal.OnThreadTerminate(Sender: TObject);
begin
  // Evento disparado na Main Thread quando a thread morre
  FThreadProcessamento := nil;
  btnProcessarLote.Enabled := True;
  btnCancelar.Enabled := False;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  // Segurança: Se fechar o form com a thread rodando, manda parar
  if Assigned(FThreadProcessamento) then
  begin
    FThreadProcessamento.OnTerminate := nil;
    FThreadProcessamento.Terminate;
  end;

end;

end.
