create procedure sp_cons_ciudadano
(
 @identificacion varchar(25)
)
as
begin
	select 
		ec_id,
		eti_id,
		em_id,
		ec_num_identificacion,
		ec_nombre1,
		ec_nombre2,
		ec_nombre3,
		ec_apellido1,
		ec_apellido2,
		ec_apellido3,
		ec_fecha_nac,
		ec_correo_electronico,
		ec_num_tel 
	from el_ciudadano
	where ec_num_identificacion = @identificacion
end