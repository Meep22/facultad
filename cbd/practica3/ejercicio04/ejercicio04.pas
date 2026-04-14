program ejercicio04;
//n código único, nombre álbum, género,artista una descripción
//asociada, año de edición y cantidad de copias en stock
type
    rDisco = record
        codigo: Integer;
        nombre: String[20];
        genero: String[20];
        descripcion: String[50];
        edicion: Integer;
        stock: Integer;
    end;

    fDisco = File of rDisco;

procedure marcarDisco(var f: fDisco; codigo: Integer);
var
    reg: rDisco;
begin
    reset(f);
    reg.codigo:= -1;
    while (not eof(f) and (reg.codigo <> codigo)) do read(f, reg);
    if (reg.codigo = codigo) then
    begin
        reg.stock:= 0;
        seek(f, filepos(f) - 1);
        write(f, reg);
    end else writeln('No se encontro el dico con codigo ', codigo);
    close(f);
end;

procedure compactarPorIntercambio(var f: fDisco);
var
    reg, ultimoReg: rDisco;
    posActual: integer;
begin
    reset(f);
    posActual := 0;
    while (posActual < filesize(f)) do
    begin
        seek(f, posActual);
        read(f, reg);
        if (reg.stock = 0) then
        begin
            seek(f, filesize(f) - 1);
            read(f, ultimoReg);
            if (posActual < filesize(f) - 1) then
            begin
                seek(f, posActual);
                write(f, ultimoReg);
                seek(f, filesize(f) - 1);
                truncate(f);
                continue;
            end
            else begin
                seek(f, posActual);
                truncate(f);
            end;
        end;
        posActual := posActual + 1;
    end;
    close(f);
end;

procedure imprimirArchivo(var f: fDisco);
var
    reg: rDisco;
begin
    reset(f);
    while (not eof(f)) do
    begin
        read(f, reg);
        writeln('Codigo: ', reg.codigo);
        writeln('Nombre: ', reg.nombre);
        writeln('Genero: ', reg.genero);
        writeln('Descripcion: ', reg.descripcion);
        writeln('Edicion: ', reg.edicion);
        writeln('Stock: ', reg.stock);
        writeln('--------------------------------------');
    end;
    close(f);
end;

var
    f: fDisco;
    cod: Integer;
begin
    assign(f, 'discos.dat');
    imprimirArchivo(f);
    writeln('--------------------------------------');
    writeln('Ingrese el codigo a marcar (-1 para finalizar): ');
    readln(cod);
    while (cod <> -1) do
    begin
        marcarDisco(f, cod);
        writeln('Ingrese el codigo a marcar (-1 para finalizar): ');
        readln(cod);
    end;
    writeln('--------------------------------------');
    imprimirArchivo(f);
    compactarPorIntercambio(f);
    writeln('--------------------------------------');
    writeln('--------------------------------------');
    imprimirArchivo(f);
end.
