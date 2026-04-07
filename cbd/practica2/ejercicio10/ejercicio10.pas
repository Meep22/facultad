program ejercicio10;
const
    VALOR_ALTO=9999;
    CANT_SUC= 8;
type
    rProducto = record
        codigo: Integer;
        nombre: String[20];
        desc: String[20];
        precio: Real;
        cant: Integer;
        cantMax: Integer;
    end;
    fProducto = File of rProducto;

    rVenta = record
        codigo: Integer;
        cant: Integer;
    end;
    fVenta = File of rVenta;
    afVenta = Array[1..CANT_SUC] of fVenta;
    arVenta = Array[1..CANT_SUC] of rVenta;

procedure leerVenta(var fDet: fVenta; var rDet: rVenta);
begin
    if (not eof(fDet)) then
    begin
        read(fDet, rDet);
    end
    else begin
        rDet.codigo:= VALOR_ALTO;
    end;
end;

procedure minimo(var afDet: afVenta; var arDet: arVenta; var min: rVenta);
var
    posMin: Integer;
    i: Integer;
begin
    posMin:= -1;
    min.codigo:= VALOR_ALTO;
    for i:=1 to CANT_SUC do
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
    rMas: rProducto;
    arDet: arVenta;
    min: rVenta;
    i: Integer;
begin
    for i:= 1 to CANT_SUC do
    begin
        reset(afDet[i]);
        leerVenta(afDet[i], arDet[i]);
    end;
    reset(fMas);
    if (not eof(fMas)) then
        read(fMas, rMas);
    minimo(afDet, arDet, min);
    while (min.codigo <> VALOR_ALTO) do
    begin
        while (rMas.codigo <> min.codigo) do
        begin
            read(fMas, rMas);
        end;
        while (rMas.codigo = min.codigo) do
        begin
            writeln('Encontre el codigo ', min.codigo);
            rMas.cant:= rMas.cant + min.cant;
            minimo(afDet, arDet, min);
        end;
        if (rMas.cant > rMas.cantMax) then
        begin
            writeln('---------------------------------------------');
            writeln('---------------------------------------------');
            writeln('---------------------------------------------');
            writeln('Codigo: ', rMas.codigo);
            writeln('Nombre: ', rMas.nombre);
            writeln('Cantidad maxima anterior: ', rMas.cantMax);
            writeln('Cantidad maxima actual: ', rMas.cant);
            writeln('---------------------------------------------');
            writeln('---------------------------------------------');
            writeln('---------------------------------------------');
            rMas.cantMax:= rMas.cant;
        end;
        seek(fMas, filepos(fMas) - 1);
        write(fMas, rMas);
    end;
    close(fMas);
    for i:=1 to CANT_SUC do
    begin
        close(afDet[i]);
    end;
end;

procedure imprimirDetalles(var afDet: afVenta);
var
    rDet: rVenta;
    i: Integer;
begin
    for i:=1 to CANT_SUC do
    begin
        reset(afDet[i]);
        writeln('ARCHIVO ', i);
        while (not eof(afDet[i])) do
        begin
            read(afDet[i], rDet);
            writeln('Codigo: ', rDet.codigo);
            writeln('Cantidad vendida: ', rDet.cant);
        end;
        writeln('Fin de archivo ', i);
        close(afDet[i]);
    end;
end;

procedure imprimirMaestro(var fMas: fProducto);
var
    rMas: rProducto;
begin
    reset(fMas);
    while (not eof(fMas)) do
    begin
        read(fMas, rMas);
        writeln('-------------------------------------------------');
        writeln('Codigo: ', rMas.codigo);
        writeln('Nombre: ', rMas.nombre);
        writeln('Descripcion: ', rMas.desc);
        writeln('Precio: ', rMas.precio);
        writeln('Cantidad vendida: ', rMas.cant);
        writeln('Cantidad vendida maxima: ', rMas.cantMax);
        writeln('-------------------------------------------------');
    end;
    close(fMas);
end;

var
    fMas: fProducto;
    afDet: afVenta;
    i: Integer;
    nro: String[1];
begin
    for i:=1 to CANT_SUC do
    begin
        str(i,nro);
        assign(afDet[i], 'detalle' + nro + '.dat');
    end;
    assign(fMas, 'maestro.dat');
    imprimirDetalles(afDet);
    imprimirMaestro(fMas);
    actualizarMaestro(fMas, afDet);
    imprimirMaestro(fMas);
end.
