program ejercicio1;
const
    CANT_DETALLES = 10;
    VALOR_ALTO =9999;
type
    rDetalle = record
        codEmp: Integer;
        fechaLic: LongInt;
        cantDias: Integer;
    end;

    rMaestro = record
        codEmp: Integer;
        nombre: String[20];
        apellido: String[20];
        fechaNac: LongInt;
        direccion: String[30];
        cantHijos: Integer;
        telefono: LongInt;
        cantVac: Integer;
    end;

    fDetalle = File of rDetalle;
    fMaestro = File of rMaestro;
    afDetalle = Array[1..CANT_DETALLES] of fDetalle;
    arDetalle = Array[1..CANT_DETALLES] of rDetalle;

procedure leer(var fDet: fDetalle; var rDet: rDetalle);
begin
    if (not eof(fDet)) then
        read(fDet,rDet)
    else
        rDet.codEmp:= VALOR_ALTO;
end;

procedure minimo(var afDet: afDetalle; var arDet: arDetalle;
                 var min: rDetalle);
var
   posMin: Integer;
   i: Integer;
begin
    min:= arDet[1];
    posMin:= 1;
    for i:= 2 to CANT_DETALLES do
    begin
        if (arDet[i].codEmp < min.codEmp) then
        begin
            min:= arDet[i];
            posMin:= i;
        end;
    end;
    Leer(afDet[posMin],arDet[posMin]);
end;

procedure abrirArchivosDetalle(var afDet: afDetalle);
var
    i: Integer;
    nro: String;
begin
    for i:=1 to CANT_DETALLES do
    begin
        Str(i, nro);
        assign(afDet[i],'detalle' + nro + '.dat');
        reset(afDet[i]);
    end;
end;

procedure cerrarArchivosDetalle(var afDet: afDetalle);
var
    i: Integer;
begin
    for i:= 1 to CANT_DETALLES do
    begin
        close(afDet[i]);
    end;
end;

procedure actualizar(var fMas: fMaestro; var afDet: afDetalle);
var
    arDet: arDetalle;
    i: Integer;
    min: rDetalle;
    rMas: rMaestro;
    diasIns: Text;
begin
    // Creo el archivo por si el empleado no tiene dias suficientes.
    assign(diasIns,'faltanDias.txt');
    rewrite(diasIns);
    // Abro y asigno todos los archivos detalle
    abrirArchivosDetalle(afDet);
    // Inicializo el vector de registros detalle
    for i:= 1 to CANT_DETALLES do
    begin
        leer(afDet[i], arDet[i]);
    end;
    // Abro el archivo maestro
    reset(fMas);
    // Leo el primer elemento (el ejercicio especifica que tiene datos)
    read(fMas, rMas);
    // Busco el empleado con menor codigo dentro del array de registros
    minimo(afDet, arDet, min);
    // Bucle para actualizar hasta que los archivos detalle se queden sin datos
    while (min.codEmp <> VALOR_ALTO) do
    begin
        // Busco el empleado dentro del archivo maestro
        while(min.codEmp <> rMas.codEmp) do
        begin
            read(fMas, rMas);
        end;
        // Como un empleado puede solicitar mas de una licencia se buscan las
        // solicitudes con el mismo codigo de empleado y por precondicion el
        // empleado seguro esta en el maestro
        while (min.codEmp = rMas.codEmp) do
        begin
            // Si solicita mas dias de los que tiene disponibles escribe en el
            // txt, va a escribir un error por cada solicitud
            if (rMas.cantVac < min.cantDias) then
            begin
                writeln(diasIns, 'Codigo: ', rMas.codEmp);
                writeln(diasIns, 'Nombre: ', rMas.nombre, ' ', rMas.apellido);
                writeln(diasIns, 'Tiene ', rMas.cantVac, ' dias');
                writeln(diasIns, 'Solicita ', min.cantDias, ' dias');
                writeln(diasIns, '-------------------------------------');
            end
            else
                // Si tiene dias disponibles los resta al maestro
                rMas.cantVac:= rMas.cantVac - min.cantDias;
            minimo(afDet, arDet, min);
        end;
        seek(fMas, filepos(fMas) - 1);
        write(fMas, rMas);
    end;
    cerrarArchivosDetalle(afDet);
    close(diasIns);
end;

procedure imprimirMaestro(var fMas: fMaestro);
var
    rMas: rMaestro;
begin
    reset(fMas); // Volvemos al inicio del archivo
    writeln('--- CONTENIDO DEL MAESTRO ---');
    writeln('ID   | Apellido, Nombre      | Dias Vac.');
    writeln('---------------------------------------');

    while not eof(fMas) do
    begin
        read(fMas, rMas);
        writeln(rMas.codEmp:4, ' | ', rMas.apellido, ', ', rMas.nombre, ' | ',
                rMas.cantVac:3);
    end;

    close(fMas);
    writeln('---------------------------------------');
end;

var
    afDet: afDetalle;
    fMas: fMaestro;
begin
    assign(fMas, 'maestro.dat');
    imprimirMaestro(fMas);
    actualizar(fMas, afDet);
    imprimirMaestro(fMas);
    close(fMas);
end.
