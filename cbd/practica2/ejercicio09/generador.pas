program generador_running;
uses sysutils;

const
    CANT_DETALLES = 5;

type
    rCarrera = record
        dni: LongInt;
        apellido: String[20];
        nombre: String[20];
        km: Real;
        gano: Integer; { 1 si gano, 0 si no }
    end;
    fCarrera = File of rCarrera;

var
    fDet: fCarrera;
    reg: rCarrera;
    i: Integer;
    nro: string;

begin
    writeln('Generando 5 archivos de carreras para el mes de Abril...');

    for i := 1 to CANT_DETALLES do
    begin
        str(i, nro);
        assign(fDet, 'detalle' + nro + '.dat');
        rewrite(fDet);

        { Archivo 1: Corredores con DNIs bajos }
        if (i = 1) then
        begin
            reg.dni := 100; reg.apellido := 'Messi'; reg.nombre := 'Lionel';
            reg.km := 10.5; reg.gano := 1;
            write(fDet, reg);

            reg.dni := 300; reg.apellido := 'De Paul'; reg.nombre := 'Rodrigo';
            reg.km := 12.0; reg.gano := 0;
            write(fDet, reg);
        end;

        { Archivo 2: Mas carreras para los mismos o nuevos }
        if (i = 2) then
        begin
            reg.dni := 200; reg.apellido := 'Scaloni'; reg.nombre := 'Lionel';
            reg.km := 8.5; reg.gano := 1;
            write(fDet, reg);
        end;

        { Archivo 3: El DNI 100 corre otra carrera }
        if (i = 3) then
        begin
            reg.dni := 100; reg.apellido := 'Messi'; reg.nombre := 'Lionel';
            reg.km := 11.2; reg.gano := 1; { Aca ganaria su segunda carrera }
            write(fDet, reg);

            reg.dni := 400; reg.apellido := 'Alvarez'; reg.nombre := 'Julian';
            reg.km := 15.0; reg.gano := 1;
            write(fDet, reg);
        end;

        { Archivo 4 y 5: Algunos datos mas para completar las 5 carreras }
        if (i = 4) then
        begin
            reg.dni := 300; reg.apellido := 'De Paul'; reg.nombre := 'Rodrigo';
            reg.km := 10.0; reg.gano := 1;
            write(fDet, reg);
        end;

        { El detalle 5 lo dejamos vacio para probar que el codigo sea robusto }

        close(fDet);
    end;

    writeln('Archivos detalle1.dat a detalle5.dat generados con exito.');
    writeln('Recuerda: Los registros estan ordenados por DNI dentro de cada archivo.');
end.
