program ejercicio6;
const
    VALOR_ALTO=9999;
type
    rMozo = record
        codigo: Integer;
        fecha: LongInt;
        monto: Real;
    end;

    fMozo = File of rMozo;


procedure leerMozo(var fDet: fMozo; var rDet: rMozo);
begin
    if (not eof(fDet)) then
        read(fDet, rDet)
    else
        rDet.codigo:= VALOR_ALTO;
end;

procedure crearMaestro(var fMas: fMozo; var fDet:fMozo);
var
    rMas: rMozo;
    rDet: rMozo;
begin
    reset(fDet);
    rewrite(fMas);
    leerMozo(fDet, rDet);
    while (rDet.codigo <> VALOR_ALTO) do
    begin
        rMas.codigo:= rDet.codigo;
        rMas.monto:= 0;
        while((rMas.codigo = rDet.codigo) and (rDet.codigo <> VALOR_ALTO)) do
        begin
            rMas.monto:= rMas.monto + rDet.monto;
            leerMozo(fDet, rDet);
        end;
        write(fMas, rMas);
    end;
    close(fDet);
    close(fMas);
end;

procedure imprimirArchivo(var f: fMozo);
var
    reg: rMozo;
begin
    reset(f);
    while (not eof(f)) do
    begin
        read(f,reg);
        writeln('Codigo: ', reg.codigo, ' Monto: ', reg.monto:0:2);
    end;
    close (f);
end;

var
    fDet: fMozo;
    fMas: fMozo;
begin
    assign(fDet, 'detalle.dat');
    assign(fMas, 'maestro.dat');
    writeln('Archivo detalle: ');
    imprimirArchivo(fDet);
    crearMaestro(fMas, fDet);
    writeln('Archivo maestro: ');
    imprimirArchivo(fMas);
end.
