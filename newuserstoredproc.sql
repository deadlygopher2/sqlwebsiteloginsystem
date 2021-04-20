CREATE PROCEDURE [dbo].[uspAddUser]
    @pLogin NVARCHAR(50), 
    @pPassword NVARCHAR(50),
    @pFirstName NVARCHAR(40) = NULL, 
    @pLastName NVARCHAR(40) = NULL,
	@pEmail NVARCHAR(4000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS

	IF (SELECT COUNT (LoginName) FROM dbo.[User] WHERE LoginName = @pLogin) = 0

BEGIN
    SET NOCOUNT ON

    DECLARE @salt UNIQUEIDENTIFIER=NEWID()

	BEGIN TRY

        INSERT INTO dbo.[User] (LoginName, PasswordHash, Salt, FirstName, LastName, email)
        VALUES(@pLogin, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pFirstName, @pLastName, @pEmail)

       SET @responseMessage='Success'

    END TRY

    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END

ELSE

SET @responseMessage='useracerr1'
