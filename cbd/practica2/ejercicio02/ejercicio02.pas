program ejercicio2;
const
    VALOR_ALTO=9999;
type
    rCd = record
        codAut: Integer;
        nomAut: String[20];
        nomDis: String[20];
        genero: String[20];
        cantVe: Integer;
    end;

    fCd = File of rCd;
    fListado = Text;

procedure leer(var fDisco: fCd; var rDisco: rCd);
begin
    if (not eof(fDisco)) then
        read(fDisco, rDisco)
    else
        rDisco.codAut:= VALOR_ALTO;
end;

procedure imprimirArchivo(var fDisco: fCd);
var
    rDisco: rCd;
    fLis: fListado;
    codAutAct: Integer;
    generoAct: String[20];
    totAut: Integer;
    totGen: Integer;
    totDis: LongInt;
begin
    assign(fLis,'listado.txt');
    rewrite(fLis);
    assign(fDisco, 'CDs.dat');
    reset(fDisco);
    totDis:= 0;
    leer(fDisco, rDisco);
    while (rDisco.codAut <> VALOR_ALTO) do
    begin
        codAutAct:= rDisco.codAut;
        totAut:= 0;
        writeln(fLis, 'Autor: ', rDisco.nomAut);
        while (rDisco.codAut = codAutAct) do
        begin
            generoAct:= rDisco.genero;
            writeln(fLis, '  Genero: ', generoAct);
            totGen:= 0;
            while ((rDisco.codAut = codAutAct) and
                   (rDisco.genero = generoAct)) do
            begin
                writeln(fLis, '    Nombre Disco: ', rDisco.nomDis, ' cantidad ',
                        'vendida: ', rDisco.cantVe);
                totGen:= totGen + rDisco.cantVe;
                leer(fDisco, rDisco);
            end;
            totAut:= totAut + totGen;
            writeln(fLis, 'Total genero: ', totGen);
        end;
        totDis:= totDis + totAut;
        writeln(fLis, 'Total Autor: ', totAut);
        writeln(flis, '---------------');
    end;
    writeln(fLis, 'Total discografica: ', totDis);
    close(fLis);
    close(fDisco);
end;

var
    fDisco: fCd;
begin
    imprimirArchivo(fDisco);
end.
