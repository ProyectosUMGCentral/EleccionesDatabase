IF OBJECT_ID('dbo.sp_emision_voto') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_emision_voto
	IF OBJECT_ID('dbo.sp_emision_voto') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_emision_voto >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_emision_voto >>>'
END
GO

CREATE PROCEDURE sp_emision_voto(
	@i_num_identificacion VARCHAR(13),
    @i_centro_votacion INT,
    @i_terminal_voto INT,
    @i_candidato INT,
    @i_eleccion INT
)
AS
/*
 _______________________________________________________________________________
|																				|
| Archivo:					sp_emision_voto.sql							        |
| Stored Procedure:			sp_emision_voto								        |
| Base de datos:			Sistema_Electoral									|
| Disenado por:				Luis Monzón											|
| Fecha de escritura:		27/05/2022											|
|_______________________________________________________________________________|

*/
BEGIN
    DECLARE @w_cliente_id INT
    BEGIN TRY

        BEGIN TRANSACTION

        SELECT @w_cliente_id = ec_id
        FROM el_ciudadano
        WHERE ec_num_identificacion = @i_num_identificacion

        IF(@w_cliente_id IS NULL)
        BEGIN
            RAISERROR('PERSONA NO REGISTRADA EN BASE DE DATOS DE CIUDADANOS LEGALMENTE INSCRITOS', 16, 1)
        END

        IF NOT EXISTS(
            SELECT 1
            FROM el_centro_votacion
            WHERE ecv_id = @i_centro_votacion
        )
        BEGIN
            RAISERROR('CENTRO DE VOTACION INEXISTENTE', 16, 1)
        END

        IF NOT EXISTS(
            SELECT 1
            FROM el_terminal_voto
            WHERE etv_id = @i_terminal_voto
            AND ecv_id = @i_centro_votacion
        )
        BEGIN
            RAISERROR('TERMINAL DE VOTO NO VALIDA', 16, 1)
        END

        IF EXISTS(
            SELECT 1
            FROM el_bitacora_votacion
            WHERE ec_id = @w_cliente_id
            AND eel_id = @i_eleccion
        )
        BEGIN
            RAISERROR('CIUDADANO YA EMITIÓ SU VOTO EN LAS ELECCIONES ACTUALES', 16, 1)
        END

        

        COMMIT TRAN

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

IF OBJECT_ID('dbo.sp_emision_voto') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_emision_voto >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_emision_voto >>>'
GO