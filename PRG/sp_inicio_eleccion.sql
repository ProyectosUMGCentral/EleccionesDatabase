IF OBJECT_ID('dbo.sp_inicio_eleccion') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_inicio_eleccion
	IF OBJECT_ID('dbo.sp_inicio_eleccion') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_inicio_eleccion >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_inicio_eleccion >>>'
END
GO

CREATE PROCEDURE sp_inicio_eleccion(
	@i_id_eleccion INT
)
AS
/*
 _______________________________________________________________________________
|																				|
| Archivo:					sp_inicio_eleccion.sql							    |
| Stored Procedure:			sp_inicio_eleccion								    |
| Base de datos:			Sistema_Electoral									|
| Disenado por:				Luis Monzón											|
| Fecha de escritura:		27/05/2022											|
|_______________________________________________________________________________|

*/
BEGIN
    BEGIN TRY

        BEGIN TRANSACTION

        IF NOT EXISTS(
            SELECT 1
            FROM el_eleccion
            WHERE eel_id = @i_id_eleccion
        )
        BEGIN
            RAISERROR('EL PROCESO DE ELECCIONES NO EXISTE', 16, 1)
        END

        IF EXISTS(
            SELECT 1
            FROM el_eleccion
            WHERE eel_id = @i_id_eleccion
            AND eel_activo = 1
        )
        BEGIN
            RAISERROR('EL PROCESO DE ELECCIONES SE ENCUENTRA ACTIVO', 16, 1)
        END
        
        UPDATE el_eleccion
        SET eel_activo = 1
        WHERE eel_id = @i_id_eleccion

        SELECT 'RESULTADO' = 'INICIO DE ELECCIONES SATISFACTORIA'

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

IF OBJECT_ID('dbo.sp_inicio_eleccion') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_inicio_eleccion >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_inicio_eleccion >>>'
GO