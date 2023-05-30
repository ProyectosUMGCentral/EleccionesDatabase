IF OBJECT_ID('dbo.sp_finaliza_eleccion') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_finaliza_eleccion
	IF OBJECT_ID('dbo.sp_finaliza_eleccion') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_finaliza_eleccion >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_finaliza_eleccion >>>'
END
GO

CREATE PROCEDURE sp_finaliza_eleccion(
	@i_id_eleccion INT
)
AS
/*
 _______________________________________________________________________________
|																				|
| Archivo:					sp_finaliza_eleccion.sql							|
| Stored Procedure:			sp_finaliza_eleccion								|
| Base de datos:			Sistema_Electoral									|
| Disenado por:				Luis Monzón											|
| Fecha de escritura:		27/05/2022											|
|_______________________________________________________________________________|

*/
BEGIN
    BEGIN TRY

        IF NOT EXISTS(
            SELECT 1
            FROM el_eleccion
            WHERE eel_id = @i_id_eleccion
        )
        BEGIN
            RAISERROR('ELECCIONES NO ENCONTRADAS', 16, 1)
        END

        IF EXISTS(
            SELECT 1
            FROM el_eleccion
            WHERE eel_id = @i_id_eleccion
            AND eel_activo = 0
        )
        BEGIN
            RAISERROR('EL PROCESO DE ELECCIONES YA FINALIZÓ', 16, 1)
        END

        BEGIN TRANSACTION

        UPDATE el_eleccion
        SET eel_activo = 0
        WHERE eel_id = @i_id_eleccion

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

IF OBJECT_ID('dbo.sp_finaliza_eleccion') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_finaliza_eleccion >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_finaliza_eleccion >>>'
GO