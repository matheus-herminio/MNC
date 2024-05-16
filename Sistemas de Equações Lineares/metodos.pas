unit Metodos;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, Dialogs;

var
n, Iteracao, ItMax: Integer;
Epsilon, Determinante: Real;
Erro, CalculaSistema, CalculaDeterminante, CalculaInversa: Boolean;
// A, L, U, G, AInv: array of array of Real;
// b, x, xIni, y, bj, xj: array of Real;
// Poderia utilizar matrizes dinâmicas, mas como o programa foi
// limitado a sistemas de até 20x20, vou usar matrizes estáticas
A, L, U, G, AInv: array [1..20, 1..20] of Real;
b, x, xIni, y, bj, xj: array [1..20] of Real;
procedure Gauss;
procedure GaussPivotamentoParcial;
procedure GaussPivotamentoTotal;
procedure GaussCompacto;
procedure DecomposicaoLU;
procedure Cholesky;
procedure JacobiRichardson;
procedure GaussSeidel;

implementation
procedure Gauss;
var
i, j, k: Integer;
m, soma: Real;
begin
Erro := True;  // Já foi definido em Principal - só está também aqui para você se lembrar

// Triangularizando a matriz (Gauss)
for j:=1 to n-1 do
begin
    for i:= j+1 to n do
    begin
       try
         m := A[i,j]/A[j,j];
       except
         begin
            MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
            Exit;
         end;
       end;
       for k:= j to n do
       begin
          A[i,k] := A[i,k] - A[j,k]*m;
          if(abs(A[i,k]) < 0.000000000000001) then
              A[i,k] := 0;
       end;
       b[i] := b[i] - m*b[j];
    end;
end;
//Solução Sistema
    try
       x[n] := b[n]/A[n,n];
    except
    begin
         MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
         Exit;
    end;
    end;
    for i := n-1 downto 1 do
    begin
       soma := 0;
       for j := i+1 to n do
       begin
            soma := soma + A[i,j]*x[j];
       end;
       try
         x[i] := (b[i]-soma)/A[i,i];
       except
       begin
         MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
         Exit;
       end;
       end;
    end;

{Escreva o trecho de programa que triangulariza a Matriz A.
Lembre-se de utilizar try except end ao calcular m = aij /aii e se
houver exceção informar que o determinante é nulo e interromper.}


  // Solução por Retrosubstituição
{Escreva o trecho de programa que resolve o sistema.
Lembre-se de utilizar try except end ao calcular xn = bn /ann e xi = (bi-soma)/aii e se
houver exceção informar e interromper.
Ao terminar, atribua Erro = Falso, pois na chamada
da rotina, na fôrma Principal, foi atribuído Erro = Verdade}


  Erro := False;

// Determinante
if not CalculaDeterminante then
Exit;
   Determinante := 1;
   for i:= 1 to n do
   Determinante := Determinante*A[i,i];
{Se não é para calcular o determinante, interromper.
Se forpara calcular, calcule o Determinante que é o
produtodos elementos da diagonal de A que já foi triangularizada.}

end;
procedure GaussPivotamentoParcial;
var
  i, j, k, p, lin_max, cont: Integer;
  m, soma, aux, val_max: Real;
begin
     Erro := True;
     cont := 0;
     for j:=1 to n-1 do
     begin
       lin_max := j;
       val_max := abs(A[j,j]);
       for p:= j+1 to n do
       begin
         if(abs(A[p,j]) > val_max) then
         begin
              lin_max := p;
              val_max := abs(A[p,j]);
         end;
       end;
       if (lin_max <> j) then
       begin
          cont := cont+1;
          for p := j to n do
          begin
              aux := A[lin_max, p];
              A[lin_max, p] := A[j, p];
              A[j, p] := aux;
          end;
          aux := b[j];
          b[j] := b[lin_max];
          b[lin_max] := aux;
       end;
       for i:= j+1 to n do
       begin
        try
          m := A[i, j]/A[j, j];
        except
        begin
          MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
          Exit;
        end;
        end;
        for k:= j to n do
        begin
          A[i, k] := A[i, k] - A[j, k]*m;
          if(abs(A[i,k]) < 0.000000000000001) then
              A[i,k] := 0;
        end;
        b[i] := b[i] - m*b[j];
       end;
     end;
     //Solução do Sistema
     try
       x[n] := b[n]/A[n,n];
    except
    begin
         MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
         Exit;
    end;
    end;
    for i := n-1 downto 1 do
    begin
       soma := 0;
       for j := i+1 to n do
       begin
            soma := soma + A[i,j]*x[j];
       end;
       try
         x[i] := (b[i]-soma)/A[i,i];
       except
       begin
         MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
         Exit;
       end;
       end;
    end;
     Erro := false;
     if not CalculaDeterminante then
     Exit;
         Determinante := 1;
         for i:= 1 to n do
             Determinante := Determinante*A[i, i];
         if((cont mod 2) = 1) then Determinante := -Determinante;
end;

procedure GaussPivotamentoTotal;
var
  v_aux : array [1..20] of Real;
  x_aux : array [1..20] of Integer;
  i, j, k, p, lin_max, col_max, aux_int, cont: Integer;
  m, soma, aux, val_max: Real;
begin
     cont := 0;
     for i:=1 to n do
         x_aux[i] := i;
     val_max := 0;
     Erro := True;

     for j:=1 to n-1 do
     begin
       lin_max := j;
       col_max := j;
       val_max := abs(A[j,j]);
       for p:= j to n do
       begin
           for k:= j to n do
           begin
               if(abs(A[p,k]) > val_max) then
               begin
                   val_max := abs(A[p,k]);
                   lin_max := p;
                   col_max := k;
               end;
           end;
       end;
       if (lin_max <> j) or (col_max <> j) then
       begin
          if (lin_max <> j) then cont := cont+1;
          if (col_max <> j) then cont := cont+1;
          for p := j to n do
          begin
              aux := A[lin_max, p];
              A[lin_max, p] := A[j, p];
              A[j, p] := aux;
          end;
          aux := b[j];
          b[j] := b[lin_max];
          b[lin_max] := aux;

          for k := 1 to n do
          begin
              aux := A[k, col_max];
              A[k, col_max] := A[k, j];
              A[k, j] := aux;
          end;
          aux_int := x_aux[col_max];
          x_aux[col_max] := x_aux[j];
          x_aux[j] := aux_int;

       end;
       for i:= j+1 to n do
       begin
        try
          m := A[i, j]/A[j, j];
        except
        begin
          MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
          Exit;
        end;
        end;
        for k:= j to n do
        begin
          A[i, k] := A[i, k] - A[j, k]*m;
          if(abs(A[i,k]) < 0.000000000000001) then
              A[i,k] := 0;
        end;
        b[i] := b[i] - m*b[j];
       end;
     end;

     //Solução Sistema
    try
       x[n] := b[n]/A[n,n];
    except
    begin
         MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
         Exit;
    end;
    end;
    for i := n-1 downto 1 do
    begin
       soma := 0;
       for j := i+1 to n do
       begin
            soma := soma + A[i,j]*x[j];
       end;
       try
          x[i] := (b[i]-soma)/A[i,i];
       except
       begin
         MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
         Exit;
       end;
       end;
    end;
    for i:=1 to n do
         v_aux[x_aux[i]] := x[i];

    for i:=1 to n do
         x[i] := v_aux[i];

    Erro := false;
    //Determinante
    if not CalculaDeterminante then
    Exit;
        Determinante := 1;
        for i:= 1 to n do
            Determinante := Determinante*A[i, i];
        if((cont mod 2) = 1) then Determinante := -Determinante;
end;

procedure GaussCompacto;
var
i, j, k: Integer;
soma, val: Real;
LU :array [1..20, 1..21] of Real;
begin
Erro := True;  // Já foi definido em Principal - só está também aqui para você se lembrar
for i:=1 to n do
 for j:=1 to n+1 do
     LU[i,j] := 0;
for i := 1 to n do
begin
    for j := i to n+1 do
    begin
      soma := 0;
      for k := 1 to i-1 do
      begin
          if(i = k) then
          begin
              val := 1;
          end
          else
              val := LU[i,k];
          soma := soma + val*LU[k,j];
      end;
      if(j=n+1) then
      begin
           LU[i,j] := b[i] - soma;
           y[i] := b[i] - soma;
      end
      else
          LU[i,j] := A[i,j] - soma;
    end;
    for j := i+1 to n do
    begin
      soma := 0;
      for k := 1 to i-1 do
      begin
          if(i = k) then
          begin
              val := 1;
          end
          else
              val := LU[j,k];
          soma := soma + val*LU[k,i];
      end;
      try
        LU[j,i] := (A[j,i] - soma)/LU[i,i];
      except
      begin
        MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
        Exit;
      end;
      end;
    end;
end;

// Solução de U.x = y
try
  x[n] := y[n]/LU[n,n];
except
begin
  MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
  Exit;
end;
end;
for i:= n-1 downto 1 do
begin
     soma:=0;
     for j:= i+1 to n do
         soma := soma + LU[i,j]*x[j];
     try
        x[i] := (y[i]-soma)/LU[i,i];
      except
      begin
        MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
        Exit;
      end;
      end;
end;
{Escreva o trecho de programa que decompõe A em L.U.
Se você utilizar matrizes L e U deverá, no início, preencher Lkk com a unidade, como apresentado acima.
Se você utilizar apenas a matriz A, armazenando os valores de lij e uij na própria matriz A, remova o trecho acima.
Lembre-se de utilizar try except end ao calcular lji = aji-soma)/uii e se houver exceção informar que o
determinante é nulo e interromper}


{Se você utilizar apenas a matriz A para armazenar os valores de L e U, remova o trecho abaixo.
Se você utilizar as matrizes L e U, o trecho abaixo armazena L e U em A, para apresentar a solução da decomposição.
Como lembrete, isto não foi necessário na rotina Gauss, pois nela, A é triangularizada na própria matriz A.}

// Colocando L e U em A
for i := 1 to n do
for j := 1 to n do
A[i,j] := LU[i,j];

// Determinante
if CalculaDeterminante then
begin
   Determinante := 1;
        for i:= 1 to n do
            Determinante := Determinante*A[i, i];
{Se não é para calcular o determinante, interromper.
Se forpara calcular, calcule o Determinante que é o produto dos elementos da diagonal de U ou de A, que já contém o valor de U.
Note que na rotina Gauss, se não é para calcular o Determinante, a rotina termina. Neste caso, não pode terminar, pois a seguir
é feito o cálculo da inversa.
Você pode fazer seu programa Principal diferente e alterar as rotinas desta Unit Metodos.}
end;
// Inversa
if CalculaInversa then
begin
// Cálculo da Inversa (resolver o sistema n vezes, com vetores b nulos, exceto na posição j)
// Os vetores b serão chamados de bj, para não perder o valor de b do sistema
// O vetor x será chamado de xj, para não perder o valor de x do sistema
for k := 1 to n do
begin
// Preencher o vetor b referente à coluna j da Identidade
FillChar(bj, SizeOf(bj), 0);
bj[k] := 1;
// Solução de L.y = b por Substituição
y[1] := bj[1];
if(abs(y[i]) < 0.00000000001) then
    y[1] := 0;
for i:=2 to n do
begin
  soma:=0;
  for j:=1 to i-1 do
      if(i=j) then
      begin
      val := 1;
      end
      else val := A[i,j];
      soma:= soma + val*y[j];
  y[i] := (bj[i]-soma);
  if(abs(y[i]) < 0.00000000001) then
      y[i] := 0;
end;
{
Repetir o mesmo trecho de programa anterior que calcula y com a relação L.y = b, com o vetor bj.
Lembre-se de utilizar try except end como no trecho anterior
}
// Solução de U.x = y por Retrosubstituição
try
  xj[n] := y[n]/A[n,n];
  if(abs(xj[n]) < 0.00000000001) then
      xj[n] := 0;
except
begin
  MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
  Exit;
end;
end;
for i:= n-1 downto 1 do
begin
     soma:=0;
     for j:= i+1 to n do
         soma := soma + A[i,j]*xj[j];
     try
        xj[i] := (y[i]-soma)/A[i,i];
        if(abs(xj[i]) < 0.00000000001) then
            xj[i] := 0;
      except
      begin
        MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
        Exit;
      end;
      end;
end;
{
Escreva o mesmo trecho de programa anterior que calcula x com a relação U.x =y, com o vetor xj.
Lembre-se de utilizar try except end como no trecho anterior.}

// Preencher as colunas da matriz inversa de A com os vetores xj
for i := 1 to n do
AInv[i,k] := xj[i];
end;
end;
Erro := False;
end;

procedure DecomposicaoLU;
var
i, j, k: Integer;
soma: Real;
begin
Erro := True;  // Já foi definido em Principal - só está também aqui para você se lembrar

// Decompondo A em L.U

for k := 1 to n do
    L[k,k] := 1;
for i := 1 to n do
begin
    for j := i to n do
    begin
      soma := 0;
      for k := 1 to i-1 do
          soma := soma + L[i,k]*U[k,j];
      U[i,j] := A[i,j] - soma;
    end;
    for j := i+1 to n do
    begin
      soma := 0;
      for k:= 1 to i-1 do
          soma := soma + L[j,k]*U[k,i];
      try
        L[j,i] := (A[j,i] - soma)/U[i,i];
      except
      begin
        MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
        Exit;
      end;
      end;
    end;
end;
// Solução de L.y = b
y[1] := b[1]/L[1,1];
if(abs(y[1]) < 0.00000000001) then
    y[1] := 0;
for i:=2 to n do
begin
  soma:=0;
  for j:=1 to i-1 do
      soma:= soma + L[i,j]*y[j];
  y[i] := (b[i]-soma)/L[i,i];
if(abs(y[i]) < 0.00000000001) then
     y[i] := 0;
end;

// Solução de U.x = y
try
  x[n] := y[n]/U[n,n];
  if(abs(x[n]) < 0.00000000001) then
     x[n] := 0;
except
begin
  MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
  Exit;
end;
end;
for i:= n-1 downto 1 do
begin
     soma:=0;
     for j:= i+1 to n do
         soma := soma + U[i,j]*x[j];
     try
        x[i] := (y[i]-soma)/U[i,i];
        if(abs(x[i]) < 0.00000000001) then
            x[i] := 0;
      except
      begin
        MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
        Exit;
      end;
      end;
end;
{Escreva o trecho de programa que decompõe A em L.U.
Se você utilizar matrizes L e U deverá, no início, preencher Lkk com a unidade, como apresentado acima.
Se você utilizar apenas a matriz A, armazenando os valores de lij e uij na própria matriz A, remova o trecho acima.
Lembre-se de utilizar try except end ao calcular lji = aji-soma)/uii e se houver exceção informar que o
determinante é nulo e interromper}


{Se você utilizar apenas a matriz A para armazenar os valores de L e U, remova o trecho abaixo.
Se você utilizar as matrizes L e U, o trecho abaixo armazena L e U em A, para apresentar a solução da decomposição.
Como lembrete, isto não foi necessário na rotina Gauss, pois nela, A é triangularizada na própria matriz A.}

    // Colocando L e U em A
for i := 1 to n do
for j := i to n do
A[i,j] := U[i,j];
for i := 2 to n do
for j := 1 to i-1 do
A[i,j] := L[i,j];

// Determinante
if CalculaDeterminante then
begin
   Determinante := 1;
        for i:= 1 to n do
            Determinante := Determinante*A[i, i];
{Se não é para calcular o determinante, interromper.
Se forpara calcular, calcule o Determinante que é o produto dos elementos da diagonal de U ou de A, que já contém o valor de U.
Note que na rotina Gauss, se não é para calcular o Determinante, a rotina termina. Neste caso, não pode terminar, pois a seguir
é feito o cálculo da inversa.
Você pode fazer seu programa Principal diferente e alterar as rotinas desta Unit Metodos.}
end;
// Inversa
if CalculaInversa then
begin
// Cálculo da Inversa (resolver o sistema n vezes, com vetores b nulos, exceto na posição j)
// Os vetores b serão chamados de bj, para não perder o valor de b do sistema
// O vetor x será chamado de xj, para não perder o valor de x do sistema
for k := 1 to n do
begin
// Preencher o vetor b referente à coluna j da Identidade
FillChar(bj, SizeOf(bj), 0);
bj[k] := 1;
// Solução de L.y = b por Substituição
y[1] := bj[1]/L[1,1];
for i:=2 to n do
begin
  soma:=0;
  for j:=1 to i-1 do
      soma:= soma + L[i,j]*y[j];
  y[i] := (bj[i]-soma)/L[i,i];
end;
{
Repetir o mesmo trecho de programa anterior que calcula y com a relação L.y = b, com o vetor bj.
Lembre-se de utilizar try except end como no trecho anterior
}
// Solução de U.x = y por Retrosubstituição
try
  xj[n] := y[n]/U[n,n];
except
begin
  MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
  Exit;
end;
end;
for i:= n-1 downto 1 do
begin
     soma:=0;
     for j:= i+1 to n do
         soma := soma + U[i,j]*xj[j];
     try
        xj[i] := (y[i]-soma)/U[i,i];
      except
      begin
        MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
        Exit;
      end;
      end;
end;
{
Escreva o mesmo trecho de programa anterior que calcula x com a relação U.x =y, com o vetor xj.
Lembre-se de utilizar try except end como no trecho anterior.}

// Preencher as colunas da matriz inversa de A com os vetores xj
for i := 1 to n do
AInv[i,k] := xj[i];
end;
end;
Erro := False;
end;

procedure Cholesky;
var
i, j, k: Integer;
soma: Real;
begin
Erro := True;  // Já foi definido em Principal - só está também aqui para você se lembrar

// Verificar se A é simétrica
for i := 1 to n-1 do
for j := i+1 to n do
if (A[i,j] <> A[j,i]) then
begin
MessageDlg('A matriz A não é Simétrica.', mtInformation, [mbOk], 0);
Exit;
end;

// Decompondo A em G.GT
 for k:=1 to n do
 begin
   soma := 0;
   for j:=1 to k-1 do
       soma := soma + G[k,j]*G[k,j];
      //G[k,k] := 1;
    if (soma > A[k,k]) then
    begin
      MessageDlg('A matriz não é definida positiva!',mtInformation, [mbOk], 0);
      Exit;
    end;
    G[k,k] := Sqrt(A[k,k] - soma);
    for i:=k+1 to n do
    begin
       soma := 0;
       for j:= 1 to k-1 do
           soma := soma + G[i,j]*G[k,j];
       try
          G[i,k] := (A[i,k]-soma)/G[k,k];
       except
       begin
          MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
          Exit;
       end;
       end;

   end;
 end;

// Preenchendo a GT
for i := 1 to n-1 do
for j := i+1 to n do
G[i,j] := G[j,i];


{Se você utilizar apenas a matriz A, o trecho acima deve ser modificado.}

  // Solução de G.y = b por Substituição
  // Tratamento de erro ja foi feito em cima
  try
      y[1] := b[1]/G[1,1];
  except
  begin
    MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
    Exit;
  end;
  end;

  for i:=2 to n do
  begin
    soma:=0;
    for j:=1 to i-1 do
        soma:= soma + G[i,j]*y[j];
     try
        y[i] := (b[i]-soma)/G[i,i];
    except
    begin
      MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
      Exit;
    end;
    end;
  end;


  // Solução de GT.x = y por Retrosubstituição
  try
    x[n] := y[n]/G[n,n];
  except
  begin
    MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
    Exit;
  end;
  end;
  for i:= n-1 downto 1 do
  begin
       soma:=0;
       for j:= i+1 to n do
           soma := soma + G[i,j]*x[j];
       try
          x[i] := (y[i]-soma)/G[i,i];
        except
        begin
          MessageDlg('A matriz tem determinante nulo!',mtInformation, [mbOk], 0);
          Exit;
        end;
        end;
  end;


  // Colocando G em A
for i := 1 to n do
for j := 1 to n do
A[i,j] := G[i,j];

Erro := False;

// Determinante
if not CalculaDeterminante then
Exit;
Determinante := 1;
  for i:= 1 to n do
      Determinante := Determinante*A[i, i];
  Determinante := Determinante*Determinante;
end;

function Distancia: Extended;
var
Numerador, Denominador: Extended;
i: Integer;
begin
  Numerador := 0;
  Denominador := 0;
for i := 1 to n do
begin
  Numerador := Numerador+Sqr(x[i]-xIni[i]);
  Denominador := Denominador+Sqr(x[i]);
end;
    Result := SqRt(Numerador){/SqRt(Denominador)};
end;

procedure JacobiRichardson;
var
  i, j: Integer;
  soma, Maximo: Real;
  CDL, CDC: Boolean;
begin
Erro := True;
// Verificar critério das linhas
Maximo := 0;
for i:= 1 to n do
begin
    soma := 0;
    for j:=1 to n do
    begin
        if(i<>j) then
            soma:=soma+abs(A[i,j]);
    end;
    soma := soma/abs(A[i,i]);
    if(Maximo< soma) then
        Maximo := soma;
end;

  CDL := Maximo < 1;               // CDL é True se Maximo < 1

// Verificar critério de colunas
Maximo := 0;

for j:= 1 to n do
begin
    soma := 0;
    for i:=1 to n do
    begin
        if(i<>j) then
            soma:=soma+abs(A[i,j]);
    end;
    soma := soma/abs(A[j,j]);
    if(Maximo< soma) then
        Maximo := soma;
end;

  CDC := Maximo < 1;               // CDC é True se Maximo < 1
if not (CDL or CDC) then         // Se um dos critérios é True continua
begin                            // Pode-se tentar a solução, mas vou interromper
MessageDlg('A matriz não atende ao Critério das'+#10+'Linhas nem '+
'ao Critério das Colunas.', mtInformation, [mbOk], 0);
Exit;
end;
// Jacobi usa xIni para calcular x e o vetor xIni já foi lido da grade e está na memória
// Iterações do método
  Iteracao := 0;
  while True do
  begin
    Iteracao := Iteracao+1;
    if(Iteracao > ItMax) then
    begin
         Iteracao := ItMax;
         break;
    end;
    for i:=1 to n do
    begin
      soma:=0;
      for j:=1 to n do
      begin
          if(i<>j) then
              soma:=soma + A[i,j]*xIni[j];
      end;
      x[i] := (b[i] - soma)/A[i,i];
    end;
    if( Distancia < Epsilon) then
    begin
         break;
    end;
    for i:=1 to n do
        xIni[i] := x[i];

  end;
  Erro := false;
end;
procedure GaussSeidel;
var
i, j: Integer;
soma, Maximo: Real;
CDL, CDS: Boolean;
Beta: array [1..20] of Real;
begin
Erro := True;
// Verificar critério das linhas
Maximo := 0;
for i:= 1 to n do
begin
    soma := 0;
    for j:=1 to n do
    begin
        if(i<>j) then
            soma:=soma+abs(A[i,j]);
    end;
    soma := soma/abs(A[i,i]);
    if(Maximo< soma) then
        Maximo := soma;
end;

  CDL := Maximo < 1;              // CDL é True se Maximo < 1
// Verificar critério de Sassenfeld
for i:=1 to n do
begin
    Beta[i]:=0;
    for j:=1 to i-1 do
        Beta[i] := Beta[i] + abs(A[i,j]/A[i,i])*Beta[j];
    for j:= i+1 to n do
        Beta[i] := Beta[i] + abs(A[i,j]/A[i,i]);
    if (Maximo < Beta[i]) then
       Maximo := Beta[i];
end;

  CDS := Maximo < 1;               // CDS é True se Maximo < 1
if not (CDL or CDS) then         // Se um dos critérios é True continua
begin                            // Pode-se tentar a solução, mas vou interromper
MessageDlg('A matriz não atende ao Critério das'+#10+'Linhas nem '+
'ao Critério de Sassenfeld.', mtInformation, [mbOk], 0);
Exit;
end;
// Seidel usa x para calcular novo x e, então, deve-se iniciar x com xInijá foi lido da grade e está na memória
for i := 1 to n do
x[i] := xIni[i];
// Iterações do método
  Iteracao := 0;
while True do
begin
  Iteracao := Iteracao+1;
      if(Iteracao > ItMax) then
      begin
           Iteracao := ItMax;
           break;
      end;
      for i:=1 to n do
      begin
        soma:=0;
        for j:=1 to n do
        begin
            if(i<>j) then
                soma:=soma + A[i,j]*x[j];
        end;
        x[i] := (b[i] - soma)/A[i,i];
      end;
      if( Distancia < Epsilon) then
      begin
           break;
      end;
      for i:=1 to n do
          xIni[i] := x[i];

  end;
  Erro := false;
end;

end.

