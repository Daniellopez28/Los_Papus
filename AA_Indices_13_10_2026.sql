--tipos de indices: non cluster
--pueden a ver muchos por cada tabla es una estryctyra adicional
--es un arbol binario adicional que le creo a la tabla 
--hay que tener cuidadio por que cada indicie non cluster tiene implicaiones
--consumen espacio en el disco duro, no se ponen a lo vale verga

--clustered ordena fisicaemente los datos en el disco
--solo puede haber uno por tabla 
--recuperar filas enteras o 

--los nun cluster pueden haber cuanto se me ronque la gana
--hacer buuedads especificas de columnas concretas

set statistics time on;-- estadisticas de tiempo
set statistics io on;

--aquelllos que aparezcan en un where, order by, partiton bry, o en un join
--son candidatos a crear indices
select prestamo_id, socio_id,fecha_prestamo,fecha_devolucion_prevista,estado
from Prestamo

where socio_id = 308;

--creacion del indice
create index IX_SocioID on Prestamo(socio_id)


SELECT 
    prestamo_id, 
    socio_id, 
    ejemplar_id, 
    empleado_id, 
    fecha_prestamo, 
    fecha_devolucion_prevista, 
    fecha_devolucion_real, 
    estado 
FROM Prestamo 
WHERE socio_id = 308; 

--es pa optimizar consultas
--un indice cubierto
create index IX_SocioID_Cubierto on Prestamo(socio_id)
include(prestamo_id, 
    ejemplar_id, 
    empleado_id, 
    fecha_prestamo, 
    fecha_devolucion_prevista, 
    fecha_devolucion_real, 
    estado);
drop index IX_SocioId_cubierto on Prestamo;

SELECT 
    prestamo_id, 
    socio_id, 
    ejemplar_id, 
    fecha_prestamo, 
    estado 
FROM Prestamo 
WHERE estado = 'Activo'; 

drop index IX_estado on Prestamo;
create index IX_estado on Prestamo(estado);
include(  prestamo_id, 
    socio_id, 
    ejemplar_id, 
    fecha_prestamo);

select distinct estado from Prestamo;