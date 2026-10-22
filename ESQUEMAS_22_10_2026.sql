--objetos d euna base de datis: las tablas, las vistas, las funciones, y los procedimientos de almacenados
--los indices que creamos tambien son objetos
--vamos a aprender a orgnaizarlo en esquemas y tmabien comprender cuale es el papel de lso esquemas dentro
--de la seguridad d ela base de datos
--el esquema es un contendor logico de los objetos de la bases de dtos
--permite organizar los objetos de la base de datos y aislalor segun los modulos y propiedades
--basicamente tener distintas areas dentro de la base de datos yq eu esta wea no se mezcle
--con contenedores
--ventajas: 1)se puede ir organizando los objetos en contenderores logicos
--2) delegacion de seguridad: asi como los reoles son contenedores de privilegios, los esquemas son contenedores de objetos
--se prefieres hacer grant a esquemas completos que les damos roles
--dentro del esquema puedo tener tabla usuario, y luego otra tabla de varias cosas, puedo tener 
--tablas y objetos con el mismo nombre pero con esquemas diferentes
--3) los equemas mejoran la mantebilidad: deja hacer migracion selectiva o bakcup selectivos
--asi puedo hacer backup de contabilidad cada semana o diarios
--sintaxis: create schema ventas authorization usuarioVentas;
use Northwind;
go

select name as esquema, USER_NAME(principal_id) dueño
from sys.schemas;

use pubs;
go

select name as esquema, USER_NAME(principal_id) dueño
from sys.schemas;
go

create schema Editorial authorization dbo;
go

select s.name esquema, o.name objeto, o.type_desc tipo
from sys.schemas s
join sys.objects o on s.schema_id = o.schema_id
where s.name = 'db_datareader' and o.type_desc = 'USER_TABLE';

create database empresaDB;

use empresaDB;
go

create schema Ventas authorization dbo;
go

create schema Comercio authorization dbo;
go

--pertence a tablas de ventas 
create table Ventas.Pedido(
idpedido int primary key,
fecha date,
monto decimal(10,2)
);

select s.name esquema, o.name objeto
from sys.schemas s
left join sys.objects o on s.schema_id = o.schema_id
where s.name in ('Ventas', 'Comercio');

drop shema Ventas; --no se elimina porque esquema tiene objetos

create table Ventas.Cliente(
idcliente int primary key,
nombre nvarchar(255),
estado varchar(20)
);

--cambiamos a otro esquema
alter schema Comercio transfer Ventas.Cliente;
--voy a tranferir el objeto que pertenece a comercio a cliente 