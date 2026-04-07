program ejercicio5;
const
    VALOR_ALTO = 'zzz';
type
    rRiesgo = record
        partido: String[15];
        localidad: String[15];
        barrio: String[15];
        cantNi: Integer;
        cantAd: Integer;
    end;

    fRiesgo = file of rRiesgo;

procedure leer(var fMas: fRiesgo; var rMas: rRiesgo);
begin
    if (not eof(fMas)) then
        read(fMas, rMas)
    else
        rMas.partido:= VALOR_ALTO;
end;

procedure imprimirArchivo(var fMas: fRiesgo);
var
    rMas: rRiesgo;
    partAct: String[15];
    locaAct: String[15];
    cantPartNi: Integer; cantPartAd: Integer;
    cantLocaNi: Integer; cantLocaAd: Integer;
    cantProvNi: Integer; cantProvAd: Integer;
begin
    reset(fMas);
    leer(fMas, rMas);
    cantProvNi:= 0;
    cantProvAd:= 0;
    while (rMas.partido <> VALOR_ALTO) do
    begin
        writeln('Partido: ', rMas.partido);
        partAct:= rMas.partido;
        cantPartNi:= 0;
        cantPartAd:= 0;
        while (rMas.partido = partAct) do
        begin
            writeln('  Localidad: ', rMas.localidad);
            locaAct:= rMas.localidad;
            cantLocaNi:= 0;
            cantLocaAd:= 0;
            while ((rMas.partido = partAct) and (rMas.localidad = locaAct)) do
            begin
                writeln('   Cantidad ninos: ', rMas.cantNi, ' Cantidad adultos: ', rMas.cantAd);
                cantLocaNi:= cantLocaNi + rMas.cantNi;
                cantLocaAd:= cantLocaAd + rMas.cantAd;
                leer(fMas, rMas);
            end;
            writeln('  Total ninos localidad: ', cantLocaNi,' Total adultos localidad: ', cantLocaAd);
            cantPartNi:= cantPartNi + cantLocaNi;
            cantPartAd:= cantPartAd + cantLocaAd;
        end;
        writeln('TOTAL NINOS PARTIDO: ', cantPartNi, ' TOTAL ADULTOS PARTIDO: ', cantPartAd);
        cantProvNi:= cantProvNi + cantPartNi;
        cantProvAd:= cantProvAd + cantPartAd;
    end;
    writeln('TOTAL NINOS PROVINCIA: ', cantProvNi, ' TOTAL ADULTOS PROVINCIA: ', cantProvAd);
    close(fMas);
end;

var
    fMas: fRiesgo;
begin
    assign(fMas, 'riesgo.dat');
    imprimirArchivo(fMas);
end.
