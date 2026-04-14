program GeneradorArticulos;

type
    rArticulo = record
        codigo: Integer;
        descripcion: String[50];
        color: String[15];
        talle: Integer;
        stock: Integer;
        precio: Real;
    end;

    fArticulo = File of rArticulo;

var
    f: fArticulo;
    a: rArticulo;

procedure Cargar(c: Integer; d: String; col: String; t, s: Integer; p: Real);
begin
    a.codigo := c;
    a.descripcion := d;
    a.color := col;
    a.talle := t;
    a.stock := s;
    a.precio := p;
    write(f, a);
end;

begin
    assign(f, 'articulos.dat');
    rewrite(f);

    // Datos ordenados por código para que tu búsqueda (reg.codigo < codigo) funcione
    Cargar(10, 'Remera Algodon V', 'Azul', 42, 50, 1500.50);
    Cargar(20, 'Pantalon Jean Slim', 'Negro', 44, 30, 4500.00);
    Cargar(30, 'Camisa Formal Lino', 'Blanco', 40, 20, 3200.75);
    Cargar(40, 'Chomba Pique Classic', 'Verde', 42, 15, 2100.00);
    Cargar(50, 'Bermuda Gabardina', 'Beige', 46, 25, 2800.25);
    Cargar(60, 'Saco de Lana', 'Gris', 48, 10, 8500.00);

    close(f);
    writeln('Archivo articulos.dat generado exitosamente con 6 articulos.');
    readln;
end.
