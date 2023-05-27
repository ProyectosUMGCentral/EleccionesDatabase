CREATE TABLE el_pais(
	ep_id INT NOT NULL IDENTITY(1,1),
	ep_nombre VARCHAR(75) NOT NULL,
	PRIMARY KEY(ep_id)
);

CREATE TABLE el_estado(
	ee_id INT NOT NULL IDENTITY(1,1),
	ep_id INT NOT NULL,
	ee_nombre VARCHAR(75) NOT NULL,
	PRIMARY KEY(ee_id),
	CONSTRAINT FK_el_estado_pais FOREIGN KEY(ep_id) REFERENCES el_pais(ep_id)
);

CREATE TABLE el_municipio(
	em_id INT NOT NULL IDENTITY(1,1),
	ee_id INT NOT NULL,
	em_nombre VARCHAR(75) NOT NULL,
	PRIMARY KEY(em_id),
	CONSTRAINT FK_el_municipio_estado FOREIGN KEY(ee_id) REFERENCES el_estado(ee_id)
);

CREATE TABLE el_tipo_identificacion(
	eti_id INT NOT NULL IDENTITY(1,1),
	eti_nombre VARCHAR(50) NOT NULL,
	eli_abreviatura VARCHAR(5),
	PRIMARY KEY(eti_id)
);

CREATE TABLE el_ciudadano(
	ec_id INT NOT NULL IDENTITY(1,1),
	eti_id INT NOT NULL,
	em_id INT NOT NULL,
	ec_num_identificacion VARCHAR(25) NOT NULL,
	ec_nombre1 VARCHAR(75) NOT NULL,
	ec_nombre2 VARCHAR(75),
	ec_nombre3 VARCHAR(75),
	ec_apellido1 VARCHAR(75) NOT NULL,
	ec_apellido2 VARCHAR(75),
	ec_apellido3 VARCHAR(75),
	ec_fecha_nac DATE NOT NULL,
	ec_correo_electronico VARCHAR(75),
	ec_num_tel VARCHAR(8),
	PRIMARY KEY(ec_id), 
	CONSTRAINT FK_el_ciudadano_tipoID FOREIGN KEY(eti_id) REFERENCES el_tipo_identificacion(eti_id),
	CONSTRAINT FK_el_ciudadano_municipio FOREIGN KEY(em_id) REFERENCES el_municipio(em_id)
);

CREATE TABLE el_partido_politico(
	epp_id INT NOT NULL IDENTITY(1,1),
	epp_nombre VARCHAR(70) NOT NULL,
	epp_abreviatura VARCHAR(5),
	PRIMARY KEY(epp_id)
);

CREATE TABLE el_sistema_electoral(
	ese_id INT NOT NULL IDENTITY(1,1),
	ese_nombre VARCHAR(100) NOT NULL,
	ese_feha_inicio DATE NOT NULL,
	ese_fecha_fin DATE NOT NULL,
	PRIMARY KEY(ese_id)
);

CREATE TABLE el_sistema_votacion(
	esv_id INT NOT NULL IDENTITY(1,1),
	ese_id INT NOT NULL,
	esv_nombre VARCHAR(75) NOT NULL,
	esv_desc VARCHAR(100) NOT NULL,
	PRIMARY KEY(esv_id),
	CONSTRAINT FK_el_sistema_elec_vot FOREIGN KEY(ese_id) REFERENCES el_sistema_electoral(ese_id),
	CONSTRAINT UC_ese_id UNIQUE(ese_id)
);

CREATE TABLE el_eleccion(
	eel_id INT NOT NULL IDENTITY(1,1),
	ese_id INT NOT NULL,
	eel_nombre VARCHAR(75) NOT NULL,
	eel_fecha DATE NOT NULL,
	eel_activo BIT NOT NULL,
	PRIMARY KEY(eel_id),
	CONSTRAINT FK_sistema_electoral FOREIGN KEY(ese_id) REFERENCES el_sistema_electoral(ese_id)
);

CREATE TABLE el_cargo(
	eca_id INT NOT NULL IDENTITY(1,1),
	eel_id INT NOT NULL,
	eca_nombre_Cargo VARCHAR(75) NOT NULL,
	eca_descripcion VARCHAR(100) NOT NULL,
	PRIMARY KEY(eca_id),
	CONSTRAINT FK_eleccion_cargo FOREIGN KEY(eel_id) REFERENCES el_eleccion(eel_id)
);

CREATE TABLE el_candidato(
	ecan_id INT NOT NULL IDENTITY(1,1),
	epp_id INT,
	ec_id INT NOT NULL,
	eca_id INT NOT NULL,
	PRIMARY KEY(ecan_id),
	CONSTRAINT FK_Partido_Politico FOREIGN KEY(epp_id) REFERENCES el_partido_politico(epp_id),
	CONSTRAINT FK_candidato_ciudadano FOREIGN KEY(ec_id) REFERENCES el_ciudadano(ec_id),
	CONSTRAINT FK_candidato_cargo FOREIGN KEY(eca_id) REFERENCES el_cargo(eca_id)
);

CREATE TABLE el_centro_votacion(
	ecv_id INT NOT NULL IDENTITY(1,1),
	em_id INT NOT NULL,
	ecv_nombre VARCHAR(75) NOT NULL,
	PRIMARY KEY(ecv_id),
	CONSTRAINT FK_Centro_Votacion_Municipio FOREIGN KEY(em_id) REFERENCES el_municipio(em_id)
);

CREATE TABLE el_terminal_voto(
	etv_id INT NOT NULL IDENTITY(1,1),
	ecv_id INT NOT NULL,
	etv_nombre VARCHAR(75) NOT NULL,
	PRIMARY KEY(etv_id),
	CONSTRAINT FK_Centro_Terminal_Voto FOREIGN KEY(ecv_id) REFERENCES el_centro_votacion(ecv_id)
);

CREATE TABLE el_cargo_autoridad_mesa(
	ecam_id INT NOT NULL IDENTITY(1,1),
	ecam_nombre VARCHAR(75) NOT NULL, 
	PRIMARY KEY(ecam_id)
);


CREATE TABLE el_rol(
	er_id INT NOT NULL IDENTITY(1,1),
	er_nombre VARCHAR(75) NOT NULL,
	PRIMARY KEY(er_id)
);

CREATE TABLE el_usuario(
	eu_id INT NOT NULL IDENTITY(1,1),
	eu_email VARCHAR(125) NOT NULL,
	eu_contrasena VARCHAR(255) NOT NULL,
	PRIMARY KEY(eu_id)
);

CREATE TABLE el_roles_usuario(
	eu_id INT NOT NULL,
	er_id INT NOT NULL,
	PRIMARY KEY(eu_id, er_id),
	CONSTRAINT FK_User FOREIGN KEY(eu_id) REFERENCES el_usuario(eu_id),
	CONSTRAINT FK_Rol FOREIGN KEY(er_id) REFERENCES el_rol(er_id)
);

CREATE TABLE el_autoridad_mesa(
	eam_id INT NOT NULL IDENTITY(1,1),
	ec_id INT NOT NULL,
	ecam_id INT NOT NULL,
	eu_id INT NOT NULL,
	PRIMARY KEY(eam_id),
	CONSTRAINT FK_Autoridad_Citizen FOREIGN KEY(ec_id) REFERENCES el_ciudadano(ec_id),
	CONSTRAINT FK_Cargo_Autoridad_Mesa FOREIGN KEY(ecam_id) REFERENCES el_cargo_autoridad_mesa(ecam_id),
	CONSTRAINT FK_Autoridad_User FOREIGN KEY(eu_id) REFERENCES el_usuario(eu_id)
);

CREATE TABLE el_bitacora_votacion(
	ec_id INT NOT NULL,
	eel_id INT NOT NULL,
	ebv_participo_votacion BIT NOT NULL,
	PRIMARY KEY(ec_id, eel_id),
	CONSTRAINT FK_Bitacora_Citizen FOREIGN KEY(ec_id) REFERENCES el_ciudadano(ec_id),
	CONSTRAINT FK_Bitacora_Eleccion FOREIGN KEY(eel_id) REFERENCES el_eleccion(eel_id)
);

CREATE TABLE el_votos(
	ecan_id INT NOT NULL,
	eel_id INT NOT NULL,
	etv_id INT NOT NULL,
	eam_id INT NOT NULL,
	ev_valido BIT NOT NULL,
	PRIMARY KEY(ecan_id, eel_id),
	CONSTRAINT FK_Voto_Candidato FOREIGN KEY(ecan_id) REFERENCES el_candidato(ecan_id),
	CONSTRAINT FK_Voto_Eleccion FOREIGN KEY(eel_id) REFERENCES el_eleccion(eel_id),
	CONSTRAINT FK_Voto_Terminal FOREIGN KEY(etv_id) REFERENCES el_terminal_voto(etv_id),
	CONSTRAINT FK_Voto_Autoridad_Mesa FOREIGN KEY(eam_id) REFERENCES el_autoridad_mesa(eam_id)
);