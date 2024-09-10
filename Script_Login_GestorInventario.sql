--Creamos la tabla de usuarios
create table login_schema.usuarios(
	idUsuario SERIAL PRIMARY KEY,
	fcNombre VARCHAR(100) NOT NULL,
	fcApellidoM VARCHAR(50) NOT NULL,
	fcApellidoP VARCHAR(50),
	fcUsuario VARCHAR(100) NOT NULL UNIQUE,
	fcCorreo VARCHAR(100) NOT NULL UNIQUE,
	fcPassword VARCHAR(150) NOT NULL,
	fcFechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-----------------------------------------------------------
--Query para visualizar la tabla de usuarios
SELECT * FROM login_schema.USUARIOS;

--Query para eliminar usuario
delete from login_schema.USUARIOS where idUsuario = 2;
-----------------------------------------------------------
--Query para insertar un dato en la tabla
INSERT INTO login_schema.usuarios (fcNombre, fcApellidoM, fcUsuario, fcCorreo, fcPassword)
VALUES('Rodrigo', 'Diaz', 'RDPortela', 'rd_portela@hotmail.com', '123456789');

-----------------------------------------------------------
-- Creamos una funcion para la consulta de los usuarios
CREATE OR REPLACE FUNCTION login_schema.ConsultaUsuario(pa_usuario varchar, pa_password varchar)
RETURNS VARCHAR AS $$
DECLARE nombre_usuario varchar(150);
BEGIN
	SELECT CONCAT(fcNombre, ' ', fcApellidoP, ' ', COALESCE(fcApellidoM, ' '))
	INTO  nombre_usuario
	FROM usuarios
	WHERE fcUsuario = pa_usuario AND fcPassword = pa_password;

	RETURN nombre_usuario;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------
--Llamamos a la funcion
select login_schema.ConsultaUsuario('RDPortela', '123456789');

-----------------------------------------------------------
--Creamos un schema para organizar
CREATE SCHEMA login_schema;

-----------------------------------------------------------
--Creamos un sp
CREATE OR REPLACE PROCEDURE login_schema.crearUsuario(
	IN pa_nombre VARCHAR,
	IN pa_apellidoM VARCHAR,
	IN pa_apellidoP VARCHAR,
	IN pa_usuario VARCHAR,
	IN pa_correo VARCHAR,
	IN pa_password VARCHAR,
	OUT pa_codeError INT,
	OUT pa_message TEXT
) AS
$$
BEGIN
	IF EXISTS (SELECT 1 FROM login_schema.usuarios WHERE fcUsuario = pa_usuario) THEN
		pa_codeError := 1;
		pa_message := 'El usuario ya se encuentra registrado';
	ELSIF EXISTS (SELECT 1 FROM login_schema.usuarios WHERE fcCorreo = pa_correo) THEN
		pa_codeError := 2;
		pa_message := 'El correo ya se encuentra registrado';
	ELSE
		INSERT INTO login_schema.usuarios (fcNombre, fcApellidoM, fcApellidoP, fcUsuario, fcCorreo, fcPassword)
		VALUES(pa_nombre, pa_apellidoM, pa_apellidoP, pa_usuario, pa_correo, pa_password);
		pa_codeError := 0;
		pa_message := 'Usuario creado correctamente';
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		pa_codeError := -1;
		pa_message := 'Error al crear el usuario: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

--Eliminamos el sp en caso de que cambien los parametros
DROP PROCEDURE login_schema.crearusuario(character varying,character varying,character varying,character varying,character varying,character varying);

-----------------------------------------------------------
-- Llamamos el sp
CALL login_schema.crearUsuario('Laura', 'Diaz', 'Vazquez', 'LauVazquez', 'LauraDiaz@gmail.com', '123456789', CAST(NULL AS INT), CAST(NULL AS TEXT));