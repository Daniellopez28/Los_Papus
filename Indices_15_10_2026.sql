use BibliotecaPlanes;
go

--se debe crear indice scon prudencia
--hay que prioriozar columnas con alta selectividad
--se usan las columnas que tienen; where , joins , order by, partion by, group by
--son candidatas 

--habilitar estadisticas
set statistics time on;

SELECT 
    p.prestamo_id, 
    s.nombre, 
    s.apellido, 
    p.fecha_prestamo, 
    p.fecha_devolucion_prevista, 
    p.estado 
FROM Prestamo AS p 
INNER JOIN Socio AS s 
    ON p.socio_id = s.socio_id 
WHERE s.apellido = 'Siggin';  

--se usan 2 indices porque solo para una tabla 1 solo indice
--SE USA EL FOREIGN KEY
drop index IX_Apellido on Socio;
create index IX_Apellido on Socio(apellido) include (nombre);--el campo que quiero que inlcuya es nombre
create index IX_SocioID on Prestamo(socio_id) 
include(prestamo_id,  
    fecha_prestamo, 
    fecha_devolucion_prevista, 
    estado );
drop index IX_SocioID  on Prestamo;


SELECT 
    s.nombre, 
    s.apellido, 
    l.titulo, 
    p.fecha_prestamo, 
    p.fecha_devolucion_prevista, 
    p.estado 
FROM Prestamo AS p 
INNER JOIN Socio AS s 
    ON p.socio_id = s.socio_id 
INNER JOIN Ejemplar AS e 
    ON p.ejemplar_id = e.ejemplar_id 
INNER JOIN Libro AS l 
    ON e.libro_id = l.libro_id 
WHERE p.estado = 'Vencido' 
  AND p.fecha_devolucion_prevista >= '2026-01-01' 
  AND p.fecha_devolucion_prevista <  '2026-04-01'; 

  --ya aparece en libroid, ya es un foreig ¿n se descarta}
  --