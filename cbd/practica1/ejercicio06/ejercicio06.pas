program Ejercicio6;
type
    tLibro = record
        ISBN : Int64;
        titulo : string[50];
        genero : string[50];
        editorial : string[50];
        edicion : Integer;
    end;

    lFile = File of tLibro;

procedure crearArchivo(var f: lFile);
var
    libros: Text;
    lib: tLibro;
    trash: char;
begin
    Assign(libros, 'libros.txt');
    Assign(f,'datos.dat');
    Rewrite(f);
    Reset(libros);
    while (not eof(libros)) do
    begin
        Read(libros, lib.ISBN);
        Read(libros, trash);
        ReadLn(libros, lib.titulo);
        Read(libros, lib.edicion);
        Read(libros, trash);
        ReadLn(libros, lib.editorial);
        ReadLn(libros, lib.genero);
        Write(f, lib);
    end;
    Close(libros);
end;

procedure editarArchivo(var f: lFile; nuevo: tLibro);
var
    libro: tLibro;
    encontre: boolean;
begin
    encontre:= false;
    Reset(f);
    while (not eof(f) and not encontre) do
    begin
        Read(f, libro);
        if (libro.ISBN = nuevo.ISBN) then
        begin
            encontre:= true;
            Seek(f, FilePos(f) - 1);
        end;
    end;
    Write(f, nuevo);
end;

procedure imprimirArchivo(var f: lFile);
var
    lib: tLibro;
begin
    Reset(f);
    while (not eof(f)) do
    begin
        Read(f, lib);
        WriteLn('ISBN: ', lib.ISBN);
        WriteLn('Titulo: ', lib.titulo);
        WriteLn('Edicion: ', lib.edicion);
        WriteLn('Editorial: ', lib.editorial);
        WriteLn('Genero: ', lib.genero);
    end;
end;

var
    f: lFile;
    lib: tLibro;
begin
    crearArchivo(f);
    Write('Ingrese el ISBN: ');
    ReadLn(lib.ISBN);
    Write('Ingrese el titulo del libro: ');
    ReadLn(lib.titulo);
    Write('Ingrese la edicion: ');
    ReadLn(lib.edicion);
    Write('Ingrese la editorial del libro: ');
    ReadLn(lib.editorial);
    Write('Ingrese el genero del libro: ');
    ReadLn(lib.genero);
    editarArchivo(f,lib);
    imprimirArchivo(f);
    Close(f);
end.
