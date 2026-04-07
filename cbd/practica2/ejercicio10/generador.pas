program generador10;
uses sysutils;

const
    VALOR_ALTO = 9999;
    CANT_SUC = 8;

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

var
    fMas: fProducto;
    fDet: fVenta;
    p: rProducto;
    v: rVenta;
    i, j: Integer;
    nro: string;

begin
    Randomize;
    writeln('Generando Maestro...');
    assign(fMas, 'maestro.dat');
    rewrite(fMas);
    for i := 1 to 5 do begin
        p.codigo := i * 10; { Codigos: 10, 20, 30, 40, 50 }
        p.nombre := 'Producto ' + IntToStr(i);
        p.desc := 'Descripcion ' + IntToStr(i);
        p.precio := i * 100.5;
        p.cant := 0;      { Arranca en 0 ventas mensuales }
        p.cantMax := 50;  { Stock maximo historico para comparar }
        write(fMas, p);
    end;
    close(fMas);

    writeln('Generando 8 Detalles...');
    for i := 1 to CANT_SUC do begin
        str(i, nro);
        assign(fDet, 'detalle' + nro + '.dat');
        rewrite(fDet);

        { Generamos ventas solo para algunos productos para que esten ordenados }
        for j := 1 to 5 do begin
            { No todas las sucursales venden todos los productos }
            if (Random(10) > 3) then begin
                v.codigo := j * 10;
                v.cant := Random(15) + 1;
                write(fDet, v);
            end;
        end;
        close(fDet);
    end;
    writeln('Hecho. Ahora podes correr tu ejercicio10.');
end.
