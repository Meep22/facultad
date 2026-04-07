program Ejercicio1;
type
    material = String[20];
    materialFile = File of material;
    fileName = String[20];

procedure crearArchivo(var arch: materialFile);
var
    nombre: fileName;
begin
    WriteLn('Ingrese el nombre del archivo: ');
    ReadLn(nombre);
    Assign(arch, nombre);
    Rewrite(arch);
end;

procedure cargarArchivo(var arch : materialFile);
var
    mat: material;
begin
    repeat
        WriteLn('Ingrese el material a cargar en el archivo: ');
        ReadLn(mat);
        Write(arch,mat);
    until (mat = 'cemento');
end;

procedure imprimirArchivo(var arch: materialFile);
var
    mat: material;
begin
    while (not eof(arch)) do
    begin
        Read(arch,mat);
        WriteLn('- ', mat);
    end;
end;

var
    arch: materialFile;

begin
    crearArchivo(arch);
    cargarArchivo(arch);
    Reset(arch);
    imprimirArchivo(arch);
    Close(arch);
end.
