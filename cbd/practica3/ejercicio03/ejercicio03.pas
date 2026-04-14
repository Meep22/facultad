program ejercicio03;
type
    rProducto = record
        codigo: Integer;
        nombre: String[20];
        descri: String[50];
        stock: Integer;
    end;

    fProducto = File of rProducto;

procedure crearBinario(var fTexto: Text; var f: fProducto);
var
    reg: rProducto;
begin
    reset(fTexto);
    rewrite(f);
    while (not eof(fTexto)) do
    begin
        readln(fTexto, reg.codigo, reg.nombre);
        readln(fTexto, reg.descri);
        readln(fTexto, reg.stock);
        write(f, reg);
    end;
    close(f);
    close(fTexto);
end;

procedure marcar(var f: fProducto; codigo: Integer);
var
    reg: rProducto;
begin
    reset(f);
    if (not eof(f)) then read(f, reg);
    while (not eof(f) and (reg.codigo <> codigo)) do read(f, reg);
    if (reg.codigo = codigo) then
    begin
        reg.stock:= -1;
        seek(f, filepos(f) - 1);
        write(f, reg);
    end;
    close(f);
end;

procedure agregarSobreMarca(var f: fProducto; reg: rProducto);
var
    aux: rProducto;
begin
    reset(f);
    if (not eof(f)) then read(f, aux);
    while(not eof(f) and (aux.stock <> -1)) do read(f, aux);
    if (aux.stock = -1) then
    begin
        seek(f, filepos(f) - 1);
        write(f, reg);
    end else
    begin
        seek(f, filesize(f));
        write(f, reg);
    end;
    close(f);
end;

procedure bajaListaInvertida(var f: fProducto; codigo: Integer);
var
    reg, cabecera: rProducto;
    pos: Integer;
begin
    reset(f);
    if (not eof(f)) then read(f, cabecera);
    reg.codigo:= -1;
    while (not eof(f) and (reg.codigo <> codigo)) do read(f, reg);
    if (reg.codigo = codigo) then
    begin
        pos:= filepos(f) - 1;
        seek(f,pos);
        write(f, cabecera);
        seek(f,0);
        cabecera.stock:= pos;
        write(f,cabecera);
    end;
    close(f);
end;

procedure altaListaInvertida(var f: fProducto; reg: rProducto);
var
    cabecera: rProducto;
    pos: Integer;
begin
    reset(f);
    if (not eof(f)) then read(f, cabecera);
    if (cabecera.stock = 0) then seek(f, filesize(f))
    else begin
        pos:= cabecera.stock;
        seek(f, pos);
        read(f, cabecera);
        seek(f, 0);
        write(f, cabecera);
        seek(f, pos);
    end;
    write(f, reg);
    close(f);
end;

procedure crearBinarioParaListaInvertida(var fTexto: Text; var f: fProducto);
var
    reg: rProducto;
begin
    reset(fTexto);
    rewrite(f);
    reg.codigo:= -1;
    reg.stock:= 0;
    write(f, reg);
    while (not eof(fTexto)) do
    begin
        readln(fTexto, reg.codigo, reg.nombre);
        readln(fTexto, reg.descri);
        readln(fTexto, reg.stock);
        write(f, reg);
    end;
    close(f);
    close(fTexto);
end;

procedure imprimirArchivo(var f:fProducto);
var
    reg: rProducto;
begin
    reset(f);
    while(not eof(f)) do
    begin
        read(f, reg);
        writeln('Codigo: ', reg.codigo);
        writeln('Nombre: ', reg.nombre);
        writeln('Descripcion: ', reg.descri);
        writeln('Stock: ', reg.stock);
        writeln('-------------------------------------');
    end;
    close(f);
end;

var
    nue: rProducto;
    f: fProducto;
    fTexto: Text;
begin
    assign(f, 'productos.dat');
    assign(fTexto,'productos.txt');
    crearBinarioParaListaInvertida(fTexto, f);
    imprimirArchivo(f);
    bajaListaInvertida(f, 101);
    bajaListaInvertida(f, 104);
    bajaListaInvertida(f, 108);
    writeln('-----------------------------');
    imprimirArchivo(f);
    nue.codigo:= 201;
    nue.nombre:= 'producto';
    nue.descri:= 'descripcion del producto';
    nue.stock:= 202;
    altaListaInvertida(f, nue);
    writeln('-----------------------------');
    imprimirArchivo(f);
end.
