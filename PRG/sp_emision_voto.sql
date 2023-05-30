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
    @i_eleccion INT,
    @i_autoridad_mesa INT
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

        IF NOT EXISTS(
            SELECT 1
            FROM el_eleccion
            WHERE eel_id = @i_eleccion
            AND eel_activo = 1
        )
        BEGIN
            RAISERROR('ELECCION AUN NO HA COMENZADO O YA NO SE ENCUENTRA ACTIVA.', 16, 1)
        END

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
            FROM el_autoridad_mesa
            WHERE eam_id = @i_autoridad_mesa
        )
        BEGIN
            RAISERROR('AUTORIDAD DE MESA NO RECONOCIDO. ALERTA!', 17, 1)
        END

        IF NOT EXISTS(
            SELECT 1
            FROM el_terminal_voto
            WHERE etv_id = @i_terminal_voto
            AND ecv_id = @i_centro_votacion
        )
        BEGIN
            RAISERROR('TERMINAL DE VOTO NO VALIDA Y NO CORRESPONDE AL CENTRO DE VOTACION ACTUAL', 16, 1)
        END

        IF EXISTS(
            SELECT 1
            FROM el_bitacora_votacion
            WHERE ec_id = @w_cliente_id
            AND eel_id = @i_eleccion
        )
        BEGIN
            RAISERROR('CIUDADANO YA EMITIÓ SU VOTO EN LAS ELECCIONES ACTUALES', 16, 1) -- TODO CHECK
        END

        IF NOT EXISTS(
            SELECT 1
            FROM el_candidato
            WHERE ecan_id = @i_candidato
        )
        BEGIN
            RAISERROR('CANDIDATO NO EXISTE', 16, 1)
        END

        IF NOT EXISTS(
            SELECT 1
            FROM el_centro_votacion ecv
            INNER JOIN el_municipio em ON em.em_id = ecv.em_id
            INNER JOIN el_ciudadano ec ON ec.em_id = em.em_id
            WHERE ecv.ecv_id = @i_centro_votacion
            AND ec.ec_id = @w_cliente_id
        )
        BEGIN
            RAISERROR('Lo sentimos, pero la persona que está intentando votar no está asignada al centro de votación donde desea emitir su voto. Para poder participar en las elecciones, es necesario que estés asignado al centro de votación correspondiente a tu ubicación registrada. Te recomendamos verificar la información proporcionada y asegurarte de haber seleccionado el centro de votación correcto. Si tienes alguna pregunta o necesitas asistencia adicional, por favor acércate a nuestro personal encargado de las elecciones. ¡Gracias por tu comprensión y participación cívica!', 16, 1)
        END

        BEGIN TRANSACTION

        INSERT INTO el_votos
                            (ecan_id,       eel_id,     etv_id,     
                             eam_id,            ev_valido)
        VALUES              (@i_candidato,  @i_eleccion,    @i_terminal_voto,
                             @i_autoridad_mesa,     1)
        
        INSERT INTO el_bitacora_votacion 
                    (ec_id,         eel_id)
        VALUES      (@w_cliente_id, @i_eleccion)

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