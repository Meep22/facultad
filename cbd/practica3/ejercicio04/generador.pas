program GeneradorDiscos;

type
    rDisco = record
        codigo: Integer;
        nombre: String[20];
        genero: String[20];
        descripcion: String[50];
        edicion: Integer;
        stock: Integer;
    end;

    fDisco = File of rDisco;

var
    f: fDisco;
    d: rDisco;

procedure CargarDisco(c: Integer; n, g, desc: String; ed, st: Integer);
begin
    d.codigo := c;
    d.nombre := n;
    d.genero := g;
    d.descripcion := desc;
    d.edicion := ed;
    d.stock := st;
    write(f, d);
end;

begin
    assign(f, 'discos.dat');
    rewrite(f);

    // Cargamos algunos datos de prueba
    CargarDisco(1, 'Abbey Road', 'Rock', 'The Beatles clasico', 1969, 10);
    CargarDisco(2, 'Thriller', 'Pop', 'Michael Jackson', 1982, 5);
    CargarDisco(3, 'The Dark Side', 'Progressive', 'Pink Floyd', 1973, 8);
    CargarDisco(4, 'Back in Black', 'Hard Rock', 'AC/DC', 1980, 12);
    CargarDisco(5, 'Discovery', 'Electronic', 'Daft Punk', 2001, 20);

    close(f);
    writeln('Archivo discos.dat generado con 5 registros.');
    writeln('Presiona Enter para finalizar.');
    readln;
end.
