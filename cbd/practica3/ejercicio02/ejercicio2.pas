program ejercicio2;
type
    rVehiculo= Record
        codigoVehiculo:Integer;
        patente: String;
        motor:String;
        cantidadPuertas: Integer;
        precio:Real;
        descripcion:String
    end;

    fVehiculo = File of rVehiculo;

procedure agregar(var f: fVehiculo; vehiculo: rVehiculo);
var
    sig: rVehiculo;
    cod, nLibre: Integer;
begin
    reset(f);
    if (not eof(f)) then read(f, sig);
    Val(sig.descripcion, nLibre, cod);
    if (nLibre = 0) then seek(f,filesize(f))
    else begin
        seek(f,nLibre); read(f, sig);
        seek(f,0); write(f,sig);
        seek(f,nLibre);
    end;
    write(f,vehiculo);
    close(f);
end;

procedure eliminar(var f: fVehiculo; codigoVehiculo: Integer);
var
    nEliminar, cod: Integer;
    cabecera, reg:rVehiculo;

begin
    reset(f);
    if(not eof(f)) then read(f,cabecera) else exit;
    reg.codigoVehiculo:= -1;
    Val(cabecera.descripcion, nEliminar, cod);
    while(not eof(f) and (reg.codigoVehiculo <> codigoVehiculo)) do read(f, reg);
    if(reg.codigoVehiculo = codigoVehiculo) then
    begin
        nEliminar:= filepos(f) - 1;
        seek(f, nEliminar);
        write(f, cabecera);
        seek(f,0);
        str(nEliminar, cabecera.descripcion);
        write(f, cabecera);
    end else writeln('No se encontro el vehiculo con codigo ', codigoVehiculo);
    close(f);
end;

procedure imprimirArchivo(var f:fVehiculo);
var
    reg: rVehiculo;
begin
    reset(f);
    while(not eof(f)) do
    begin
       read(f, reg);
       writeln('Codigo: ', reg.codigoVehiculo);
       writeln('Patente: ', reg.patente);
       writeln('Numero de motor: ', reg.motor);
       writeln('Cantidad de puertas: ', reg.cantidadPuertas);
       writeln('Precio: ', reg.precio);
       writeln('Descripcion: ', reg.descripcion);
       writeln('----------------------------------------------');
    end;
end;

procedure agregarVehiculos(var f:fVehiculo);
var
    reg: rVehiculo;
begin
    writeln('Ingrese el codigo de vehiculo: ');
    readln(reg.codigoVehiculo);
    while (reg.codigoVehiculo <> -1)do
    begin
        writeln('Igrese la patente: ');
        readln(reg.patente);
        writeln('Ingrese el numero de motor: ');
        readln(reg.motor);
        writeln('Ingrese la cantidad de puertas: ');
        readln(reg.cantidadPuertas);
        writeln('Ingrese el precio: ');
        readln(reg.precio);
        writeln('Ingrese la descripcion: ');
        readln(reg.descripcion);
        agregar(f, reg);
        writeln('Ingrese el codigo de vehiculo: ');
        readln(reg.codigoVehiculo);
    end;
end;

var
    f: fVehiculo;
    reg: rVehiculo;
begin
    assign(f,'vehiculos.dat');
    reg.descripcion:= '0';
    rewrite(f);
    write(f, reg);
    agregarVehiculos(f);
    writeln('ARCHIVO CREADO: ');
    imprimirArchivo(f);
    writeln('Ingrese el codigo de vehiculo a eliminar: ');
    readln(reg.codigoVehiculo);
    while(reg.codigoVehiculo <> -1) do
    begin
        eliminar(f, reg.codigoVehiculo);
        writeln('Ingrese el codigo de vehiculo a eliminar: ');
        readln(reg.codigoVehiculo);
    end;
    writeln('----------------------------------------------');
    writeln('DESPUES DE ELIMINAR: ');
    imprimirArchivo(f);
    agregarVehiculos(f);
    writeln('ARCHIVO DESPUES DE AGREGAR POR SEGUNDA VEZ:');
    imprimirArchivo(f);
end.
