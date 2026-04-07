program Ejercicio3;
type
    dinosaurio = string[20];


procedure crearArchivo(var f: Text);
var
    nombreArch: string;
begin
    WriteLn('Ingrese el nombre del archivo: ');
    ReadLn(nombreArch);
    Assign(f,nombreArch);
    Rewrite(f);
end;

procedure cargarArchivo(var f: Text);
var
    dino: dinosaurio;
begin
    WriteLn('Ingrese el nombre del dinosaurio: ');
    ReadLn(dino);
    while (dino <> 'ZZZ') do
    begin
        WriteLn(f,dino);
        WriteLn('Ingrese el nombre del dinosaurio: ');
        ReadLn(dino);
    end;
end;

procedure imprimirArchivo(var f: Text);
var
    act: dinosaurio;
begin
Reset(f);
    while (not eof(f)) do
    begin
        ReadLn(f,act);
        WriteLn('- ', act);
    end;
end;

var
    f: Text;
begin
   crearArchivo(f);
   cargarArchivo(f);
   imprimirArchivo(f);
   Close(f);
end.
