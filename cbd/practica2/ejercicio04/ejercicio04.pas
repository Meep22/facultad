program ejercicio4;
const
    VALOR_ALTO = 9999;
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
    afPelicula = Array[1..CANT_CINES] of fPelicula;
    arPelicula = Array[1..CANT_CINES] of rPelicula;

procedure leer(var fDet: fPelicula; var rDet: rPelicula);
begin
    if (not eof(fDet)) then
        read(fDet, rDet)
    else
        rDet.codigo:= VALOR_ALTO;
end;

procedure abrirDetalles(var afDet: afPelicula; var arDet: arPelicula);
var
    i: Integer;
    nro: String[2];
begin
    for i:= 1 to CANT_CINES do
    begin
        Str(i,nro);
        assign(afDet[i],'cine' + nro + '.dat');
        reset(afDet[i]);
        leer(afDet[i], arDet[i]);
    end;
end;

procedure cerrarDetalles(var afDet: afPelicula);
var
    i: Integer;
begin
    for i:= 1 to CANT_CINES do
    begin
        close(afDet[i]);
    end;
end;

procedure minimo(var afDet: afPelicula; var arDet: arPelicula;
    var min: rPelicula);
var
    i: Integer;
    posMin: Integer;
begin
    posMin:= -1;
    min.codigo:= VALOR_ALTO;
    for i:=1 to CANT_CINES do
    begin
        if (arDet[i].codigo < min.codigo) then
        begin
            posMin:= i;
            min:= arDet[i];
        end;
    end;
    if (posMin <> -1) then
        leer(afDet[posMin], arDet[posMin]);
end;

procedure generarMaestro(var afDet: afPelicula; ruta: String);
var
    rMas: rPelicula;
    fMas: fPelicula;
    arDet: arPelicula;
    min: rPelicula;
begin
    assign(fMas, ruta);
    rewrite(fMas);
    abrirDetalles(afDet, arDet);
    minimo(afDet, arDet, min);
    while (min.codigo <> VALOR_ALTO) do
    begin
        rMas:= min;
        rMas.cantAsis:= 0;
        while (min.codigo = rMas.codigo) do
        begin
            rMas.cantAsis:= rMas.cantAsis + min.cantAsis;
            minimo(afDet, arDet, min);
        end;
        write(fMas, rMas);
    end;
    close(fMas);
    cerrarDetalles(afDet);
end;

procedure imprimirMaestro(var fMas: fPelicula);
var
    rMas: rPelicula;
begin
    reset(fMas);
    writeln;
    writeln('==============================================================================');
    writeln('                               ARCHIVO MAESTRO                                ');
    writeln('==============================================================================');
    { Definimos encabezados con los mismos anchos que usaremos abajo }
    { Así sí funciona: cada coma separa un elemento al que le podés dar formato }
    writeln(' CODIGO | ', 'NOMBRE':10, ' | ', 'GENERO':10, ' | ', 'DIRECTOR':10, ' | ', 'ASISTENTES':10);
    writeln('--------|------------|------------|------------|-----------');

    while (not eof(fMas)) do
    begin
        read(fMas, rMas);
        { Usamos :N para definir el ancho de cada celda }
        writeln(
            rMas.codigo    : 7, ' | ',
            rMas.nomPeli   : 10, ' | ',
            rMas.genero    : 10,  ' | ',
            rMas.director  : 10,  ' | ',
            rMas.cantAsis  : 10
        );
    end;
    writeln('==============================================================================');
    writeln;
    close(fMas);
end;

var
    afDet: afPelicula;
    fMas: fPelicula;
    ruta: String;
begin
    writeln('ingrese la ruta del archivo maestro: ');
    readln(ruta);
    generarMaestro(afDet, ruta);
    assign(fMas, ruta);
    imprimirMaestro(fMas);
end.
