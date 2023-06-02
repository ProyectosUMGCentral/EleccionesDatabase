IF OBJECT_ID('dbo.sp_cons_candidatos') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_cons_candidatos
	IF OBJECT_ID('dbo.sp_cons_info') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_cons_candidatos >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_cons_candidatos >>>'
END
GO



create procedure dbo.sp_cons_candidatos
(
 @CARGO INT = NULL,
 @MUNICIPIO INT = NULL,
 @DEPARTAMENTO INT = NULL
)
as
begin

	SELECT
	     B.eca_id,
	     B.eca_nombre_Cargo,
	     B.eca_descripcion,
		 C.ec_id,
		 C.ec_num_identificacion,
		 C.ec_nombre1,
		 C.ec_nombre2,
		 C.ec_nombre3,
		 C.ec_apellido1,
		 C.ec_apellido2,
		 C.ec_apellido3,
		 C.ec_fecha_nac,
		 C.ec_correo_electronico,
		 C.ec_num_tel, 
		 D.em_id,
		 D.em_nombre,
		 E.ee_id,
		 E.ee_nombre	 
	FROM el_candidato A
	 JOIN el_cargo B
	  ON A.eca_id = B.eca_id
	 JOIN el_ciudadano C
	  ON A.ec_id = C.ec_id
	 JOIN el_municipio D
	  ON C.em_id = D.em_id
	 JOIN  el_estado E
	  ON D.ee_id = E.ee_id
	WHERE ( B.eca_id = @CARGO OR @CARGO IS NULL )
	      AND ( D.em_id = @MUNICIPIO OR @MUNICIPIO IS NULL ) 
		  AND (  E.ee_id = @DEPARTAMENTO OR @DEPARTAMENTO IS NULL )
	
end


IF OBJECT_ID('dbo.sp_cons_candidatos') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_cons_candidatos >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_cons_candidatos >>>'
GO