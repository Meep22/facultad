program ejercicio05;
type
//De cada artículo se almacena: nro de artículo, descripción, color, talle,
//stock disponible y precio del producto.

    rArticulo = record
        codigo: Integer;
        descripcion: String[50];
        color: String[15];
        talle: Integer;
        stock: Integer;
        precio: Real;
    end;
    fArticulo = File of rArticulo;

procedure bajaLogica(var f: fArticulo);
var
    reg: rArticulo;
    codigo: Integer;
    fText: Text;
begin
    assign(fText, 'borrados.txt');
    rewrite(fText);
    writeln('Ingrese el codigo a eliminar (-1 para finalizar): ');
    readln(codigo);
    while (codigo <> -1) do
    begin
        reset(f);
        if (not eof(f)) then read(f, reg);
        while (not eof(f) and (reg.codigo < codigo)) do read(f, reg);
        if (reg.codigo = codigo) then
        begin
            writeln(fText, reg.codigo, ' ', reg.descripcion);
            writeln(fText, reg.color);
            writeln(fText, reg.talle, ' ', reg.stock, ' ', reg.precio:0:2);

            reg.codigo:= -1;
            seek(f, filepos(f) - 1);
            write(f, reg);
        end else writeln('No se encontro el producto con codigo ', codigo, ' Ingrese un codigo valido.');

        writeln('Ingrese el codigo a eliminar (-1 para finalizar): ');
        readln(codigo);
    end;
    close(fText);
    close(f);
end;

procedure compactarArchivo(var f: fArticulo);
var
    reg: rArticulo;
    aux: fArticulo;
begin
    reset(f);
    assign(aux, 'articulosCompactado.dat');
    rewrite(aux);
    while (not eof(f)) do
    begin
        read(f, reg);
        if(reg.codigo <> -1) then write(aux, reg);
    end;
    close(f);
    close(aux);
    erase(f);
    rename(aux, 'articulos.dat');
    assign(f, 'articulos.dat');
end;

procedure imprimirArchivo(var f:fArticulo);
var
    reg: rArticulo;
begin
    reset(f);
    while (not eof(f)) do
    begin
        read(f, reg);
        writeln('Codigo: ', reg.codigo);
        writeln('Descripcion: ', reg.descripcion);
        writeln('Color: ', reg.color);
        writeln('Talle: ', reg.talle);
        writeln('Stock: ', reg.stock);
        writeln('Precio: ', reg.precio:0:2);
    end;
    close(f);
end;

var
    f: fArticulo;
begin
    assign(f, 'articulos.dat');
    imprimirArchivo(f);
    bajaLogica(f);
    writeln('--------------------------');
    imprimirArchivo(f);
    compactarArchivo(f);
    writeln('--------------------------');
    imprimirArchivo(f);
end.

