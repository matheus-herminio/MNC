unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    RadioButtonQualquer: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonQualquerClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public
    { public declarations }
    function VerificaDados(k: Byte): Boolean;
    function MediaAritmetica(a,b: Extended): Extended;
    function MediaPonderada(a,f_a,b,f_b: Extended): Extended;
    function MediaPonderadaModificadaA(a,f_a,b,f_b: Extended): Extended;
    function MediaPonderadaModificadaB(a,f_a,b,f_b: Extended): Extended;
    procedure DesenhaGrafico(k: Byte);
    procedure DesenhaRaiz;
    function DerivadaPrimeira(f: string; x: Extended; var y: Extended): Word;
    procedure UniformeSepara;
    procedure Uniforme;
    procedure Bissecao;
    procedure Cordas;
    procedure CordasModificado;
    procedure Newton;
    procedure NewtonModificado;
  end;

var
  Form1: TForm1;

implementation
uses
 Unit2, Windows, LCLIntf;
{$R *.lfm}
var
   Metodo: Byte;
   f: string;
   a, b, Delta, Epsilon: Extended;
   //p, q, f_p, f_q: Extended; // pode ser que você use em seu programa
   Raiz, f_Raiz: Extended;
   //Sinal1, Sinal2, Iteracao: Integer; // pode ser que você use em seu programa
   //EncontrouRaiz: Boolean; // pode ser que você use em seu programa
   //ResultadoFxR1: Word; // pode ser que você use em seu programa
   VerIteracoes, VerGrafico, Interrompe: Boolean;
function FxR1(f: String; x: Extended; var y: Extended): Word; stdcall; external 'Interpretador.dll';

{ TForm1 }

function TForm1.VerificaDados(k: Byte): Boolean;
begin
// Parte superior da fôrma (k = 1 => Gráfico e k = 2 => Separação)
   if (k = 1) then // Verifica entrada de dados para o gráfico (f, a, b)
   begin
     Result := False;
     f := Trim(Edit1.Text);
     if (f = '') then
     begin
       ShowMessage('Informe uma função.');
       Edit1.SetFocus;
       Exit;
     end;
     try
       a := StrToFloat(Edit2.Text);
     except
        ShowMessage('Valor de a incorreto');
        Edit2.SetFocus;
        Exit;
     end;
     try
        b := StrToFloat(Edit3.Text);
     except
        ShowMessage('Valor de b incorreto');
        Edit3.SetFocus;
        Exit;
     end;
     if b <= a then
     begin
        ShowMessage('Valor de b deve ser maior que valor de a.');
        Edit3.SetFocus;
        Exit;
     end;
     Result := True;
     Exit;
   end;

   if k = 2 then // Verificar f, a, b anteriores e Delta
   begin
     Result := False;
     if not VerificaDados(1) then
        Exit;
     try
        Delta := StrToFloat(Edit4.Text);
     except
        ShowMessage('Valor de Delta incorreto');
        Edit4.SetFocus;
        Exit;
     end;
     if ((Delta-(b-a)/1000) < 0) or ((Delta-(b-a)/20) > 1E-10) then
     begin
       ShowMessage('O menor valor admissível para Delta é (b-a)/1000 (1000 avaliações da função).'+#10#10+
                   'O maior valor admissível para Delta é (b-a)/20 (20 avaliações da função).');
       Edit4.SetFocus;
       Exit;
     end;
     Result := True;
   end;
   if (k = 3) then
   begin
     Result := False;
     f := Trim(Edit5.Text);
     if (f = '') then
     begin
       ShowMessage('Informe uma função.');
       Edit5.SetFocus;
       Exit;
     end;
     try
       a := StrToFloat(Edit6.Text);
     except
       ShowMessage('Valor de a incorreto');
       Edit6.SetFocus;
       Exit;
     end;
     try
       b := StrToFloat(Edit7.Text);
     except
       ShowMessage('Valor de b incorreto');
       Edit7.SetFocus;
       Exit;
     end;
     if b <= a then
     begin
       ShowMessage('Valor de b deve ser maior que valor de a.');
       Edit7.SetFocus;
       Exit;
     end;
     Result := True;
     Exit;
   end;
   if k = 4 then // Verificar f, a, b anteriores e Epsilon
   begin
     Result := False;
     if not VerificaDados(3) then
       Exit;
     try
       Epsilon := StrToFloat(Edit8.Text);
     except
       ShowMessage('Valor de Epsilon incorreto');
       Edit8.SetFocus;
       Exit;
     end;
     if (Epsilon-(b-a)/20) > 1E-10 then // if Epsilon > (b-a)/20 then
     begin
       ShowMessage('O máximo admissível para Epsilon é (b-a)/20.');
       Edit4.SetFocus;
       Exit;
     end;
     Result := True;
   end;
end;

function TForm1.MediaAritmetica(a,b: Extended): Extended;
begin
   Result:= (a+b)/2;
end;

function TForm1.MediaPonderada(a,f_a,b,f_b: Extended): Extended;
begin
   Result := (a*f_b - b*f_a)/(f_b - f_a);
end;
function TForm1.MediaPonderadaModificadaA(a,f_a,b,f_b: Extended): Extended;
begin
   Result := (a*f_b - (b*f_a)/2)/(f_b - (f_a)/2);
end;
function TForm1.MediaPonderadaModificadaB(a,f_a,b,f_b: Extended): Extended;
begin
   Result := ((a*f_b)/2 - b*f_a)/((f_b)/2 - f_a);
end;

procedure TForm1.DesenhaGrafico(k: Byte);
var
i: Integer;
x, y: Extended;
begin
     if k = 1 then
        if not VerificaDados(1) then
           Exit;
     if k = 2 then
        if not VerificaDados(3) then
           Exit;
     with Form2 do
     begin
        Chart1LineSeries1.Clear;
        Chart1.Title.Text[0] := 'Gráfico da função ' + f;
        Delta := (b-a)/1000;
        for i := 0 to 1000 do
        begin
          try
            x := a+i*Delta;
            FxR1(f, x, y);
            Chart1LineSeries1.AddXY(x, y, '');
          except
          end;
        end;
     end;
end;

procedure TForm1.DesenhaRaiz;
begin
  with Form2 do
  begin
    Chart1LineSeries2.Clear;
    Chart1LineSeries2.AddXY(Raiz, f_Raiz, '');
  end;
end;

function TForm1.DerivadaPrimeira(f: string; x: Extended; var y: Extended): Word;
var
   i: Integer;
   h, p0, p1, y1, y2: Extended;
begin
   h := 1024 * Epsilon;
   FxR1(f, x+h, y1);
   FxR1(f, x-h, y2);
   p1 := (( y1 - y2 ) / (2*h));
   for i := 1 to 10 do
      begin;
         p0 := p1;
         h := h/2;
         FxR1(f, x+h, y1);
         FxR1(f, x-h, y2);
         p1 := (y1 - y2)/(2*h);
         if(abs(p1 - p0) < Epsilon) then
            break;
      end;
   y := p1;
   exit(0);
end;

procedure TForm1.UniformeSepara;
var
   i, j: Integer;
   p, q, f_p, f_q: Extended;
   Erro: Word;
begin
// Método da Busca Uniforme para separar raízes
   Interrompe := False; // Utilizado para controlar o Botão do pânico
   with StringGrid1 do
   begin
     ColCount := 9;
     for i := 1 to ColCount-1 do
     begin
       Cells[i,0] := '';
       Cells[i,1] := '';
       Cells[i,2] := '';
     end;
   end;
   i := 0;
   j := 1;
   p := a;
   FxR1(f, p, f_p);
   q := p+Delta;
   FxR1(f, q, f_q);
   while (p <= b) do
   begin
     Application.ProcessMessages;
     if Interrompe then
     begin
       ShowMessage('Usuário cancelou.');
       Exit;
     end;
     if f_p * f_q <= 0 then
     begin
       Inc(i);
       with StringGrid1 do
       begin
         if ColCount < i+1 then
            ColCount := i+1;
            Cells[i,0] := IntToStr(i);
            Cells[i,1] := FloatToStr(p);
            Cells[i,2] := FloatToStr(q);
       end;
       if f_q = 0 then
       begin
         Inc(j);
         q := a+j*Delta;
         FxR1(f, q, f_q);
       end
     end;
     p := q;
     f_p := f_q;
     Inc(j);
     q := a+j*Delta; // q := p+Delta;
     try
       Erro := FxR1(f, q, f_q);
     except
       ShowMessage(IntToStr(Erro)+' - '+FloatToStr(q)+' - '+FloatToStr(f_q));
     end;
   end;
   if i = 0 then
   begin
     ShowMessage('Não foram encontradas regiões com indício de conter raízes.');
     Exit;
   end;
end;

procedure TForm1.Uniforme;
var
   k: Integer;
   p, q, f_p, f_q: Extended;
   Erro: Word;
begin
// Método da Busca Uniforme para calcular raízes
   Interrompe := False; // Utilizado para controlar o Botão do pânico
   Memo1.Clear;
   Memo1.Lines.Add('k'+#09+'p'+#09+'f(p)'+#09#09#09+'q'+#09+'f(q)');
   k := 1;
   p := a;
   FxR1(f, p, f_p);
   q := p+Epsilon;
   FxR1(f, q, f_q);
   Memo1.Lines.Add(IntToStr(k)+#09+FloatToStr(p)+#09+FloatToStr(f_p)+#09+
   FloatToStr(q)+#09+FloatToStr(f_q));
   while (p <= b) and (f_p * f_q > 0) do
   begin
     Application.ProcessMessages;
     if Interrompe then
     begin
       ShowMessage('Usuário cancelou.');
       Exit;
     end;
     Inc(k);
     p := q;
     f_p := f_q;
     q := p+Epsilon;
     FxR1(f, q, f_q);
     Label9.Caption := IntToStr(k); // Como comentário, não exibe a cada iteração
     Memo1.Lines.Add(IntToStr(k)+#09+FloatToStr(p)+#09+FloatToStr(f_p)+#09+
     FloatToStr(q)+#09+FloatToStr(f_q));
   end;
   Raiz := (p+q)/2;
   FxR1(f, Raiz, f_Raiz);
   Memo1.Lines.Add('Resultado: x = '+FloatToStr(Raiz)+'; f(x) = '+FloatToStr(f_Raiz));
   Edit9.Text := FloatToStr(Raiz);
   Edit10.Text := FloatToStr(f_Raiz);
   //Label9.Caption := IntToStr(k); // Sem comentário, exibe ao terminar
   if VerIteracoes then
      ClientHeight := 480;
   if VerGrafico then
   begin
   // Calcula e apresenta o gráfico da função e a raiz
     DesenhaGrafico(2);
     DesenhaRaiz;
     Form2.Show;
   end;
end;

procedure TForm1.Bissecao;
var
   totalIteracoes: Integer;
   p, q, fp, fq, fa: Extended;

begin
   Interrompe := False;
   Memo1.Clear;
   Memo1.Lines.Add('K'+#09+'P'+#09+'F(P)'+#09#09#09+'A'+#09+'B');

   p := (a+b)/2;
   FxR1(f, p, fp);
   totalIteracoes := 1;
   Label9.Caption := IntToStr(totalIteracoes);
   Memo1.Lines.Add(IntToStr(totalIteracoes)+#09+FloatToStr(p)+#09+FloatToStr(fp)+#09#09#09+FloatToStr(a)+#09+FloatToStr(b));

   while (abs(a-b) > Epsilon) and (abs(fp) > Epsilon) do
      begin
         FxR1(f, a, fa);
         if (fa*fp > 0) then
            a := p
         else
            b := p;
         p := (a+b)/2;
         FxR1(f, p, fp);

         totalIteracoes := totalIteracoes + 1;
         Label9.Caption := IntToStr(totalIteracoes);
         Memo1.Lines.Add(IntToStr(totalIteracoes)+#09+FloatToStr(p)+#09+FloatToStr(fp)+#09#09#09+FloatToStr(a)+#09+FloatToStr(b));
      end;

   Raiz := p;
   FxR1(f, Raiz, f_Raiz);

   Memo1.Lines.Add('Resultado: x = '+FloatToStr(Raiz)+'; f(x) = '+FloatToStr(f_Raiz));
   Edit9.Text := FloatToStr(Raiz);
   Edit10.Text := FloatToStr(f_Raiz);

   if VerIteracoes then
      ClientHeight := 480;

   if VerGrafico then
      begin
         DesenhaGrafico(2);
         DesenhaRaiz;
         Form2.Show;
      end;
end;

procedure TForm1.Cordas;
var
   num_it: Integer;
   p, q, f_p, f_q,f_a,f_b: Extended;
   Erro: Word;
begin
   num_it := 1;
   FxR1(f, a, f_a);
   FxR1(f, b, f_b);
   p := MediaPonderada(a,f_a,b,f_b);
   FxR1(f, p, f_p);
   Memo1.Clear;
   Memo1.Lines.Add('num_it'+#09+'p'+#09#09+'f(p)'+#09#09#09+'a'+#09#09+'b');
   Memo1.Lines.Add(IntToStr(num_it)+#09+FloatToStr(p)+#09#09+FloatToStr(f_p)+#09#09#09+
   FloatToStr(a)+#09#09+FloatToStr(b));
   if (f_a*f_p) < 0 then
   begin
     b := p;
   end;
   if (f_a*f_p) > 0 then
   begin
     a := p;
   end;
   if f_p = 0 then
   begin
     Raiz := p;
   end;
   f_q := 999999;
   while (f_p <> 0) and (abs(f_p - f_q) > Epsilon) and (abs(a-b) > Epsilon) do
   begin
     Application.ProcessMessages;
     if Interrompe then
     begin
       ShowMessage('Usuário cancelou.');
       Exit;
     end;
     Inc(num_it);
     f_q := f_p;
     FxR1(f, a, f_a);
     FxR1(f, b, f_b);
     p := MediaPonderada(a,f_a,b,f_b);
     FxR1(f, p, f_p);
     Label9.Caption := IntToStr(num_it);
     Memo1.Lines.Add(IntToStr(num_it)+#09+FloatToStr(p)+#09#09+FloatToStr(f_p)+#09#09#09+
     FloatToStr(a)+#09#09+FloatToStr(b));
     if f_a * f_p < 0 then
     begin
          b := p;
     end;
     if (f_a * f_p) > 0  then
     begin
          a := p;
     end;
   end;
   Raiz := p;
   FxR1(f, Raiz, f_Raiz);
   Memo1.Lines.Add('Resultado: x = '+FloatToStr(Raiz)+'; f(x) = '+FloatToStr(f_Raiz));
   Edit9.Text := FloatToStr(Raiz);
   Edit10.Text := FloatToStr(f_Raiz);
   //Label9.Caption := IntToStr(k); // Sem comentário, exibe ao terminar
   if VerIteracoes then
      ClientHeight := 480;
   if VerGrafico then
   begin
   // Calcula e apresenta o gráfico da função e a raiz
     DesenhaGrafico(2);
     DesenhaRaiz;
     Form2.Show;
   end;

end;

procedure TForm1.CordasModificado;
var
   num_it, qtd_a, qtd_b: Integer;
   p, q, f_p, f_q,f_a,f_b: Extended;
   Erro: Word;
begin
   num_it := 1;
   qtd_b := 0;
   qtd_a := 0;
   FxR1(f, a, f_a);
   FxR1(f, b, f_b);
   p := MediaPonderada(a,f_a,b,f_b);
   FxR1(f, p, f_p);
   Memo1.Clear;
   Memo1.Lines.Add('num_it'+#09+'p'+#09#09+'f(p)'+#09#09#09+'a'+#09#09+'b');
   Memo1.Lines.Add(IntToStr(num_it)+#09+FloatToStr(p)+#09#09+FloatToStr(f_p)+#09#09#09+
   FloatToStr(a)+#09#09+FloatToStr(b));
   if (f_p * f_a) < 0 then
   begin
     b := p;
     Inc(qtd_b);
   end;
   if (f_p * f_a) > 0 then
   begin
     a := p;
     Inc(qtd_a);
   end;
   if f_p = 0 then
   begin
     Raiz := p;
   end;
   f_q := 999999;
   while (f_p <> 0) and (abs(f_p - f_q) > Epsilon) and (abs(a-b) > Epsilon) do
   begin
     Application.ProcessMessages;
     if Interrompe then
     begin
       ShowMessage('Usuário cancelou.');
       Exit;
     end;
     Inc(num_it);
     f_q := f_p;
     FxR1(f, a, f_a);
     FxR1(f, b, f_b);
     if (qtd_a < 3) and (qtd_b < 3) then
     begin
       p := MediaPonderada(a,f_a,b,f_b);
     end;
     if (qtd_a = 3) then
     begin
       p := MediaPonderadaModificadaA(a,f_a,b,f_b);
     end;
     if (qtd_b = 3) then
     begin
       p := MediaPonderadaModificadaB(a,f_a,b,f_b);
     end;

     FxR1(f, p, f_p);

     Label9.Caption := IntToStr(num_it);
     Memo1.Lines.Add(IntToStr(num_it)+#09+FloatToStr(p)+#09#09+FloatToStr(f_p)+#09#09#09+
     FloatToStr(a)+#09#09+FloatToStr(b));

     if f_p * f_a < 0 then
     begin
          b := p;
          Inc(qtd_b);
          qtd_a := 0;
     end;
     if f_p * f_a > 0  then
     begin
          a := p;
          Inc(qtd_a);
          qtd_b := 0;
     end;
   end;
   Raiz := p;
   FxR1(f, Raiz, f_Raiz);
   Memo1.Lines.Add('Resultado: x = '+FloatToStr(Raiz)+'; f(x) = '+FloatToStr(f_Raiz));
   Edit9.Text := FloatToStr(Raiz);
   Edit10.Text := FloatToStr(f_Raiz);
   //Label9.Caption := IntToStr(k); // Sem comentário, exibe ao terminar
   if VerIteracoes then
      ClientHeight := 480;
   if VerGrafico then
   begin
   // Calcula e apresenta o gráfico da função e a raiz
     DesenhaGrafico(2);
     DesenhaRaiz;
     Form2.Show;
   end;

end;

procedure TForm1.Newton;
var
   totalIteracoes, maxIteracoes: Integer;
   p0, p1, f_p0, f1_p0: Extended;

begin
   Interrompe := False;
   Memo1.Clear;
   Memo1.Lines.Add('K'+#09#09+'P0'+#09#09+'P1');

   maxIteracoes := 100;
   totalIteracoes := 0;
   p1 := a;

   repeat
      totalIteracoes := totalIteracoes + 1;
      p0 := p1;

      FxR1(f, p0, f_p0);
      DerivadaPrimeira(f, p0, f1_p0);

      while (f1_p0 = 0) do
         begin
            p0 := p0 + Epsilon;
            DerivadaPrimeira(f, p0, f1_p0);
         end;

      p1 := p0 - (f_p0/f1_p0);

      Label9.Caption := IntToStr(totalIteracoes);
      Memo1.Lines.Add(IntToStr(totalIteracoes)+#09#09+FloatToStr(p0)+#09#09+FloatToStr(p1));

   until (abs(p1 - p0) < Epsilon) or (totalIteracoes > maxIteracoes);

   Raiz := p1;
   FxR1(f, Raiz, f_Raiz);

   Memo1.Lines.Add('Resultado: x = '+FloatToStr(Raiz)+'; f(x) = '+FloatToStr(f_Raiz));
   Edit9.Text := FloatToStr(Raiz);
   Edit10.Text := FloatToStr(f_Raiz);

   if VerIteracoes then
      ClientHeight := 480;

   if VerGrafico then
      begin
         DesenhaGrafico(2);
         DesenhaRaiz;
         Form2.Show;
      end;
end;

procedure TForm1.NewtonModificado;
var
   totalIteracoes, maxIteracoes, restoDivisao: Integer;
   p0, p1, f_p0, f1_p0: Extended;

begin
   Interrompe := False;
   Memo1.Clear;
   Memo1.Lines.Add('K'+#09#09+'P0'+#09#09+'P1');

   maxIteracoes := 100;
   totalIteracoes := 0;
   p1 := a;

   repeat
      restoDivisao := (totalIteracoes)MOD(5);
      p0 := p1;

      FxR1(f, p0, f_p0);

      if (restoDivisao = 0) then
         begin
            DerivadaPrimeira(f, p0, f1_p0);

            while (f1_p0 = 0)do
               begin
                  p0 := p0 + Epsilon;
                  DerivadaPrimeira(f, p0, f1_p0);
               end;
         end;

      p1 := p0 - (f_p0/f1_p0);
      totalIteracoes := totalIteracoes + 1;

      Label9.Caption := IntToStr(totalIteracoes);
      Memo1.Lines.Add(IntToStr(totalIteracoes)+#09#09+FloatToStr(p0)+#09#09+FloatToStr(p1));

   until (abs(p1 - p0) < Epsilon) or (totalIteracoes > maxIteracoes);

   Raiz := p1;
   FxR1(f, Raiz, f_Raiz);

   Memo1.Lines.Add('Resultado: x = '+FloatToStr(Raiz)+'; f(x) = '+FloatToStr(f_Raiz));
   Edit9.Text := FloatToStr(Raiz);
   Edit10.Text := FloatToStr(f_Raiz);

   if VerIteracoes then
      ClientHeight := 480;

   if VerGrafico then
      begin
         DesenhaGrafico(2);
         DesenhaRaiz;
         Form2.Show;
      end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Atribuir tamanhos e posições { uses Windows para GetSystemMetrics }
  ClientHeight := 324;
  StringGrid1.Height := 62+GetSystemMetrics(SM_CYHSCROLL)+GetSystemMetrics(SM_CYFRAME);
  StringGrid1.Cells[0,0] := 'i';
  StringGrid1.Cells[0,1] := 'a[i]';
  StringGrid1.Cells[0,2] := 'b[i]';
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  // Apresentar ou não as iterações
  VerIteracoes := not VerIteracoes;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  // Apresentar ou não o gráfico
  VerGrafico := not VerGrafico;
end;

procedure TForm1.RadioButtonQualquerClick(Sender: TObject);
begin
  Metodo := 0;
  if RadioButtonQualquer.Checked then Metodo := 1;
  if RadioButton2.Checked then Metodo := 2;
  if RadioButton3.Checked then Metodo := 3;
  if RadioButton4.Checked then Metodo := 4;
  if RadioButton5.Checked then Metodo := 5;
  if RadioButton6.Checked then Metodo := 5;
  if RadioButton6.Checked then Metodo := 6;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  // Existem dados necessários para desenhar gráfico ?
  // Verifica entrada de dados (f, a, b)
  if not VerificaDados(1) then
     Exit;
  Form2.Chart1LineSeries2.Clear;
  DesenhaGrafico(1);
  Form2.Show;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  // Existem dados necessários para separar as raízes?
  // Verifica entrada de dados (f, a, b, Delta)
  if not VerificaDados(2) then
     Exit;
  UniformeSepara;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  // Botão do pânico
  Interrompe := True;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
   i: Integer;
begin
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  with StringGrid1 do
  begin
     ColCount := 9;
     for i := 1 to ColCount-1 do
     begin
       Cells[i,0] := '';
       Cells[i,1] := '';
       Cells[i,2] := '';
     end;
  end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  Edit5.Text := Edit1.Text;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  // Existem dados necessários para desenhar gráfico ?
  // Verifica entrada de dados (f, a, b)
  if not VerificaDados(3) then
     Exit;
  Form2.Chart1LineSeries2.Clear;
  DesenhaGrafico(2);
  Form2.Show;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
   // Calcular a raiz
   Interrompe := False; // Utilizado para controlar o Botão do pânico
   // Limpa resposta anterior
   Edit9.Text := '';
   Edit10.Text := '';
   // Verifica entrada de dados
   // Existem dados necessários para calcular a raiz ?
   if not VerificaDados(4) then
     Exit;
   ClientHeight := 324;

   if Metodo = 0 then
   begin
     ShowMessage('É necessário escolher um Método');
     Exit;
   end;
   if Metodo = 1 then //Busca Uniforme
   begin
     Uniforme;
     Exit;
   end;
   if Metodo = 2 then //Método da Bisseção
   begin
     Bissecao;
     Exit;
   end;
   if Metodo = 3 then //Método das Cordas
   begin
     Cordas;
     Exit;
   end;
  if Metodo = 4 then //Método das Cordas Modificado
  begin
    CordasModificado;
    Exit;
    end;
  if Metodo = 5 then //Método de Newton
  begin
    Newton;
    Exit;
  end;
  if Metodo = 6 then //Método de Newton Modificado
  begin
    NewtonModificado;
    Exit;
  end;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  // Botão do pânico
  Interrompe := True;
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
  Edit5.Text := '';
  Edit6.Text := '';
  Edit7.Text := '';
  Edit8.Text := '';
  Edit9.Text := '';
  Edit10.Text := '';
  Label9.Caption := '0';
  ClientHeight := 324;
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
  // Apresentar arquivo de ajuda { uses LCLIntf para OpenDocument }
  if not OpenDocument('Raízes.chm') then
     ShowMessage('Arquivo de Ajuda não foi encontrado.');
end;

procedure TForm1.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   CellCol, CellRow: Integer;
begin
  StringGrid1.MouseToCell(x,y,CellCol,CellRow);
  if CellCol = 0 then
     Exit;
  Edit6.Text := StringGrid1.Cells[CellCol, 1];
  Edit7.Text := StringGrid1.Cells[CellCol, 2];
end;


end.
