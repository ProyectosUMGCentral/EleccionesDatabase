IF OBJECT_ID('dbo.sp_verifica_voto_ciudadano') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_verifica_voto_ciudadano
	IF OBJECT_ID('dbo.sp_verifica_voto_ciudadano') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_verifica_voto_ciudadano >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_verifica_voto_ciudadano >>>'
END
GO

CREATE PROCEDURE sp_verifica_voto_ciudadano(
	@i_num_identificacion VARCHAR(13),
    @i_eleccion INT
)
AS
/*
 _______________________________________________________________________________
|																				|
| Archivo:					sp_verifica_voto_ciudadano.sql							        |
| Stored Procedure:			sp_verifica_voto_ciudadano								        |
| Base de datos:			Sistema_Electoral									|
| Disenado por:				Luis Monzón											|
| Fecha de escritura:		27/05/2022											|
|_______________________________________________________________________________|

*/
BEGIN

    DECLARE @w_votante_id INT

    BEGIN TRY

    SELECT @w_votante_id = ec_id
    FROM el_ciudadano
    WHERE ec_num_identificacion = @i_num_identificacion

    IF(@w_votante_id IS NULL)
    BEGIN
        RAISERROR('PERSONA NO REGISTRADA EN BASE DE DATOS DE CIUDADANOS LEGALMENTE INSCRITOS', 16, 1)
    END

    IF NOT EXISTS(
        SELECT 1
        FROM el_eleccion
        WHERE eel_id = @i_eleccion
        AND eel_activo = 1
    )
    BEGIN
        RAISERROR('ELECCION AUN NO HA COMENZADO O YA NO SE ENCUENTRA ACTIVA.', 16, 1)
    END

    IF EXISTS(
            SELECT 1
            FROM el_bitacora_votacion
            WHERE ec_id = @w_votante_id
            AND eel_id = @i_eleccion
        )
    BEGIN
        SELECT 'RESULTADO' = '1'
        RETURN 0
    END

    SELECT 'RESULTADO' = '0'

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRAN

        DECLARE @ErrorMessage NVARCHAR(4000),  @ErrorSeverity INT;  
        SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();  
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);  

    END CATCH
END
GO

IF OBJECT_ID('dbo.sp_verifica_voto_ciudadano') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_verifica_voto_ciudadano >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_verifica_voto_ciudadano >>>'
GO