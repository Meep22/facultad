program Ejercicio4;
type
    votosFile = File of Integer;
    nombreArchivo = string[20];

procedure crearArchivo(var arch: votosFile);
var
    nombre: nombreArchivo;
    votos: Integer;
begin
    WriteLn('Ingrese el nombre del archivo: ');
    ReadLn(nombre);
    Assign(arch, nombre);
    Rewrite(arch);
    WriteLn('Ingrese la cantidad de votos de la ciudad: ');
    Read(votos);
    while(votos <> -1) do
    begin
        Write(arch,votos);
        WriteLn('Ingrese la cantidad de votos de la ciudad: ');
        Read(votos);
    end;
end;

procedure maxMinArchivo(var arch: votosFile; var max: Integer; var min: Integer);
var
    act: Integer;
begin
    Reset(arch);
    max:= -1;
    min:= 9999;
    while (not eof(arch)) do
    begin
        Read(arch, act);
        if (act > max) then
           max:= act;
        if (act < min) then
            min:= act;
    end;
end;

procedure imprimirArchivo(var arch: votosFile);
var
    act: Integer;
begin
Reset(arch);
    while (not eof(arch)) do
    begin
        Read(arch,act);
        WriteLn('- ', act);
    end;
end;

procedure copiarArchivo(var f:votosFile);
var
    copia: Text;
    act: Integer;
begin
    Reset(f);
    Assign(copia,'copia.txt');
    Rewrite(copia);
    while (not eof(f)) do
    begin
        Read(f, act);
        WriteLn(copia, act);
    end;
    Close(copia);
end;

procedure imprimirArchivoTexto();
var
    f: Text;
    act: Integer;
begin
    Assign(f,'copia.txt');
    Reset(f);
    while (not eof(f)) do
    begin
        ReadLn(f, act);
        WriteLn('- ', act);
    end;
    Close(f);
end;

var
    arch: votosFile;
    max, min: Integer;
begin
   crearArchivo(arch);
   Close(arch);
   maxMinArchivo(arch, max, min);
   imprimirArchivo(arch);
   copiarArchivo(arch);
   Close(arch);
   WriteLn('El maximo es: ', max);
   WriteLn('El minimo es: ', min);
   imprimirArchivoTexto();

end.
