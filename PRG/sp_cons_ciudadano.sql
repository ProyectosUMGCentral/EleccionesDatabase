IF OBJECT_ID('dbo.sp_cons_ciudadano') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_cons_ciudadano
	IF OBJECT_ID('dbo.sp_cons_info') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_cons_info >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_cons_info >>>'
END
GO


create procedure sp_cons_ciudadano
(
 @identificacion varchar(25)
)
as
begin
	select 
		A.ec_id,
		A.eti_id,
		A.em_id,
		A.ec_num_identificacion,
		A.ec_nombre1,
		A.ec_nombre2,
		A.ec_nombre3,
		A.ec_apellido1,
		A.ec_apellido2,
		A.ec_apellido3,
		A.ec_fecha_nac,
		A.ec_correo_electronico,
		A.ec_num_tel, 
		C.ee_id
	from el_ciudadano A
	     JOIN el_municipio B
		  ON A.em_id = B.em_id
		 JOIN el_estado C
		  ON B.ee_id = C.ee_id
	where ec_num_identificacion = @identificacion
end

IF OBJECT_ID('dbo.sp_cons_ciudadano') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_cons_info >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_cons_info >>>'
GO