unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, TAGraph, TASeries;

type

  { TForm2 }

  TForm2 = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

end.

