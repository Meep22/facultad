program GenerarRiesgo;

type
    rRiesgo = record
        partido: String[15];
        localidad: String[15];
        barrio: String[15];
        cantNi: Integer;
        cantAd: Integer;
    end;

    fRiesgo = file of rRiesgo;

var
    f: fRiesgo;
    r: rRiesgo;

procedure cargar(p, l, b: string; ni, ad: integer);
begin
    r.partido := p;
    r.localidad := l;
    r.barrio := b;
    r.cantNi := ni;
    r.cantAd := ad;
    write(f, r);
end;

begin
    assign(f, 'riesgo.dat');
    rewrite(f);

    // --- PARTIDO 1: Avellaneda ---
    // Localidad: Piñeyro (2 barrios)
    cargar('Avellaneda', 'Piñeyro', 'Barrio Centro', 10, 5);
    cargar('Avellaneda', 'Piñeyro', 'Barrio Sur', 15, 10);
    // Localidad: Wilde (1 barrio)
    cargar('Avellaneda', 'Wilde', 'Las Flores', 30, 20);

    // --- PARTIDO 2: Quilmes ---
    // Localidad: Bernal (2 barrios)
    cargar('Quilmes', 'Bernal', 'Barrio Parque', 100, 50);
    cargar('Quilmes', 'Bernal', 'Villa Italia', 20, 10);
    // Localidad: Ezpeleta (1 barrio)
    cargar('Quilmes', 'Ezpeleta', 'Barrio Luz', 45, 30);

    // --- PARTIDO 3: Zarate (Para probar el VALOR_ALTO 'zzz') ---
    cargar('Zarate', 'Centro', 'Unico', 1, 1);

    close(f);
    writeln('Archivo "riesgo.dat" generado correctamente.');
    writeln('Ejecuta ahora tu "ejercicio5" para ver el reporte.');
end.
