//Los datos que contiene el archivo son: DNI,
//apellido, nombre, especialista y fecha
program adicional;
type
    rTurno = record
        dni: LongInt;
        apellido: String[20];
        nombre: String[20];
        especialista: String[20];
        fecha: String[10];
    end;

    fTurno = File of rTurno;

procedure altas(var f: fTurno);
var
    nuevo: rTurno;
    reg, cabecera: rTurno;
    nLibre: Integer;
begin
    cabecera.dni:= 0;
    rewrite(f);
    write(f, cabecera);
    close(f);
    writeln('Ingrese el dni (-1 para finalizar): ');
    readln(nuevo.dni);
    while (nuevo.dni <> -1) do
    begin
        writeln('Ingrese el nombre: ');
        readln(nuevo.nombre);
        writeln('Ingrese el apellido: ');
        readln(nuevo.apellido);
        writeln('Ingrese el especialista: ');
        readln(nuevo.especialista);
        writeln('Ingrese la fecha: ');
        readln(nuevo.fecha);
        reset(f);
        if (not eof(f)) then read(f, cabecera);
        if (cabecera.dni = 0) then seek(f, filesize(f))
        else begin
            nLibre:= cabecera.dni;
            seek(f,nLibre); read(f, cabecera);
            seek(f, 0); write(f, cabecera);
            seek(f, nLibre)
        end;
        write(f, nuevo);

        writeln('Ingrese el dni (-1 para finalizar): ');
        readln(nuevo.dni);
    end;
    close(f);
end;

procedure bajas(var f: fTurno);
var
    bajas: Text;
    bajar, reg, cabecera: rTurno;
    nLibre: Integer;
begin
    assign(bajas, 'bajas_del_dia.txt');
    reset(bajas);
    while (not eof(bajas)) do
    begin
        readln(bajas, bajar.dni, bajar.apellido);
        readln(bajas, bajar.nombre);
        readln(bajas, bajar.especialista);
        readln(bajas, bajar.fecha);
        reset(f);
        if (not eof(f)) then read(f, cabecera);
        reg.dni:= -1;
        while(not eof(f) and (reg.dni <> bajar.dni)) do read(f, reg);
        if(reg.dni = bajar.dni) then
        begin
            nLibre:= filepos(f) - 1;
            seek(f, nLibre); write(f, cabecera);
            cabecera.dni:= nLibre;
            seek(f, 0); write(f, cabecera);
        end else writeln('No se encontro el turno del paciente con DNI: ', reg.dni);
    end;
end;

procedure imprimirArchivo(var f: fTurno);
var
    reg: rTurno;
begin
    reset(f);
    while (not eof(f)) do
    begin
        read(f, reg);
        writeln('dni: ', reg.dni);
        writeln('Nombre: ', reg.nombre);
        writeln('Apellido: ', reg.apellido);
        writeln('Especialista: ', reg.especialista);
        writeln('Fecha: ', reg.fecha);
    end;
    close(f);
end;

var
    f: fTurno;

begin
    assign(f, 'turnos.dat');
    altas(f);
    imprimirArchivo(f);
    bajas(f);
    writeln('-------------------------------');
    imprimirArchivo(f);
end.
