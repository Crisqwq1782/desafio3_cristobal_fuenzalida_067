CREATE DATABASE desafio3_cristobal_fuenzalida_067


CREATE TABLE Usuarios(  
    id SERIAL,
    email VARCHAR(255),
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    rol VARCHAR(255),
);
---Requerimiento 1  Nota: A modo de excepción, La tabla Articulos debe ser considerada como la tabla de posts.
CREATE TABLE Usuarios(  
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    rol VARCHAR(255)
);

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES 
('admin@ejemplo.com', 'Emily', 'Lisette', 'administrador'),
('juan@ejemplo.com', 'Juan', 'Perez', 'usuario'),
('maria@ejemplo.com', 'Maria', 'Gomez', 'usuario'),
('pedro@ejemplo.com', 'Pedro', 'Lopez', 'usuario'),
('ana@ejemplo.com', 'Ana', 'Torres', 'usuario');

create Table Articulos(
    id SERIAL PRIMARY KEY,
    Titulo VARCHAR(255) NOT NULL,
    Contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN DEFAULT FALSE,
    usuario_id BIGINT
)

INSERT INTO Articulos (Titulo, Contenido, destacado, usuario_id, fecha_creacion) VALUES 
('Caja roja', 'libros', true, 1, '2026-07-01 10:00:00'), -- Post 1: Admin
('Caja azul', 'lapices', false, 1, '2026-07-05 14:30:00'), -- Post 2: Admin
('Caja verde', 'revistas', true, 2, '2026-07-08 09:15:00'),        -- Post 3: Juan
('Caja amarilla', 'Pintura', false, 3, '2026-07-08 10:00:00'),             -- Post 4: Maria
('Caja negra', 'periódicos', false, NULL, '2026-07-09 12:00:00');        -- Post 5: Sin usuario

Create table comentarios(
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
)

INSERT INTO comentarios (contenido, usuario_id, post_id) VALUES 
('Todo de muy buena calidad!', 1, 1),
('Muy lindos colores!', 2, 1),
('Sera posible encargar mañana?', 3, 1),
('Todas las cajas traen el mismo set?', 1, 2),
('Me tocaron unos demasiado antiguos', 2, 2);

---Requerimiento 2
SELECT usuarios.nombre, usuarios.email,articulos.Titulo, articulos.Contenido 
FROM usuarios 
INNER JOIN articulos ON usuarios.id = articulos.usuario_id 

---Requerimiento 3 (Para mayor claridad, incluí la seleccion de rol en la consulta)
SELECT usuarios.rol, usuarios.nombre, usuarios.email,articulos.Titulo, articulos.Contenido 
FROM usuarios 
INNER JOIN articulos ON usuarios.id = articulos.usuario_id
WHERE usuarios.rol = 'administrador'

---requerimiento 4 Contar la cantidad de articulos por usuario, incluyendo aquellos usuarios que no tienen articulos asociados.
SELECT usuarios.id, usuarios.email,
COUNT(articulos.id) AS cantidad_articulos
FROM usuarios
LEFT JOIN articulos ON usuarios.id = articulos.usuario_id
GROUP BY usuarios.id, usuarios.email;

---requerimiento 5 
SELECT usuarios.email
FROM usuarios
INNER JOIN articulos ON usuarios.id = articulos.usuario_id
GROUP BY usuarios.id, usuarios.email
ORDER BY COUNT(articulos.id) DESC
LIMIT 1;


---requerimiento 6
SELECT usuarios.email,
MAX(articulos.fecha_creacion) AS ultima_fecha
FROM usuarios
INNER JOIN articulos ON usuarios.id = articulos.usuario_id
GROUP BY usuarios.id, usuarios.email;

---requerimiento 7
SELECT articulos.Titulo, articulos.Contenido
FROM articulos
INNER JOIN comentarios ON articulos.id = comentarios.usuario_id
GROUP BY articulos.id, articulos.Titulo, articulos.Contenido
ORDER BY COUNT(comentarios.id) DESC
LIMIT 1;

---requerimiento 8
SELECT articulos.titulo, articulos.contenido, comentarios.contenido AS comentario, usuarios.email
FROM articulos
INNER JOIN comentarios ON articulos.id = comentarios.post_id
INNER JOIN usuarios ON comentarios.usuario_id = usuarios.id;

---requerimiento 9
SELECT 
usuarios.email, 
comentarios.contenido AS Ultimo_Comentario, 
comentarios.fecha_creacion
FROM comentarios
INNER JOIN usuarios ON comentarios.usuario_id = usuarios.id
WHERE comentarios.fecha_creacion = (
SELECT MAX(fecha_creacion) 
FROM comentarios AS c2 
WHERE c2.usuario_id = comentarios.usuario_id
); 

---requerimiento 10
SELECT usuarios.email
FROM usuarios
LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
WHERE comentarios.usuario_id IS NULL;


---Drop para testear cambios.
--DROP TABLE comentarios;
--DROP TABLE articulos;
--DROP TABLE usuarios;
