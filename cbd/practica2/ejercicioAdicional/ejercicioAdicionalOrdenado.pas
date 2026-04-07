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
    aProvincias = Array[1..23] of String[20];
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
    i: Integer;
    fMasAux: fProvincia;
    rMas: rProvincia;
    rMasAux: rProvincia;
    arDet: arLocalidad;
    min: rLocalidad;
    arch: Text;
    totVotos: Integer;
    totVal: Integer;
    totBla: Integer;
    totAnu: Integer;
begin
    for i:=1 to CANT_ARCH do
    begin
        reset(afDet[i]);
        leerLocalidad(afDet[i],arDet[i]);
    end;
    reset(fMas);
    assign(arch, 'cantidad_votos_04_07_2023.txt');
    rewrite(arch);
    assign(fMasAux, 'maestroAux.dat');
    rewrite(fMasAux);
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
        rMasAux.codigoP:= min.codigoP;
        rMasAux.cantAnu:= min.cantAnu;
        rMasAux.cantBla:= min.cantBla;
        rMasAux.cantVal:= min.cantVal;
        while (rMas.codigoP < min.codigoP) do
        begin
            write(fMasAux, rMas);
            if (not eof(fMas)) then
                read(fMas, rMas)
            else
                rMas.codigoP:= VALOR_ALTO;
        end;
        while (min.codigoP = rMasAux.codigoP) do
        begin
            rMasAux.cantAnu:= rMasAux.cantAnu + min.cantAnu;
            rMasAux.cantBla:= rMasAux.cantBla + min.cantBla;
            rMasAux.cantVal:= rMasAux.cantVal + min.cantVal;
            totVal:= totVal + min.cantVal;
            totBla:= totBla + min.cantBla;
            totAnu:= totAnu + min.cantAnu;
            minimo(afDet, arDet, min);
        end;
        write(fMasAux, rMasAux);
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
    close(fMasAux);
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
