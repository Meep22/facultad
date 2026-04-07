program ejercicio7;
const
    CANT_DET = 10;
    VALOR_ALTO = 9999;
type
    rProducto = record
        codigo: Integer;
        nombre: String[20];
        desc: String[50];
        precio: Real;
        stock: Integer;
        stockMin: Integer;
    end;
    fProducto = File of rProducto;

    origen = Text;
    rVenta = record
        codigo: Integer;
        cantidad: Integer;
    end;
    fVenta = File of rVenta;
    afVenta = Array[1..CANT_DET] of fVenta;
    arVenta = Array[1..CANT_DET] of rVenta;
procedure leerVenta (var fDet: fVenta; var rDet: rVenta);
begin
    if (not eof(fDet)) then
        read(fDet, rDet)
    else
        rDet.codigo:= VALOR_ALTO;
end;

procedure crearMaestro(var fMas: fProducto);
var
    archivo: origen;
    rMas: rProducto;
begin
    assign(archivo, 'productos.txt');
    reset(archivo);
    rewrite(fMas);
    while (not eof(archivo)) do
    begin
        readln(archivo, rMas.codigo, rMas.nombre);
        readln(archivo, rMas.desc);
        readln(archivo, rMas.precio, rMas.stock, rMas.stockMin);
        write(fMas, rMas);
    end;
    close(fMas);
    close(archivo);
end;

procedure minimo(var afDet: afVenta; var arDet: arVenta; var min: rVenta);
var
    i: Integer;
    posMin: Integer;
begin
    min.codigo:= VALOR_ALTO;
    posMin:= -1;
    for i:=1 to CANT_DET do
    begin
        if (arDet[i].codigo < min.codigo) then
        begin
            posMin:= i;
            min:= arDet[i];
        end;
    end;
    if (posMin <> -1) then
    begin
        leerVenta(afDet[posMin], arDet[posMin]);
    end;
end;

procedure actualizarMaestro(var fMas: fProducto; var afDet: afVenta);
var
    arDet: arVenta;
    rMas: rProducto;
    rDet: rVenta;
    codAct: Integer;
    i: Integer;
begin
    // Abro archivos detalle e inicializo el vector de registros
    for i:= 1 to CANT_DET do
    begin
        reset(afDet[i]);
        leerVenta(afDet[i], arDet[i]);
    end;
    reset(fMas);
    minimo(afDet, arDet, rDet);
    if (not eof(fMas)) then
        read(fMas, rMas);
        while (rDet.codigo <> VALOR_ALTO) do
    begin
        codAct:= rDet.codigo;
        while ((not eof(fMas)) and (rMas.codigo <> rDet.codigo)) do
        begin
            read(fMas, rMas);
        end;
        // Salgo una posicion mas adelante del registro a actualizar
        // rMas tiene el registro a actualizar
        while (rDet.codigo = codAct) do
        begin
            rMas.stock:= rMas.stock - rDet.cantidad;
            minimo(afDet, arDet, rDet);
        end;
        seek(fMas, filepos(fMas) - 1);
        write(fMas, rMas);
    end;
    close(fMas);
    for i:=1 to CANT_DET do
        close(afDet[i])
end;

procedure imprimirMaestro(var fMas: fProducto);
var
    rMas:rProducto;
begin
    reset(fMas);
    while (not eof(fMas)) do
    begin
        read(fMas,rMas);
        writeln('-------------------------------------------');
        writeln('Codigo: ', rMas.codigo);
        writeln('Nombre: ', rMas.nombre);
        writeln('Precio: ', rMas.precio:0:2);
        writeln('Stock disponible: ', rMas.stock);
        writeln('Stock minimo: ', rMas.stockMin);
        writeln('-------------------------------------------');
    end;
    close(fMas);
end;

var
    afDet: afVenta;
    fMas: fProducto;
    i: Integer;
    opcion: Integer;
    nro:String[2];
begin
    assign(fMas, 'maestro.dat');
    writeln('Opcion 1: Crear archivo maestro');
    writeln('Opcion 2: Actualizar archivo maestro');
    writeln('Opcion 3: Imprimir archivo maestro');
    writeln('Opcion 0: Cerrar');
    writeln('');
    write('Opcion ');
    readln(opcion);
    while (opcion <> 0) do
    begin
        case opcion of
        1: crearMaestro(fMas);
        2: begin
            for i:=1 to CANT_DET do
            begin
                str(i,nro);
                assign(afDet[i], 'detalle' + nro + '.dat');
            end;
            actualizarMaestro(fMas, afDet);
        end;
        3: imprimirMaestro(fMas);
    end;
    write('Opcion ');
    readln(opcion);
end;
end.
