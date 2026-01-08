object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Demo 10 - Threads An'#244'nimas e Closures'
  ClientHeight = 350
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnDestroy = FormDestroy
  TextHeight = 15
  object btnProcessarLote: TButton
    Left = 24
    Top = 24
    Width = 200
    Height = 41
    Caption = #9654#65039' Processar Novo Lote'
    TabOrder = 0
    OnClick = btnProcessarLoteClick
  end
  object btnCancelar: TButton
    Left = 240
    Top = 24
    Width = 200
    Height = 41
    Caption = #9209#65039' Cancelar Processo'
    Enabled = False
    TabOrder = 1
    OnClick = btnCancelarClick
  end
  object MemoLog: TMemo
    Left = 24
    Top = 88
    Width = 450
    Height = 240
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
