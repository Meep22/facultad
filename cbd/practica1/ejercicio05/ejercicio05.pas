program Ejercicio5;
type
    tFlores = record
        numeroEs : Integer;
        alturaMax : Real;
        nombreCie : String[20];
        nombreVul : String[20];
    end;

    floresFile = File of tFlores;


procedure cargarArchivo (var f: floresFile);
var
    flor: tFlores;
begin
    Assign(f,'a.dat');
    Rewrite(f);
    Write('Ingrese el nombre cientifico de la flor: ');
    ReadLn(flor.nombreCie);
    while (flor.nombreCie <> 'ZZZ') do
    begin
        Write('Ingrese el numero de especie: ');
        ReadLn(flor.numeroEs);
        Write('Ingrese el nombre vulgar: ');
        ReadLn(flor.nombreVul);
        Write('Ingrese la altura maxima que alcanza la especie: ');
        ReadLn(flor.alturaMax);
        
        Write(f, flor);
        Write('Ingrese el nombre cientifico de la flor: ');
        ReadLn(flor.nombreCie);
    end;
end;

procedure imprimirArchivo(var f:floresFile);
var
    flor: tFlores;
begin
    Reset(f);
    while (not eof(f)) do
    begin
        Read(f,flor);
        WriteLn('Numero de flor: ', flor.numeroEs);
        WriteLn('Nombre cientifico de la flor: ', flor.nombreCie);
        WriteLn('Nombre vulgar de la flor: ', flor.nombreVul);
    end;
end;


procedure minMaxArchivo(var f: floresFile);
var
    act: tFlores;
    min, max: Real;
    cant: Integer;
begin
    Reset(f);
    min := 9999;
    max := -1;
    cant := 0;
    while (not eof(f)) do
    begin
        Read(f,act);
        if (act.alturaMax < min) then
            min:= act.alturaMax;
        if (act.alturaMax > max) then
            max:= act.alturaMax;
        cant:= cant + 1;
    end;
    imprimirArchivo(f);
    WriteLn('La altura maxima es: ', max);
    WriteLn('La altura minima es: ', min);
end;

var
    f: floresFile;
begin
    cargarArchivo(f);
    minMaxArchivo(f);
    Close(f);
end.