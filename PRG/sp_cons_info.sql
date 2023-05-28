IF OBJECT_ID('dbo.sp_cons_info') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sp_cons_info
	IF OBJECT_ID('dbo.sp_cons_info') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_cons_info >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_cons_info >>>'
END
GO

CREATE PROCEDURE sp_cons_info(
	@i_modo_consulta VARCHAR(200)
)
AS
/*
 _______________________________________________________________________________
|																				|
| Archivo:					sp_cons_info.sql							        |
| Stored Procedure:			sp_cons_info								        |
| Base de datos:			Sistema_Electoral									|
| Disenado por:				Luis Monzón											|
| Fecha de escritura:		27/05/2022											|
|_______________________________________________________________________________|

*/
BEGIN
    DECLARE @w_cliente_id INT
    BEGIN TRY

    SELECT 'TEST' = 'TEST'

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

IF OBJECT_ID('dbo.sp_cons_info') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE sp_cons_info >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE sp_cons_info >>>'
GO