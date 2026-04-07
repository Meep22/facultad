program generador;
const
    VALOR_ALTO = 9999;
type
    rMozo = record
        codigo: Integer;
        fecha: LongInt;
        monto: Real;
    end;
    fMozo = file of rMozo;

var
    f: fMozo;
    reg: rMozo;
begin
    assign(f, 'detalle.dat');
    rewrite(f);

    { Mozo 1 - 3 registros (debe sumarlos) }
    reg.codigo := 1; reg.fecha := 20260331; reg.monto := 100.50; write(f, reg);
    reg.codigo := 1; reg.fecha := 20260331; reg.monto := 50.00;  write(f, reg);
    reg.codigo := 1; reg.fecha := 20260331; reg.monto := 25.25;  write(f, reg);

    { Mozo 2 - 1 registro }
    reg.codigo := 2; reg.fecha := 20260331; reg.monto := 500.00; write(f, reg);

    { Mozo 5 - 2 registros (salteamos el 3 y 4 para probar que funciona) }
    reg.codigo := 5; reg.fecha := 20260331; reg.monto := 10.00;  write(f, reg);
    reg.codigo := 5; reg.fecha := 20260331; reg.monto := 10.00;  write(f, reg);

    close(f);
    writeln('Archivo detalle.dat generado con exito.');
end.
