program ejercicio1;
{De cada especie se almacena: código especie, nombre vulgar, nombre científico, altura
promedio, descripción y zona geográfica}
type
    rEspecie = record
        codigo: Integer;
        nombreVulgar: String[20];
        nombreCientifico: String[20];
        altura: Real;
        descripcion: String[50];
        zona: String[50];
    end;

    fEspecie = File of rEspecie;

procedure bajaLogica(var f: fEspecie);
var
    rEsp, rBorrar: rEspecie;
    fNuevo: fEspecie;
begin
    writeln('Ingrese el codigo a eliminar (1000 para finalizar)');
    readln(rBorrar.codigo);
    while (rBorrar.codigo <> 1000) do
    begin
        reset(f);
        if (not eof(f)) then read(f, rEsp);

        while ((not eof(f)) and (rEsp.codigo <> rBorrar.codigo)) do
        begin
            read(f, rEsp);
        end;
        if (rBorrar.codigo <> rEsp.codigo) then writeln('No se encontro la planta con codigo ', rBorrar.codigo);
        if (rEsp.codigo = rBorrar.codigo) then
            rEsp.codigo:= -1;
        seek(f, filepos(f) - 1);
        write(f, rEsp);
        writeln('Ingrese el codigo a eliminar (1000 para finalizar)');
        readln(rBorrar.codigo);
    end;
    assign(fNuevo, 'archivoNuevo.dat');
    rewrite(fNuevo);
    reset(f);
    while (not eof(f)) do
    begin
        read(f, rEsp);
        if (rEsp.codigo <> -1) then
            write(fNuevo, rEsp)
    end;
//    f:= fNuevo;
    close(f);
    close(fNuevo);
end;

procedure bajaConReemplazo(var f: fEspecie);
var
    rBorrar, rEsp: rEspecie;
    posBorrar: Integer;
begin
    writeln('Ingrese el codigo a eliminar (1000 para finalizar)');
    readln(rBorrar.codigo);
    while (rBorrar.codigo <> 1000) do
    begin
        reset(f);
        if (not eof(f)) then read(f, rEsp);
        while (not eof(f) and (rEsp.codigo <> rBorrar.codigo)) do
        begin
            read(f, rEsp);
        end;
        if (rBorrar.codigo <> rEsp.codigo) then writeln('No se encontro la planta con codigo ', rBorrar.codigo);
        if (rEsp.codigo = rBorrar.codigo) then
        begin
            posBorrar:= filepos(f) - 1;
            seek(f, filesize(f) - 1);
            read(f, rEsp);
            seek(f, posBorrar);
            write(f, rEsp);
            seek(f, filesize(f) - 1);
            truncate(f);
        end;
        writeln('Ingrese el codigo a eliminar (1000 para finalizar)');
        readln(rBorrar.codigo);
    end;
    close(f);
end;

procedure imprimirArchivo(var f: fEspecie);
var
    rEsp: rEspecie;
begin
    reset(f);
    while (not eof(f)) do
    begin
        read(f, rEsp);
        writeln('Codigo: ', rEsp.codigo);
        writeln('Nombre Vulgar: ', rEsp.nombreVulgar);
        writeln('Nombre Cientifico: ', rEsp.nombreCientifico);
        writeln('Altura: ', rEsp.Altura:0:2);
        writeln('Descripcion: ', rEsp.Descripcion);
        writeln('Zona: ', rEsp.Zona);
    end;
    close(f);
end;

var
    f, fNuevo: fEspecie;
begin
    assign(f, 'especies.dat');
    writeln('ARCHIVO ORIGINAL: ');
    imprimirArchivo(f);
    bajaLogica(f);

    writeln('ARCHIVO DESPUES DE BAJA LOGICA: ');
    assign(fNuevo, 'archivoNuevo.dat');
    imprimirArchivo(fNuevo);

    // Queda un registro con codigo -1 porque se borra sobre el archivo
    // original, no sobre el creado por 'bajaLogica'
    bajaConReemplazo(f);
    writeln('ARCHIVO DESPUES DE BAJA CON REEMPLAZO: ');
    imprimirArchivo(f);
end.
