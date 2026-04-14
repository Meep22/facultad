program GenerarArchivoEspecies;

type
    rEspecie = record
        codigo: Integer;
        nombreVulgar: String[20];
        nombreCientifico: String[20];
        altura: Real;
        descripcion: String[50];
        zona: String[50];
    end;

    fEspecie = file of rEspecie;

var
    archivo: fEspecie;
    e: rEspecie;

procedure CargarEspecie(var reg: rEspecie; cod: Integer; nomV, nomC: String; alt: Real; desc, zon: String);
begin
    reg.codigo := cod;
    reg.nombreVulgar := nomV;
    reg.nombreCientifico := nomC;
    reg.altura := alt;
    reg.descripcion := desc;
    reg.zona := zon;
end;

begin
    Assign(archivo, 'especies.dat');
    Rewrite(archivo);

    { Registro 1: No trepadora }
    CargarEspecie(e, 101, 'Encina', 'Quercus ilex', 15.0, 'Arbol robusto', 'Mediterraneo');
    Write(archivo, e);

    { Registro 2: Trepadora (A eliminar) }
    CargarEspecie(e, 202, 'Hiedra', 'Hedera helix', 20.0, 'Planta trepadora perenne', 'Toda Europa');
    Write(archivo, e);

    { Registro 3: No trepadora }
    CargarEspecie(e, 303, 'Lavanda', 'Lavandula', 0.6, 'Arbusto aromatico', 'Sur de Europa');
    Write(archivo, e);

    { Registro 4: Trepadora (A eliminar) }
    CargarEspecie(e, 404, 'Vid', 'Vitis vinifera', 10.0, 'Trepadora de fruto', 'Zonas templadas');
    Write(archivo, e);

    Close(archivo);
    WriteLn('Archivo "especies.dat" creado con 4 registros de prueba.');
    WriteLn('Codigos disponibles: 101, 202 (trepadora), 303, 404 (trepadora).');
end.
