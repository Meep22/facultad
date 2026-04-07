program ejercicio3;
const
    VALOR_ALTO = 9999;
    CANT_LOCALES = 3;
type
    rVentas = record
        codigo: Integer;
        numero: Integer;
        cantVe: Integer;
    end;

    rMaestro = record
        codigo: Integer;
        numero: Integer;
        desc: String[50];
        pu: Real;
        color: String[10];
        stockDis: Integer;
        stockMin: Integer;
    end;

    fMaestro= File of rMaestro;
    fVentas= File of rVentas;
    sinStock= Text;
    afVentas= Array[1..CANT_LOCALES] of fVentas;
    arVentas= Array[1..CANT_LOCALES] of rVentas;


procedure leer(var fVen: fVentas; var rVen: rVentas);
begin
    if (not eof(fVen)) then
        read(fVen, rVen)
    else
        rVen.codigo:= VALOR_ALTO;
end;

procedure minimo(var afDet: afVentas; var arDet: arVentas; var min: rVentas);
var
    posMin: Integer;
    i: Integer;
begin
    min.codigo:= VALOR_ALTO;
    posMin:= VALOR_ALTO;
    posMin:= -1;
    for i:= 1 to CANT_LOCALES do
    begin
        if ((arDet[i].codigo < min.codigo) or
            ((arDet[i].codigo = min.codigo) and
            (arDet[i].numero < min.numero))) then
        begin
            min:= arDet[i];
            posMin:= i;
        end;
    end;
    if (posMin <> -1)then
        leer(afDet[posMin], arDet[posMin]);
end;

procedure abrirDetalles(var afDet: afVentas);
var
    i: Integer;
    nro: String[2];
begin
    for i:= 1 to CANT_LOCALES do
    begin
        Str(i, nro);
        assign(afDet[i], 'ventas' + nro + '.dat');
        reset(afDet[i]);
    end;
end;

procedure cerrarDetalles(var afDet: afVentas);
var
    i: Integer;
begin
    for i:= 1 to CANT_LOCALES do
    begin
        close(afDet[i]);
    end;
end;

procedure actualizar(var fMas: fMaestro; var afDet: afVentas);
var
    rMas: rMaestro;
    arDet: arVentas;
    min: rVentas;
    fSinStock: sinStock;
    i: Integer;
begin
    assign(fSinStock, 'sinStock.txt');
    rewrite(fSinStock);
    abrirDetalles(afDet);
    for i:= 1 to CANT_LOCALES do
        leer(afDet[i], arDet[i]);
    minimo(afDet, arDet, min);
    reset(fMas);
    read(fMas, rMas); // por precondicion el archivo tiene elementos, leo sin verificar
    while (min.codigo <> VALOR_ALTO) do
    begin
        // Busco el calzado con codigo y numero igual al que recibo por detalle
        while ((rMas.codigo <> min.codigo) or (rMas.numero <> min.numero)) do
        begin
            writeln('El calzado con codigo ', rMas.codigo, ' en talle ',
                    rMas.numero, ' no tuvo ventas');
            read(fMas, rMas);
        end;
        // Cuando salgo del while el fMas tiene el puntero una posicion por
        // delante del primer registro con el codigo y numero correcto
        // El rMas tiene el registro a modificar

        // Proceso todos los calzados que tienen el mismo codigo y el mismo
        // talle
        while ((min.codigo = rMas.codigo) and (min.numero = rMas.numero))do
        begin
            rMas.stockDis:= rMas.stockDis - min.cantVe;
            minimo(afDet, arDet, min);
        end;

        if (rMas.stockDis < rMas.stockMin) then
        begin
            writeln(fSinStock, 'Codigo: ', rMas.codigo, ' Talle: ', rMas.numero);
        end;
        seek(fMas, filepos(fMas) - 1);
        write(fMas, rMas);
        if (not eof(fMas)) then
            read(fMas, rMas);
    end;
    cerrarDetalles(afDet);
    close(fSinStock);
    while (not eof(fMas)) do
    begin
        writeln('El calzado con codigo ', rMas.codigo, ' en talle ',
            rMas.numero, ' no tuvo ventas');
        read(fMas, rMas);
    end;
    close(fMas);
end;

procedure imprimirMaestro(var fMas: fMaestro);
var
    rMas: rMaestro;
begin
    reset(fMas);
    writeln;
    writeln('==============================================================================');
    writeln('                               ARCHIVO MAESTRO                                ');
    writeln('==============================================================================');
    { Definimos encabezados con los mismos anchos que usaremos abajo }
    { Así sí funciona: cada coma separa un elemento al que le podés dar formato }
writeln(' CODIGO | ', 'DESCRIPCION':20, ' | ', 'TALLE':5, ' | ', 'STOCK':6, ' | ', 'MINIMO':6);
    writeln('--------|----------------------|-------|--------|--------');

    while (not eof(fMas)) do
    begin
        read(fMas, rMas);
        { Usamos :N para definir el ancho de cada celda }
        writeln(
            rMas.codigo    : 7, ' | ',
            rMas.desc      : 20, ' | ',
            rMas.numero    : 5,  ' | ',
            rMas.stockDis  : 6,  ' | ',
            rMas.stockMin  : 6
        );
    end;
    writeln('==============================================================================');
    writeln;
    close(fMas);
end;

var
    fMas: fMaestro;
    afDet: afVentas;
begin
    assign(fMas, 'maestro.dat');
    imprimirMaestro(fMas);
    actualizar(fMas, afDet);
    imprimirMaestro(fMas);
end.
