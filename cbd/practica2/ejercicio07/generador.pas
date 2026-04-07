program generador7;
uses sysutils;
const
    CANT_DET = 10;
type
    rProducto = record
        codigo: Integer;
        nombre: String[20];
        desc: String[50];
        precio: Real;
        stock: Integer;
        stockMin: Integer;
    end;
    rVenta = record
        codigo: Integer;
        cantidad: Integer;
    end;
    fVenta = file of rVenta;

var
    archTexto: Text;
    fDet: fVenta;
    regV: rVenta;
    i: Integer;
    nro: string;

begin
    { 1. Crear el archivo de texto "productos.txt" }
    assign(archTexto, 'productos.txt');
    rewrite(archTexto);
    { Formato: Codigo Nombre / Descripcion / Precio Stock StockMin }
    writeln(archTexto, '1 CocaCola');
    writeln(archTexto, 'Bebida de 1.5L');
    writeln(archTexto, '1500.50 100 10');

    writeln(archTexto, '2 Alfajor');
    writeln(archTexto, 'Alfajor de chocolate');
    writeln(archTexto, '800.00 50 5');

    writeln(archTexto, '5 Yerba');
    writeln(archTexto, 'Yerba Mate 1kg');
    writeln(archTexto, '4000.00 20 2');
    close(archTexto);
    writeln('Archivo productos.txt creado.');

    { 2. Crear los 10 archivos de detalle (detalle1.dat al detalle10.dat) }
    for i := 1 to CANT_DET do
    begin
        str(i, nro);
        assign(fDet, 'detalle' + nro + '.dat');
        rewrite(fDet);

        { Generamos ventas solo en algunos archivos para probar }
        if (i = 1) then begin
            regV.codigo := 1; regV.cantidad := 5; write(fDet, regV); { Venta de Coca en det 1 }
            regV.codigo := 5; regV.cantidad := 1; write(fDet, regV); { Venta de Yerba en det 1 }
        end;

        if (i = 2) then begin
            regV.codigo := 1; regV.cantidad := 10; write(fDet, regV); { Venta de Coca en det 2 }
        end;

        if (i = 10) then begin
            regV.codigo := 2; regV.cantidad := 2; write(fDet, regV); { Venta de Alfajor en det 10 }
        end;

        close(fDet);
    end;
    writeln('10 Archivos de detalle generados.');
end.
