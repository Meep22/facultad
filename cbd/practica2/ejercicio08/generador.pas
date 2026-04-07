program generador8;
uses sysutils;

const
    CANT_ZONAS = 15;
    VALOR_ALTO = 9999;

type
    rZona = record
        codigo: Integer;
        nombre: String[20];
        desc: String [50];
        fecha: LongInt;
        metros: Real;
    end;
    fZona = File of rZona;

var
    fDet: fZona;
    reg: rZona;
    i: Integer;
    nro: string;

begin
    Randomize;
    writeln('Generando 15 archivos de detalle...');

    for i := 1 to CANT_ZONAS do
    begin
        str(i, nro);
        assign(fDet, 'detalle' + nro + '.dat');
        rewrite(fDet);

        { Insertamos datos de prueba }
        { Archivo 1 y 2 tienen la Zona 1 para probar la suma }
        if (i = 1) then
        begin
            reg.codigo := 1; reg.nombre := 'Palermo'; reg.desc := 'Zona Norte';
            reg.fecha := 20260331; reg.metros := 150.5;
            write(fDet, reg);

            reg.codigo := 10; reg.nombre := 'Recoleta'; reg.desc := 'Zona Centro';
            reg.fecha := 20260330; reg.metros := 80.0;
            write(fDet, reg);
        end;

        if (i = 2) then
        begin
            reg.codigo := 1; reg.nombre := 'Palermo'; reg.desc := 'Zona Norte';
            reg.fecha := 20260325; reg.metros := 50.0; { Deberia sumar 200.5 }
            write(fDet, reg);
        end;

        { El resto de los archivos tienen una zona unica segun su indice }
        if (i > 2) and (i <= 5) then
        begin
            reg.codigo := i * 10; { Zonas 30, 40, 50 }
            reg.nombre := 'Zona ' + nro;
            reg.desc := 'Descripcion de la zona ' + nro;
            reg.fecha := 20260101;
            reg.metros := 100.0 * i;
            write(fDet, reg);
        end;

        close(fDet);
    end;

    writeln('Hecho. Se crearon archivos detalle1.dat a detalle15.dat.');
    writeln('Nota: detalle6 a detalle15 estan vacios (solo EOF).');
end.
