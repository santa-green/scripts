CREATE FUNCTION [dbo].[intToHex]  
(  
    @value AS INT  
) RETURNS VARCHAR(MAX) AS BEGIN  
   
    DECLARE @characters CHAR(36),  
            @hex VARCHAR(MAX);  
  
    SELECT @characters = '0123456789abcdefghijklmnopqrstuvwxyz',  
           @hex= '';  

    IF @value < 0 RETURN NULL;  
  
    WHILE @value > 0  
        SELECT @hex= SUBSTRING(@characters, @value % 2 + 1, 1) + @hex,  
               @value = @value / 2;  
   
    RETURN @hex;  
  
END;


select [dbo].[intToHex](16)