program ejercicio9;
const
    VALOR_ALTO=9999;
    CANT_CAR=5;
type
    rCorredor = record
        dni: LongInt;
        nombre: String[20];
        apellido: String[20];
        km: Real;
        gano: Integer;
    end;
    fCarrera = File of rCorredor;
    afCarrera = Array[1..CANT_CAR] of fCarrera;
    arCorredor = Array[1..CANT_CAR] of rCorredor;

procedure leerCorredor(var fDet: fCarrera; var rDet: rCorredor);
begin
    if (not eof(fDet)) then
    begin
        read(fDet, rDet)
    end
    else
        rDet.dni:= VALOR_ALTO;
end;

procedure minimo(var afDet: afCarrera; var arDet: arCorredor; var min: rCorredor);
var
    posMin: Integer;
    i: Integer;
begin
    posMin:= -1;
    min.dni:= VALOR_ALTO;
    for i:=1 to CANT_CAR do
    begin
        if(arDet[i].dni < min.dni) then
        begin
            posMin:= i;
            min:= arDet[i];
        end;
    end;
    if (posMin <> -1) then
    begin
        leerCorredor(afDet[posMin], arDet[posMin]);
        writeln('Archivo: ', posMin, 'DNI: ', arDet[posMin].dni);
    end;
end;


procedure generarMaestro(var fMas: fCarrera; var afDet: afCarrera);
var
    arDet: arCorredor;
    rMas: rCorredor;
    min: rCorredor;
    i: Integer;
begin
    rewrite(fMas);
    for i:=1 to CANT_CAR do
    begin
        reset(afDet[i]);
        leerCorredor(afDet[i], arDet[i]);
    end;
    minimo(afDet, arDet, min);
    while (min.dni <> VALOR_ALTO) do
    begin
        rMas:= min;
        rMas.gano:= 0;
        rMas.km:= 0;
        while (min.dni = rMas.dni) do
        begin
            rMas.gano:= rMas.gano + min.gano;
            rMas.km:= rMas.km + min.km;
            minimo(afDet, arDet, min);
        end;
        write(fMas, rMas);
    end;
    for i:=1 to CANT_CAR do
    begin
        close(afDet[i]);
    end;
    close(fMas);
end;

procedure imprimirArchivo(var f: fCarrera);
var
    reg:rCorredor;
begin
    reset(f);
    while(not eof(f)) do
    begin
        read(f,reg);
        writeln('---------------------------------------');
        writeln('DNI: ', reg.dni);
        writeln('Nombre: ', reg.nombre);
        writeln('Apellido: ', reg.apellido);
        writeln('Km recorridos: ', reg.km:0:2);
        writeln('Gano: ', reg.gano);
        writeln('---------------------------------------');
    end;
    close(f);
end;

var
    fMas: fCarrera;
    afDet: afCarrera;
    nro: String[2];
    i: Integer;
begin
    for i:=1 to CANT_CAR do
    begin
        str(i,nro);
        assign(afDet[i],'detalle' + nro + '.dat');
        writeln('Archivo detalle', i, ': ');
        imprimirArchivo(afDet[i]);
        writeln('fin detalle');
    end;
    assign(fMas, 'maestro.dat');
    generarMaestro(fMas, afDet);
    imprimirArchivo(fMas);
end.
