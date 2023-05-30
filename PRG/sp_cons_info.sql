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
	@i_modo_consulta VARCHAR(50),
    @i_centro_votacion INT = NULL
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
    BEGIN TRY

    IF @i_modo_consulta NOT IN ('CONTEO-VOTOS', 'PORCENTAJE-CV')
    BEGIN
        RAISERROR('MODO DE CONSULTA NO VALIDO', 16, 1)
    END

    IF @i_modo_consulta = 'CONTEO-VOTOS'
    BEGIN

        SELECT 'Cantidad-Votos' = COUNT(*)
        FROM el_centro_votacion ecv
        INNER JOIN el_terminal_voto etv ON etv.ecv_id = ecv.ecv_id
        INNER JOIN el_votos ev ON ev.etv_id = etv.etv_id
        WHERE ecv.ecv_id = @i_centro_votacion OR @i_centro_votacion IS NULL

        RETURN 1
        
    END

    IF @i_modo_consulta = 'PORCENTAJE-CV'
    BEGIN

        IF @i_centro_votacion IS NULL
        BEGIN
            RAISERROR('DEBE INGRESAR CENTRO DE VOTACION PARA OBTENER EL PORCENTAJE DE CENTRO DE VOTACION', 16, 1)
        END

        DECLARE @total_votos INT

        SELECT @total_votos = COUNT(*)
        FROM el_centro_votacion ecv
        INNER JOIN el_terminal_voto etv ON etv.ecv_id = ecv.ecv_id
        INNER JOIN el_votos ev ON ev.etv_id = etv.etv_id
        WHERE ecv.ecv_id > 0

        SELECT 'Porcentaje' = (COUNT(*) * 100.0) / @total_votos
        FROM el_centro_votacion ecv
        INNER JOIN el_terminal_voto etv ON etv.ecv_id = ecv.ecv_id
        INNER JOIN el_votos ev ON ev.etv_id = etv.etv_id
        WHERE ecv.ecv_id = @i_centro_votacion

        RETURN 1
        
    END

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