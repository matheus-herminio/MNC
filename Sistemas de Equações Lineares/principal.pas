unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  Buttons, Grids;

type

  { TForm1 }
// Feito por: Matheus Herminio da Silva
  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    FloatSpinEdit1: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    RadioButtonMetodosDiretos: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButtonMetodosIterativos: TRadioButton;
    RadioButton8: TRadioButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    StringGrid1: TStringGrid;
    procedure CheckBoxOpcoesClick(Sender: TObject);
    procedure FloatSpinEdit1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioButtonMetodosIterativosClick(Sender: TObject);
    procedure RadioButtonMetodosDiretosClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure SpinEdit1KeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit2Exit(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private

  public

  end;

var
  Form1: TForm1;

implementation
  {$R *.lfm}
  { TForm1 }
  uses
  Metodos, Solucao, Sobre, Windows, LCLIntf; // Windows e LCLIntf para usar GetSystemMetrics e OpenDocument
  // Variáveis utilizadas nesta Unit - As Globais para várias Units estão definidas na Unit Metodos
  var
  EFH, EFV, ESH, ESV: Byte; // Valores para Grade que são diferentes em diferentes versões do Windows
  DRH, DCW: Integer;
  GLX: Boolean;
  // GLX = Grade com Linha eXtra para entrada de x inicial em Método Iterativo
  n_atual: Integer;
  bCopia, xIniCopia: array[1..20] of string;

procedure TForm1.FormCreate(Sender: TObject);
  begin
    // Hint para vários componentes
    SpinEdit1.Hint := 'Entre com o número de variáveis ou'#13'cutuque para cima e para baixo para'#13+
    'definir o número de variáveis,'#13'que deve ser entre 3 e 20.';
    SpinEdit2.Hint := 'Entre o número máximo de iterações'#13'ou cutuque para cima e para baixo para'#13+
    'definir com o número máximo de iterações,'#13'que deve ser entre 10 e 100.';
    FloatSpinEdit1.Hint := 'Entre com a tolerância e ou'#13'cutuque para cima e para baixo para'#13+
    'definir a tolerância e, que deve'#13'ser entre 0,00001 e 0,001.';
    SpeedButton1.Hint := 'Cria grade para entrada de dados.';
    SpeedButton2.Hint := 'Limpa grade.';
    SpeedButton3.Hint := 'Resolve o sistema.';
    SpeedButton4.Hint := 'Apresenta o arquivio de ajuda.';
    SpeedButton5.Hint := 'Informações sobre direitos e autoria.';
    RadioButtonMetodosDiretos.Hint := 'Método de Gauss com escalonamento simples.';
    RadioButton2.Hint := 'Método de Gauss com pivotamento'#13'parcial: permutação entre linhas.';
    RadioButton3.Hint := 'Método de Gauss com pivotamento total:'#13'permutação entre linhas e entre colunas.';
    RadioButton4.Hint := 'Método de Gauss compacto.';
    RadioButton5.Hint := 'Método de Decomposição L.U.';
    RadioButton6.Hint := 'Método de Cholesky.';
    RadioButtonMetodosIterativos.Hint := 'Método de Jacobi-Richardson.';
    RadioButton8.Hint := 'Método de Gauss-Seidel.';
    CheckBox2.Hint := 'Com o Método escolhido,'#13'calcula o sistema.';
    CheckBox3.Hint := 'Com o Método escolhido,'#13'calcula o determinante.';
    CheckBox4.Hint := 'Com o Método escolhido,'#13'calcula a matriz inversa.';
    // Medidas para moldura e scrollbar da Grade (são diferentes para cada versão do Windows)
    EFH := GetSystemMetrics(SM_CYBORDER)+GetSystemMetrics(SM_CYFIXEDFRAME); // Espessura Frame Horizontal
    EFV := GetSystemMetrics(SM_CXBORDER)+GetSystemMetrics(SM_CYFIXEDFRAME); // Espessura Frame Vertical
    ESH := GetSystemMetrics(SM_CYHSCROLL); // Espessura Scroll Horizontal
    ESV := GetSystemMetrics(SM_CXVSCROLL); // Espessura Scroll Horizontal (não utilizado neste programa)
    // Medidas da altura da linha e comprimento da coluna de cada casela
    // Mesmo definindo os valores no projeto, eles mudam de acordo com a versão do Windows
    // Forçar altura da casela ser a mesma em diferentes versões do Windows
    StringGrid1.DefaultRowHeight := 20;
    DRH := StringGrid1.DefaultRowHeight;
    DCW := StringGrid1.DefaultColWidth;
    // Default Row Height
    // Default Col Width
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  n_atual := 0;                          // Variável para verificar se grade altera de tamanho
  n := SpinEdit1.Value;                  // Valor inicial de n
  ItMax := SpinEdit2.Value;              // Valor inicial de ItMax
  Epsilon := FloatSpinEdit1.Value;       // Valor inicial de Epsilon
  SpeedButton1.Click;                    // Dimensionar grade com tamanho (A|b)= 3x4
  RadioButtonMetodosDiretosClick(Self);  // Habilitar ou desabilitar Opções Adicionais
  CheckBoxOpcoesClick(Self);             // Valores para CalculaSistema, CalculaDeterminante e CalculaInversa
end;
procedure TForm1.SpinEdit1Exit(Sender: TObject);
begin
     n := SpinEdit1.Value;
     SpeedButton1.Click;
end;
procedure TForm1.SpinEdit1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SpeedButton1.Click;
  end;
end;
procedure TForm1.SpinEdit2Exit(Sender: TObject);
begin
  ItMax := SpinEdit2.Value;
end;
procedure TForm1.FloatSpinEdit1Exit(Sender: TObject);
begin
  Epsilon := FloatSpinEdit1.Value;
end;
procedure TForm1.RadioButtonMetodosDiretosClick(Sender: TObject);
begin
  // Evento onClick para RadioButton1 até RadioButton6
  // Só vou calcular a Inversa com Decomposição A = L.U
  CheckBox3.Enabled := True;                  // Determinante com todos os métodos
  CheckBox4.Enabled := RadioButton5.Checked;  // Inversa só com LU
  // Executa a rotina do SpeedButton1 para verificar se grade está correta
  SpeedButton1.Click;
  // Executa a rotina CheckBoxOpcoesClick para rever os valores das
  // variáveis CalculaSistema, CalculaDeterminante e CalculaInversa
  CheckBoxOpcoesClick(Self);
end;
procedure TForm1.RadioButtonMetodosIterativosClick(Sender: TObject);
begin
   // Evento onClick para RadioButton7 e RadioButton8
  // Não calcula Determinante nem Inversa, então tem que calcular Sistema (lógico)
  CheckBox2.Checked := True;
  CheckBox3.Enabled := False;
  CheckBox4.Enabled := False;
  // Executa a rotina do SpeedButton1 para verificar se grade está correta
  SpeedButton1.Click;
  // Executa a rotina CheckBoxOpcoesClick para rever os valores das
  // variáveis CalculaSistema, CalculaDeterminante e CalculaInversa
  CheckBoxOpcoesClick(Self);
end;
procedure TForm1.CheckBoxOpcoesClick(Sender: TObject);
begin
  // Evento onClick para CheckBox2 até CheckBox4
  CalculaSistema := CheckBox2.Checked and CheckBox2.Enabled;
  CalculaDeterminante := CheckBox3.Checked and CheckBox3.Enabled;
  CalculaInversa := CheckBox4.Checked and CheckBox4.Enabled;
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  // Impedir que o usuário digite dados na última posição da grade em Métodos Iterativos
  if GLX then
  with StringGrid1 do
  if (aCol=RowCount-1) and (aRow=RowCount-1) then
  CanSelect := False;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
  var
  k: Integer;
  begin
  // Verificar se será Método Iterativo
  GLX := RadioButtonMetodosIterativos.Checked or RadioButton8.Checked;
  // Para ser legal com o usuário, copiar o vetor b e o vetor xIni, se existir,
  // para restaurar para a nova posição após modificar o tamanho da grade
  // Além disto, deve-se limpar as posições atuais de b e xIni
  with StringGrid1 do
  begin
  for k := 1 to n_atual do
  begin
  bCopia[k] := Cells[n_atual+1,k];
  Cells[n_atual+1,k] := '';
  end;
  // Se GLX foi alterado no início da rotina, verificar se era GLX, verificando número de linhas
  if GLX and (RowCount = n_atual+2) then  // É Método Iterativo
  for k := 1 to n_atual do
  begin
  xIniCopia[k] := Cells[k,n_atual+1];
  Cells[k,n_atual+1] := '';
  end;
  end;
  // Rever valor de n
  n := SpinEdit1.Value;
  // Se alterou n, redimensionar grade
  if n <> n_atual then
  with StringGrid1 do
  begin
  // Altera o tamanho da grade
  RowCount := n+1;    // Linha 0 de texto + n linhas para matriz A + 1 linha se Método Iterativo
  ColCount := n+2;    // Coluna 0 de texto + n colunas para matriz A + 1 coluna para vetor b
  n_atual := n;
  // Escrever títulos da grade
  Cells[0,0] := 'A';
  for k := 1 to n do
  begin
  Cells[k,0] := IntToStr(k);
  Cells[0,k] := IntToStr(k);
  end;
  Cells[n+1,0] := 'b';
  // Dimensionar a grade, lembrando que para diferentes versões do Windows, há diferentes valores
  // para borda, scrollbar e até altura da casela, mesmo que seja criada com tamanho determinado
  Width := DCW*(n+2) + EFV;
  Height := DRH*(n+1) + EFH;
  if n > 7 then begin Width := DCW*9 + EFV; Height := Height + ESH; end;
  if n > 8 then begin Width := DCW*9 + EFV + ESV; Height := DRH*9 + EFH + ESH; end;
  SetFocus;
  end;
  // Com n alterado ou não, verificar se o tipo de método foi alterado
  // Verificar linha extra para entrada de dados de métodos iterativos
  with StringGrid1 do
  if GLX then               // Se método iterativo, acrescentar linha extra se não houver
  begin
  if RowCount = n+1 then  // Não tem linha Extra (acrescentar)
  begin
  RowCount := RowCount+1;
  if n < 8 then
  Height := Height+DRH;
  Cells[0,RowCount-1] := 'x inicial';
  if n > 7 then
  Width := DCW*9 + EFV + ESV;
  end;
  end
  else                      // Se método direto, remover linha extra se houver
  begin
  if RowCount = n+2 then  // Tem linha Extra (remover)
  begin
  RowCount := RowCount-1;
  Width := DCW*(n+2) + EFV;
  Height := DRH*(n+1) + EFH;
  if n > 7 then begin Width := DCW*9 + EFV; Height := Height + ESH; end;
  if n > 8 then begin Width := DCW*9 + EFV + ESV; Height := DRH*9 + EFH + ESH; end;
  end;
end;
// Para ser legal com o usuário, restaurar o vetor b e o vetor xIni, se existir,
// que foram copiados antes de modificar o tamanho da grade, para a nova posição
for k := 1 to n do
begin
StringGrid1.Cells[n+1,k] := bCopia[k];
if GLX then
StringGrid1.Cells[k,n+1] := xIniCopia[k];
end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
i, j: Integer;
begin
// Limpar Grade
for i := 1 to n do
for j := 1 to n+1 do
StringGrid1.Cells[j,i] := '';
end;
procedure TForm1.SpeedButton3Click(Sender: TObject);
var
i, j, k: Integer;
begin
ItMax := SpinEdit2.Value;
Epsilon := FloatSpinEdit1.Value;
// Para não cansar o usuário, preencher caselas vazias com zeros
if CheckBox1.Checked then  // Usuário marcou a opção preencher com zeros
begin
for i := 1 to n do
for j := 1 to n do
if (Trim(StringGrid1.Cells[j,i])) = '' then
StringGrid1.Cells[j,i] := '0';
// Em geral há poucos nulos no vetor b, mas se o usuário for preguiçoso, ...
for i := 1 to n do
if (Trim(StringGrid1.Cells[n+1,i])) = '' then
StringGrid1.Cells[n+1,i] := '0';
// Em geral, quando há ponto inicial, nem sempre são nulos, mas se o usuário for preguiçoso, ...
if GLX then
for j := 1 to n do
if (Trim(StringGrid1.Cells[j,n+1])) = '' then
StringGrid1.Cells[j,n+1] := '0';
end;
// Ler os dados literais da grade e transformá-los em números mas matrizes
for i := 1 to n do
begin
for j := 1 to n do
try
A[i,j] := StrToFloat(StringGrid1.Cells[j,i]);
except
  MessageDlg('O valor de A['+IntToStr(i)+','+IntToStr(j)+'] não é um número real válido', mtError, [mbOk], 0);
  StringGrid1.Col := j;
  StringGrid1.Row := i;
  StringGrid1.SetFocus;
  Exit;
  end;
  try
  b[i] := StrToFloat(StringGrid1.Cells[n+1,i]);
  except
  MessageDlg('O valor de b['+IntToStr(i)+'] não é um número real válido', mtError, [mbOk], 0);
  StringGrid1.Col := n+1;
  StringGrid1.Row := i;
  StringGrid1.SetFocus;
  Exit;
  end;
  end;
  // Se a grade tem linha extra (Métodos iterativos), existe ponto inicial xIni
  if GLX then
  for j := 1 to n do
  try
  xIni[j] := StrToFloat(StringGrid1.Cells[j,n+1]);
  except
  MessageDlg('O valor de x['+IntToStr(j)+'] não é um número real válido', mtError, [mbOk], 0);
StringGrid1.Col := j;
StringGrid1.Row := n+1;
StringGrid1.SetFocus;
Exit;
end;
// Se o usuário não escolheu o que quer ...
if not (CalculaSistema or CalculaDeterminante or CalculaInversa) then
begin
MessageDlg('Não foi solicitado resolver o sistema'+#10+'nem calcular o determinante'+#10+
'nem calcular a inversa.'+#10+'Então, nada será feito.', mtInformation, [mbOk], 0);
Exit;
end;
// Fechar a fôrma 2 e só reabrir se a solução existir (Erro = Falso)
Form2.Close;
// Definir Erro = Verdade - Se o método escolhido falhar, Erro será Verdade
// Se o método escolhido terminar corretamente será atribuído, antes de retornar, Erro = Falso
Erro := True;
if RadioButtonMetodosDiretos.Checked then Gauss;
if RadioButton2.Checked then GaussPivotamentoParcial;
if RadioButton3.Checked then GaussPivotamentoTotal;
if RadioButton4.Checked then GaussCompacto;
if RadioButton5.Checked then DecomposicaoLU;
if RadioButton6.Checked then Cholesky;
if RadioButtonMetodosIterativos.Checked then JacobiRichardson;
if RadioButton8.Checked then GaussSeidel;
if Erro then
Exit;
// Se não teve erro, basta dar a resposta
with Form2 do           // Tudo que segue é para fôrma 2 que apresenta a solução
begin
// Ajustar o tamanho da grade de solução
with StringGrid1 do
begin
RowCount := n+2;    // Linha 0 de texto + n linhas para matriz A + 1 linha para vetor x Solução
ColCount := n+2;    // Coluna 0 de texto + n colunas para matriz A + 1 coluna para vetor b
for i := 1 to n do
for j := 1 to n+1 do
Cells[j,i] := '';
Cells[0,0] := 'A';
for k := 1 to n do
begin
Cells[k,0] := IntToStr(k);
Cells[0,k] := IntToStr(k);
end;
Cells[n+1,0] := 'b';
Cells[0,n+1] := 'x';
Width := DCW*(n+2) + EFV;
Height := DRH*(n+2) + EFH;
if n > 7 then begin Width := DCW*9 + EFV + ESV; Height := DRH*9 + EFH + ESH; end;
end;
// Ajustar o tamanho da grade da inversa (1 linha e 1 coluna menos que a grade do sistema)
with StringGrid2 do
begin
RowCount := n+1;    // Linha 0 de texto + n linhas para matriz A
ColCount := n+1;    // Coluna 0 de texto + n colunas para matriz A
for i := 1 to n do
for j := 1 to n do
Cells[j,i] := '';
Cells[0,0] := 'A';
for k := 1 to n do
begin
Cells[k,0] := IntToStr(k);
Cells[0,k] := IntToStr(k);
end;
Width := DCW*(n+1) + EFV;
Height := DRH*(n+1) + EFH;
if n > 8 then begin Width := DCW*9 + EFV + ESV; Height := DRH*9 + EFH + ESH; end;
end;
// Apresentar Solução do Sistema
if CalculaSistema then
begin
GroupBox1.Caption := 'Solução do sistema';
if GLX then
GroupBox1.Caption := 'Solução do sistema - Iterações = '+IntToStr(Iteracao);
with StringGrid1 do
begin
for i := 1 to n do
begin
for j := 1 to n do
Cells[j,i] := FloatToStr(A[i,j]);
Cells[j+1,i] := FloatToStr(b[i]);
end;
for j := 1 to n do
Cells[j,n+1] := FloatToStr(x[j]);
// Limpar a casela da última posição da grade (pode ter valor de solução anterior)
Cells[n+1,n+1] := '';
end;
end
else
begin
GroupBox1.Caption := 'Solução do sistema - Não foi solicitado';
for i := 1 to n+1 do
for j := 1 to n+1 do
StringGrid1.Cells[j,i] := '';
end;
// Apresentar Determinante
if CalculaDeterminante then
Label1.Caption := 'Determinante = '+FloatToStr(Determinante)
else
Label1.Caption := 'Determinante - Não foi solicitado';
// Apresentar Inversa da Matriz
if CalculaInversa then
begin
GroupBox2.Caption := 'Matriz inversa';
with StringGrid2 do
for i := 1 to n do
for j := 1 to n do
Cells[j,i] := FloatToStr(AInv[i,j]);
end
else
begin
GroupBox2.Caption := 'Matriz inversa - Não foi solicitado';
for i := 1 to n do
for j := 1 to n do
          StringGrid2.Cells[j,i] := '';
    end;
// Tornar Form2 visível
Show;
end;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
// Ajuda
if not OpenDocument('SistemasLineares.chm') then
MessageDlg('O arquivo de ajuda'#10'SistemasLineares.chm'#10'não foi encontrado.', mtInformation, [mbOk], 0);
// Se quiser o título da janela em língua pátria, substitua a linha acima pela linha abaixo
//MessageDlg('Informação', 'O arquivo de ajuda'#10'SistemasLineares.chm'#10'não foi encontrado.', mtIn
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
// Sobre
Form3.ShowModal;
end;


end.

