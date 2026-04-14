program ejercicio07;
type
    rPersona= Record
        dni:Integer;
        nombre: String;
        apellido:String;
        sueldo: Real;
    end;

    fPersona = File of rPersona;

procedure crear(var f: fPersona; var fText: Text);
var
    reg: rPersona;
begin
    reset(fText);
    rewrite(f);
    reg.dni:= 0;
    reg.nombre:= '';
    reg.apellido:= '';
    reg.sueldo:= 0;
    // Inicializo la cabecera
    write(f, reg);
    while (not eof(fText)) do
    begin
        readln(fText, reg.dni, reg.nombre);
        readln(fText, reg.apellido);
        readln(fText, reg.sueldo);
        write(f, reg);
    end;
    close(f);
    close(fText);
end;

procedure agregar (var f: fPersona; reg: rPersona);
var
    cabecera: rPersona;
    nLibre: Integer;
begin
    reset(f);
    if (not eof(f)) then read(f, cabecera);
    if (cabecera.dni < 0) then
    begin
        nLibre:= cabecera.dni * -1;
        seek(f, nLibre); read(f, cabecera);
        seek(f, 0); write(f, cabecera);
        seek(f, nLibre);
    end else seek(f, filesize(f));
    write(f, reg);
    close(f);
end;

procedure eliminar (var f: fPersona; dni: Integer);
var
    reg, cabecera: rPersona;
    nLibre: Integer;
begin
    reset(f);
    if (not eof(f)) then read(f, cabecera);
    reg.dni:= -1;
    while (not eof(f) and (reg.dni <> dni)) do read(f, reg);
    if (reg.dni = dni) then
    begin
        nLibre:= filepos(f) - 1;
        seek(f, nLibre); write(f, cabecera);
        cabecera.dni:= nLibre * -1;
        seek(f, 0);
        write(f, cabecera);
    end else writeln('No se encontro la persona con dni ', dni);
end;

procedure imprimirArchivo(var f: fPersona);
var
    reg: rPersona;
begin
    reset(f);
    while (not eof(f)) do
    begin
        read(f, reg);
        writeln('Dni: ', reg.dni);
        writeln('Nombre: ', reg.nombre);
        writeln('Apellido: ', reg.apellido);
        writeln('Sueldo: ', reg.sueldo);
    end;
    close(f);
end;

var
    f: fPersona;
    fText: Text;
    reg: rPersona;
begin
    assign(f, 'personas.dat');
    assign(fText, 'personas.txt');
    crear(f, fText);
    imprimirArchivo(f);
    writeln('-----------------------------------------------');
    writeln('Ingrese el dni: ');
    readln(reg.dni);
    writeln('Ingrese el nombre: ');
    readln(reg.nombre);
    writeln('Ingrese el apellido: ');
    readln(reg.apellido);
    writeln('Ingrese el sueldo: ');
    readln(reg.sueldo);
    agregar(f, reg);
    writeln('Ingrese el dni a eliminar: ');
    readln(reg.dni);
    writeln('-----------------------------------------------');
    eliminar(f, reg.dni);
    imprimirArchivo(f);
    writeln('-----------------------------------------------');
end.

