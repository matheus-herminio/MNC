unit Solucao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type

  { TForm2 }

  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
{$R *.lfm}
{ TForm2 }
var
  PrimeiraVez: Boolean; // Primeira vez que a fôrma é aberta
  F2L, F2T: Integer;
procedure TForm2.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width-Width) div 2;
  Top := (Screen.Height-Height) div 2;
  PrimeiraVez := True;
end;
// Left e Top da fôrma 2, para abrir na mesma posição em que foi fechada
procedure TForm2.FormShow(Sender: TObject);
begin
  if PrimeiraVez then
  Exit;
  Left := F2L;
  Top := F2T;
end;
procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  PrimeiraVez := False;
  F2L := Left;
  F2T := Top;
  CanClose := True;
end;

end.

