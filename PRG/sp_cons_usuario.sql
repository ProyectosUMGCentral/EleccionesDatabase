IF OBJECT_ID('dbo.sp_cons_usuario') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_cons_usuario
	IF OBJECT_ID('dbo.sp_cons_info') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_cons_usuario >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_cons_usuario >>>'
END
GO

create procedure dbo.sp_cons_usuario
(
   @emial varchar(125),
   @password varchar(255)
)
as
begin 
	select
	      eu_id,	
	      eu_email
	from el_usuario
	where eu_email = @emial
	      and eu_contrasena = @password
end

IF OBJECT_ID('dbo.sp_cons_usuario') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_cons_usuario >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_cons_usuario >>>'
GO