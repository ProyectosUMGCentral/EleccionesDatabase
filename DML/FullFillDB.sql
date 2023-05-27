-- INSERT INTO el_pais
INSERT INTO el_pais (ep_nombre)
VALUES ('Guatemala');

-- INSERT INTO el_estado
INSERT INTO el_estado (ep_id, ee_nombre)
VALUES (1, 'Guatemala'), (1, 'Baja Verapaz'), (1, 'Chimaltenango'), (1, 'Chiquimula'), (1, 'El Progreso'), (1, 'Escuintla'),
       (1, 'Guatemala'), (1, 'Huehuetenango'), (1, 'Izabal'), (1, 'Jalapa'), (1, 'Jutiapa'), (1, 'Petén'), (1, 'Quetzaltenango'),
       (1, 'Quiché'), (1, 'Retalhuleu'), (1, 'Sacatepéquez'), (1, 'San Marcos'), (1, 'Santa Rosa'), (1, 'Sololá'), (1, 'Suchitepéquez'),
       (1, 'Totonicapán'), (1, 'Zacapa');

-- INSERT INTO el_municipio
INSERT INTO el_municipio (ee_id, em_nombre)
VALUES (1, 'Guatemala'), (1, 'Mixco'), (1, 'Villa Nueva'), (13, 'Quetzaltenango'), (1, 'San Miguel Petapa'), (1, 'Escuintla');

-- INSERT INTO el_tipo_identificacion
INSERT INTO el_tipo_identificacion (eti_nombre, eli_abreviatura)
VALUES ('Documento de Identificación Personal', 'DPI');

-- INSERT INTO el_ciudadano
INSERT INTO el_ciudadano (eti_id, em_id, ec_num_identificacion, ec_nombre1, ec_nombre2, ec_nombre3, ec_apellido1, ec_apellido2, ec_apellido3, ec_fecha_nac, ec_correo_electronico, ec_num_tel)
VALUES (1, 1, '123456789101', 'Juan', 'Carlos', 'Pérez', 'González', NULL, 'López', '1980-01-01', 'juan.perez@example.com', '12345678'),
       (1, 1, '987654321012', 'María', 'Isabel', 'González', 'Hernández', 'López', 'Pérez', '1995-05-15', 'maria.gonzalez@example.com', '98765432'),
       (1, 1, '456789123103', 'Pedro', 'Alejandro', 'López', 'Hernández', NULL, NULL, '1988-09-10', 'pedro.lopez@example.com', '45678912'),
       (1, 1, '9876543210987', 'Sandra', NULL, NULL, 'Torres', NULL, NULL, '1970-05-15', 'sandra.torres@example.com', '87654321');

-- INSERT INTO el_partido_politico
INSERT INTO el_partido_politico (epp_nombre, epp_abreviatura)
VALUES ('Partido de Avanzada Nacional', 'PAN'),
       ('Unidad Nacional de la Esperanza', 'UNE'),
       ('Frente de Convergencia Nacional', 'FCN'),
       ('Partido Unionista', 'PU'),
       ('Movimiento para la Liberación de los Pueblos', 'MLP');

-- INSERT INTO el_sistema_electoral
INSERT INTO el_sistema_electoral (ese_nombre, ese_feha_inicio, ese_fecha_fin)
VALUES ('Elecciones Generales 2023', '2023-07-01', '2023-07-31');

-- INSERT INTO el_sistema_votacion
INSERT INTO el_sistema_votacion (ese_id, esv_nombre, esv_desc, esv_activo)
VALUES (1, 'Sistema de Voto Electrónico', 'Sistema de votación electrónica para las elecciones generales 2023', 1);

-- INSERT INTO el_eleccion
INSERT INTO el_eleccion (ese_id, eel_nombre, eel_fecha)
VALUES (1, 'Elecciones Presidenciales', '2023-07-15');


-- INSERT INTO el_cargo
INSERT INTO el_cargo (eel_id, eca_nombre_Cargo, eca_descripcion) 
VALUES (1, 'Presidente', 'Cargo de presidente de la República');

-- INSERT INTO el_candidato
INSERT INTO el_candidato (epp_id, ec_id, eca_id)
VALUES (2, 4, 1), (2, 1, 1);

-- INSERT INTO el_centro_votacion
INSERT INTO el_centro_votacion (em_id, ecv_nombre)
VALUES (1, 'Centro Votación 1'), (2, 'Centro Votación 2');

-- INSERT INTO el_terminal_voto
INSERT INTO el_terminal_voto (ecv_id, etv_nombre)
VALUES (1, 'Terminal Voto 1'), (2, 'Terminal Voto 2');

-- INSERT INTO el_cargo_autoridad_mesa
INSERT INTO el_cargo_autoridad_mesa (ecam_nombre)
VALUES ('Cargo Autoridad Mesa 1'), ('Cargo Autoridad Mesa 2');

-- INSERT INTO el_rol
INSERT INTO el_rol (er_nombre)
VALUES ('Rol 1'), ('Rol 2');

-- INSERT INTO el_usuario
INSERT INTO el_usuario (eu_email, eu_contrasena)
VALUES ('usuario1@example.com', 'contrasena1'), ('usuario2@example.com', 'contrasena2');

-- INSERT INTO el_roles_usuario
INSERT INTO el_roles_usuario (eu_id, er_id)
VALUES (1, 1), (2, 2);

-- INSERT INTO el_autoridad_mesa
INSERT INTO el_autoridad_mesa (ec_id, ecam_id, eu_id)
VALUES (1, 1, 1), (2, 2, 2);

-- -- INSERT INTO el_bitacora_votacion
-- INSERT INTO el_bitacora_votacion (ec_id, eel_id, ebv_participo_votacion)
-- VALUES (1, 1, 1), (2, 2, 0);

-- -- INSERT INTO el_votos
-- INSERT INTO el_votos (eca_id, eel_id, etv_id, eam_id, ev_valido)
-- VALUES (1, 1, 1, 1, 1), (2, 2, 2, 2, 0);
