

--Perfiles y politicas de seguridad
--si estamos en un servidor windows permite administrar los permisos y aministradores
--esto sera el tema del labo_3
--sql audit: es una aherramienta nativa, para poder registrar actividades y accesos, con fines de seguridad y de control papu
--server audit meto datbase audit specification , especificacionde la auditoria en la base de datos
--server audit -> tiene una extendsión sqlaudit-->sqlaudit registra la hora, si hizo una actividad en la base de datos
--cuando uno tiene informacion sensible haremos auditorias,guarda ip, la hora la fecha y la insertes que habia ingresado en 
--la base de datos
--server audit: es el contendor cdonde se van a aguardar los archivos
--y el database audit dice que acciones son las que yo voy a auditar
--interesa auditar para tener el control de quien hace cada cosa, asi si pasa algo sopechoso sabemos quien putas tumbo la base
--de datos
--Rodrigo y Gael es gei
--las audotiras sirven para notar las actividades sospechosas
--  hay 3 papus niveles de auditoria
-- nivel de servidor: podemos auditor los intentos fallidos de logeo, o quien ingreso, o quien da permiso, crea roles, 
--quien hizo backup
--quien hizo una restauracion de base de datos

--nivel de base de datos: auditar quien ejecuta los procedimientos de almacenado, quien creo una vista, quien creo una funcion
-- nivel de columna: tenemos una tabla que es la mora, cuotas pendientes por pagar se genera una mora, 

--el archivo server audit tiene 3 niveles
--vamos a usar archivos sqlaudit, dvamos a auditar bases de datos y columnas
-- d epoder visualizar con permido de una sentencia select de una funcion sys
--server audit es el contendor el archivo donde se vana a guardar los objetos, 
--el archivo donde habran uno o mas database audit especification

--paso 1: conectarme a la base master
--paso 2: crear el server audit(archivo que va a guardar)
--los registros de auditoria

create server audit NorthwindAudit
to file(filepath = '/audit/', maxsize = 10MB, max_files=5) -- y los vamosa a guardar, voy a crear un archivo de auditoria donde se guardara en 
--cada archivo tendra un maximo de peso maxsize es 10 mega, y el numero maximo de archivo es 5, total serian 50 mb
with(on_failure = continue);
go

-- habilitar el serveraudit
alter server audit NorthwindAudit with(state  = on);

use Northwind;
--las auditorias siempre se hacen en master --crear la especificacionde  aduitoria en la base de datos
create database audit specification DMLAudit --vamos a auditar sentencias dml
for server audit NorthwindAudit
add(insert, update, delete on dbo.Products by public), -- voy a auditar , los insert etc en la tabla producto por cualquier usuaario
add(select on dbo.Employees by public),
add(select, insert , update, delete on dbo.Orders by public);
go

-- habilitala especificacionde auditoria
alter database audit specification DMLAudit
with(state = on);

--probar la auditoria
select * from Employees

--para el usuario
--select top 5 * from Products
--update Products set UnitPrice = unitPrice *1.1
--where productID = 1;

--select max (ProductId) from products;

--select 78 , 'Pupusas', supplieriD, CategoryID,
--QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder,
--ReorderLevel,discontinued from Products where ProductID = 1;

--select * from products where productid = 78;

--update products set unitinstock = 78;

--update Products set UnitsInStock = 100 where ProductID = 78;
--delete from Products where ProductID =78;

--select top 10 * from Orders;

--volvemos al usuario sa
--ver la auditoria
--carpeta de seguridad, luego auditoria, busco la audiotira, y veo la auditoria
--o y asi miro la auditoria
go
create view auditorias as (select event_time, action_id, server_principal_name,database_name, statement from
sys.fn_get_audit_file ('/audit/*',default,default)); 
go
--where statement like 'delete%' order by event_time desc;
--convertirlo en una vista, hacer una base de datos ir guardando los registros de auditoria y ver