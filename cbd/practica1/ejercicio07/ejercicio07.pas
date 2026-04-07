program Ejercicio7;
type
    tAlumno = record
        dni : LongInt;
        legajo : Integer;
        nombre: string[15];
        apellido: string[15];
        direccion: string[25];
        cursando: Integer;
        nacimiento: LongInt;
    end;

    fAlumno= File of tAlumno;

procedure crearArchivo(var f: fAlumno);
var
    alumnos: Text;
    alu: tAlumno;
begin
    Assign(alumnos, 'alumnos.txt');
    Assign(f, 'alumnos.dat');
    Rewrite(f);
    Reset(alumnos);
    while (not eof(alumnos)) do
    begin
        ReadLn(alumnos, alu.dni);
        ReadLn(alumnos, alu.legajo);
        ReadLn(alumnos, alu.nombre);
        ReadLn(alumnos, alu.apellido);
        ReadLn(alumnos, alu.direccion);
        ReadLn(alumnos, alu.cursando);
        ReadLn(alumnos, alu.nacimiento);

        Write(f, alu);
    end;
    Close(alumnos);
end;

procedure listarPorCaracter(var f: fAlumno; c: char);
var
    a: tAlumno;
begin
    Reset(f);
    c:= UpCase(c);
    while (not eof(f)) do
    begin
        Read(f, a);
        if (a.nombre[1] = c) then
        begin
            WriteLn('DNI: ',a.dni);
            WriteLn('Legajo: ',a.legajo);
            WriteLn('Nombre: ',a.nombre);
            WriteLn('Apellido: ',a.apellido);
            WriteLn('Direccion: ',a.direccion);
            WriteLn('Esta cursando el ',a.cursando,' anio');
            WriteLn('Fecha de nacimiento: ',a.nacimiento);
            WriteLn();
        end;
    end;
end;

procedure listarEnArchivo(var f: fAlumno);
var
    al: Text;
    a: tAlumno;
begin
    Assign(al, 'alumnosAEgresar.txt');
    Rewrite(al);
    Reset(f);
    while (not eof(f)) do
    begin
        Read(f, a);
        if (a.cursando = 5) then
        begin
            WriteLn(al,a.dni);
            WriteLn(al,a.legajo);
            WriteLn(al,a.nombre);
            WriteLn(al,a.apellido);
            WriteLn(al,a.direccion);
            WriteLn(al,a.cursando);
            WriteLn(al,a.nacimiento);
        end;
    end;
    Close(al);
end;

procedure agregarAlFinal(var f: fAlumno);
var
    alu: tAlumno;
begin
    Reset(f);
    Seek(f, FileSize(f));
    Write('Ingrese el DNI del alumno(-1 para finalizar): ');
    ReadLn(alu.dni);
    while (alu.dni <> -1) do
    begin
        Write('Ingrese el legajo: ');
        ReadLn(alu.legajo);
        Write('Ingrese el nombre: ');
        ReadLn(alu.nombre);
        Write('Ingrese el apellido: ');
        ReadLn(alu.apellido);
        Write('Ingrese la direccion: ');
        ReadLn(alu.direccion);
        Write('Ingrese el anio que esta cursando: ');
        ReadLn(alu.cursando);
        Write('Ingrese la fecha de nacimiento: ');
        ReadLn(alu.nacimiento);
        Write(f, alu);
        Write('Ingrese el DNI del alumno(-1 para finalizar): ');
        ReadLn(alu.dni);
    end;
end;

procedure modificarCursada(var f:fAlumno; leg: Integer);
var
    al: tAlumno;
    encontre: boolean;
begin
    Reset(f);
    encontre:= false;
    while (not eof(f) and not encontre) do
    begin
        Read(f, al);
        if (al.legajo = leg) then
        begin
            Write('Ingrese el nuevo anio de cursada: ');
            ReadLn(al.cursando);
            Seek(f, FilePos(f) - 1);
            Write(f, al);
            encontre:= true;
        end;
    end;
end;

var
    f: fAlumno;
    leg: Integer;
    c: char;
begin
    crearArchivo(f);
    Write('Ingrese el legajo a buscar: ');
    ReadLn(leg);
    modificarCursada(f, leg);
    listarEnArchivo(f);
    Write('Ingrese un caracter: ');
    ReadLn(c);
    listarPorCaracter(f,c);
    Close(f);
end.
