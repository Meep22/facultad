program GeneradorCines;
uses sysutils;

const
    CANT_CINES = 3;

type
    rPelicula = record
        codigo: Integer;
        nomPeli: String[20];
        genero: String[20];
        director: String[20];
        duracion: Real;
        fecha: LongInt;
        cantAsis: Integer;
    end;

    fPelicula = file of rPelicula;

var
    vFD: array[1..CANT_CINES] of fPelicula;
    reg: rPelicula;
    i: integer;
    nro: string;

begin
    // 1. Crear y abrir los 3 archivos detalle
    for i := 1 to CANT_CINES do begin
        str(i, nro);
        assign(vFD[i], 'cine' + nro + '.dat');
        rewrite(vFD[i]);
    end;

    // --- CARGAR DATOS (Ordenados por codigo) ---

    // PELÍCULA 1: "Batman" (Está en los 3 cines)
    reg.codigo := 1; reg.nomPeli := 'Batman'; reg.cantAsis := 100;
    write(vFD[1], reg); // Cine 1 tiene 100
    reg.cantAsis := 50;
    write(vFD[2], reg); // Cine 2 tiene 50
    reg.cantAsis := 200;
    write(vFD[3], reg); // Cine 3 tiene 200
    // TOTAL ESPERADO EN MAESTRO: 350

    // PELÍCULA 2: "Duna" (Solo en Cine 1 y 3)
    reg.codigo := 2; reg.nomPeli := 'Duna'; reg.cantAsis := 80;
    write(vFD[1], reg);
    reg.cantAsis := 120;
    write(vFD[3], reg);
    // TOTAL ESPERADO EN MAESTRO: 200

    // PELÍCULA 3: "Star Wars" (Solo en Cine 2)
    reg.codigo := 3; reg.nomPeli := 'Star Wars'; reg.cantAsis := 500;
    write(vFD[2], reg);
    // TOTAL ESPERADO EN MAESTRO: 500

    for i := 1 to CANT_CINES do close(vFD[i]);
    writeln('Archivos cine1.dat, cine2.dat y cine3.dat creados.');
end.
