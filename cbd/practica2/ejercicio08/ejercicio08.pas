program ejercicio8;
const
    VALOR_ALTO = 9999;
    CANT_ZONAS = 15;
type
    rZona = record
        codigo: Integer;
        nombre: String[20];
        desc: String [50];
        fecha: LongInt;
        metros: Real;
    end;
    fZona = File of rZona;
    afZona = Array[1..CANT_ZONAS] of fZona;
    arZona = Array[1..CANT_ZONAS] of rZona;

    rTotal = record
        codigo: Integer;
        nombre: String[20];
        metros: Real;
    end;
    fTotal = File of rTotal;

procedure leerZona(var fDet: fZona; var rDet: rZona);
begin
    if (not eof(fDet)) then
        read(fDet, rDet)
    else
        rDet.codigo:= VALOR_ALTO;
end;

procedure minimo(var afDet: afZona; var arDet: arZona; var min: rZona);
var
    posMin: Integer;
    i: Integer;
begin
    posMin:= -1;
    min.codigo:= VALOR_ALTO;
    for i:= 1 to CANT_ZONAS do
    begin
        if (arDet[i].codigo < min.codigo) then
        begin
            min:= arDet[i];
            posMin:= i;
        end;
    end;
    if (posMin <> -1) then
        leerZona(afDet[posMin], arDet[posMin]);
end;

procedure imprimirDetalles(var afDet: afZona);
var
    i:Integer;
    rDet: rZona;
    nro: String[2];
begin
    writeln('DETALLES:');
    for i:= 1 to CANT_ZONAS do
    begin
        str(i,nro);
        assign(afDet[i], 'detalle' + nro +'.dat');
        reset(afDet[i]);
        writeln('Archivo detalle', i,':');
        while (not eof(afDet[i])) do
        begin
            read(afDet[i], rDet);
            writeln('-------------------------------------');
            writeln('Codigo: ', rDet.codigo);
            writeln('Nombre: ', rDet.nombre);
            writeln('Descripcion: ', rDet.desc);
            writeln('Fecha: ', rDet.fecha);
            writeln('Metros: ', rDet.metros:0:2);
            writeln('-------------------------------------');
        end;
    end;
    writeln('');
    writeln('');
    writeln('');
end;

procedure generarMaestro(var fMas: fTotal; var afDet: afZona);
var
    arDet: arZona;
    texto: Text;
    ubicacion: String[50];
    rMas: rTotal;
    min: rZona;
    i: Integer;
begin
    rewrite(fMas);
    assign(texto, 'descripcion.txt');
    rewrite(texto);
    for i:= 1 to CANT_ZONAS do
    begin
        reset(afDet[i]);
        leerZona(afDet[i], arDet[i]);
    end;
    min.codigo:= 0;
    minimo(afDet, arDet, min);
    while(min.codigo <> VALOR_ALTO) do
    begin
        rMas.codigo:= min.codigo;
        rMas.nombre:= min.nombre;
        rMas.metros:= 0;
        ubicacion:= min.desc;
        while (min.codigo = rMas.codigo) do
        begin
            rMas.metros:= rMas.metros + min.metros;
            minimo(afDet, arDet, min);
        end;
        write(fMas, rMas);
        writeln(texto, rMas.codigo, ' ', rMas.nombre);
        writeln(texto, ubicacion);
        writeln(texto, rMas.metros:0:2);
    end;
    close(texto);
    close(fMas);
    for i:=1 to CANT_ZONAS do
    begin
        close(afDet[i]);
    end;
end;

procedure imprimirMaestro(var fMas: fTotal);
var
    rMas: rTotal;
begin
    reset(fMas);
    while (not eof(fMas)) do
    begin
        read(fMas, rMas);
        writeln('-------------------------------------');
        writeln('Codigo: ', rMas.codigo);
        writeln(' Nombre: ', rMas.nombre);
        writeln(' Metros: ', rMas.metros:0:2);
        writeln('-------------------------------------');
    end;
    close(fMas);
end;

var
    fMas: fTotal;
    afDet: afZona;
    i:Integer;
    nro: String[2];
begin
    assign(fMas, 'maestro.dat');
    for i:= 1 to CANT_ZONAS do
    begin
        str(i,nro);
        assign(afDet[i], 'detalle' + nro + '.dat');
    end;
    imprimirDetalles(afDet);
    generarMaestro(fMas, afDet);
    imprimirMaestro(fMas);
end.
