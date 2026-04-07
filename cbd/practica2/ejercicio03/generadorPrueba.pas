program GeneradorPrueba;

const
    VALOR_ALTO = 9999;
    CANT_DETALLES = 3;

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

    fMaestro = File of rMaestro;
    fVentas = File of rVentas;

var
    archM: fMaestro;
    archD: fVentas;
    regM: rMaestro;
    regV: rVentas;
    i: Integer;
    nro: String[2];

begin
    { --- 1. GENERAR MAESTRO --- }
    assign(archM, 'maestro.dat');
    rewrite(archM);

    { Registro 1: Adidas Samba Talle 40 }
    regM.codigo := 100; regM.numero := 40; regM.desc := 'Adidas Samba';
    regM.pu := 120.50; regM.color := 'Blanco'; regM.stockDis := 20; regM.stockMin := 5;
    write(archM, regM);

    { Registro 2: Nike Air Talle 42 }
    regM.codigo := 200; regM.numero := 42; regM.desc := 'Nike Air';
    regM.pu := 150.00; regM.color := 'Negro'; regM.stockDis := 15; regM.stockMin := 10;
    write(archM, regM);

    { Registro 3: Puma Clyde Talle 38 }
    regM.codigo := 300; regM.numero := 38; regM.desc := 'Puma Clyde';
    regM.pu := 90.00; regM.color := 'Rojo'; regM.stockDis := 10; regM.stockMin := 2;
    write(archM, regM);

    close(archM);
    writeln('Archivo maestro.dat generado.');

    { --- 2. GENERAR 3 DETALLES --- }
    { Detalle 1: Vende del codigo 100 y 300 }
    assign(archD, 'ventas1.dat');
    rewrite(archD);
    regV.codigo := 100; regV.numero := 40; regV.cantVe := 2; write(archD, regV);
    regV.codigo := 300; regV.numero := 38; regV.cantVe := 1; write(archD, regV);
    close(archD);

    { Detalle 2: Vende del codigo 100 y 200 }
    assign(archD, 'ventas2.dat');
    rewrite(archD);
    regV.codigo := 100; regV.numero := 40; regV.cantVe := 3; write(archD, regV);
    regV.codigo := 200; regV.numero := 42; regV.cantVe := 6; write(archD, regV);
    close(archD);

    { Detalle 3: Vende del codigo 200 }
    assign(archD, 'ventas3.dat');
    rewrite(archD);
    regV.codigo := 200; regV.numero := 42; regV.cantVe := 2; write(archD, regV);
    close(archD);

    writeln('Archivos de ventas (1, 2 y 3) generados correctamente.');
end.
