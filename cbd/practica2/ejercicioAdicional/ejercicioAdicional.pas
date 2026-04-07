program ejercicioAdicional;
const
    VALOR_ALTO=9999;
    CANT_ARCH=500;
type
    rLocalidad = record
        codigoP: Integer;
        codigoL: Integer;
        cantVal: Integer;
        cantBla: Integer;
        cantAnu: Integer;
    end;
    fLocalidad = File of rLocalidad;
    afLocalidad = Array [1..CANT_ARCH] of fLocalidad;
    arLocalidad = Array [1..CANT_ARCH] of rLocalidad;

    rProvincia = record
        codigoP: Integer;
        nombre: String[20];
        cantVal: Integer;
        cantBla: Integer;
        cantAnu: Integer;
    end;
    fProvincia = File of rProvincia;

procedure leerLocalidad(var fDet: fLocalidad; var rDet: rLocalidad);
begin
    if (not eof(fDet)) then
        read(fDet, rDet)
    else
        rDet.codigoP:= VALOR_ALTO;
end;

procedure minimo(var afDet: afLocalidad; var arDet: arLocalidad; var min: rLocalidad);
var
    posMin: Integer;
    codPAct: Integer;
    i: Integer;
begin
    posMin:= -1;
    min.codigoP:= VALOR_ALTO;
    for i:= 1 to CANT_ARCH do
    begin
        if(arDet[i].codigoP < min.codigoP) then
        begin
            posMin:= i;
            min:= arDet[i];
        end;
    end;
    if (posMin <> -1) then
    begin
        leerLocalidad(afDet[posMin], arDet[posMin]);
        while(arDet[posMin].codigoP = min.codigoP) do
        begin
            min.cantAnu:= min.cantAnu + arDet[posMin].cantAnu;
            min.cantBla:= min.cantBla + arDet[posMin].cantBla;
            min.cantVal:= min.cantVal + arDet[posMin].cantVal;
            leerLocalidad(afDet[posMin], arDet[posMin]);
        end;
    end;
end;

procedure actualizarMaestro(var fMas: fProvincia; var afDet: afLocalidad; archPro: Integer);
var
    rMas: rProvincia;
    arDet: arLocalidad; min: rLocalidad;
    arch: Text;
    i, totVotos, totVal, totBla, totAnu: Integer;
begin
    for i:=1 to CANT_ARCH do
    begin
        reset(afDet[i]);
        leerLocalidad(afDet[i],arDet[i]);
    end;
    reset(fMas);
    assign(arch, 'cantidad_votos_04_07_2023.txt');
    rewrite(arch);
    minimo(afDet, arDet, min);
    if (not eof(fMas)) then
    begin
        read(fMas, rMas);
    end;
    totVal:= 0;
    totBla:= 0;
    totAnu:= 0;
    totVotos:= 0;
    while(min.codigoP <> VALOR_ALTO) do
    begin
        while (rMas.codigoP < min.codigoP) do
        begin
            read(fMas, rMas)
        end;

        while (min.codigoP = rMas.codigoP) do
        begin
            rMas.cantAnu:= rMas.cantAnu + min.cantAnu;
            rMas.cantBla:= rMas.cantBla + min.cantBla;
            rMas.cantVal:= rMas.cantVal + min.cantVal;
            totVal:= totVal + min.cantVal;
            totBla:= totBla + min.cantBla;
            totAnu:= totAnu + min.cantAnu;
            minimo(afDet, arDet, min);
        end;
        seek(fMas, filePos(fMas) - 1);
        write(fMas, rMas);
    end;
    totVotos:= totVal + totBla + totAnu;
    writeln(arch, 'Cantidad de archivos procesados: ', archPro);
    writeln(arch, 'Cantidad Total de votos: ', totVotos);
    writeln(arch, 'Cantidad ve votos validos: ', totVal);
    writeln(arch, 'Cantidad ve votos en blanco: ', totBla);
    writeln(arch, 'Cantidad ve votos anulados: ', totAnu);
    for i:=1 to CANT_ARCH do
    begin
        close(afDet[i]);
    end;
    close(fMas);
    close(arch);
end;

var
    fMas: fProvincia;
    afDet: afLocalidad;
    i: Integer;
    nro: String[3];
    cantPro: Integer;
begin
    cantPro:= 0;
    for i:=1 to CANT_ARCH do
    begin
        str(i, nro);
        assign(afDet[i], 'detalle' + nro + '.dat');
        cantPro:= cantPro + 1;
    end;
    assign(fMas, 'maestro.dat');
    actualizarMaestro(fMas, afDet, cantPro);
end.
