SELECT * FROM at_t_InvLoad

ALTER TABLE at_t_InvLoad ADD PalType tinyint 
--ALTER TABLE at_t_InvLoad DROP COLUMN PalType
--ALTER TABLE at_t_InvLoad DROP CONSTRAINT DF_at_t_InvLoad_PalType
--ALTER TABLE at_t_InvLoad DROP CONSTRAINT CK_at_t_InvLoad_PalType
ALTER TABLE at_t_InvLoad ADD CONSTRAINT DF_at_t_InvLoad_PalType DEFAULT 200 FOR PalType
ALTER TABLE at_t_InvLoad ADD CONSTRAINT CK_at_t_InvLoad_PalType CHECK (PalType in(200, 201))

ALTER TABLE at_t_InvLoad ADD CarPayload tinyint 
--ALTER TABLE at_t_InvLoad DROP COLUMN CarPayload
--ALTER TABLE at_t_InvLoad DROP CONSTRAINT CK_at_t_InvLoad_CarPayload
ALTER TABLE at_t_InvLoad ADD CONSTRAINT CK_at_t_InvLoad_CarPayload CHECK (PalType BETWEEN 1 AND 20)

ALTER TABLE at_t_InvLoad ADD PalQtyMAX tinyint
ALTER TABLE at_t_InvLoad ADD CONSTRAINT CK_at_t_InvLoad_PalQtyMAX CHECK (PalQtyMAX BETWEEN 1 AND 32)