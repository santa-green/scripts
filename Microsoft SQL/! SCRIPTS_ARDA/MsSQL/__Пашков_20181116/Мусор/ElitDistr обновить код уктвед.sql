SELECT FEAProdID FROM r_Prods_ where prodid = 632337

SELECT FEAProdID FROM t_PInP where prodid = 632337

if 1=0
BEGIN
update t_PInP set FEAProdID = '0902100010' where prodid = 632337
update t_PInP set FEAProdID = '0902100010' where prodid = 632340
update t_PInP set FEAProdID = '0902100010' where prodid = 632341
update t_PInP set FEAProdID = '0902100010' where prodid = 632342
update t_PInP set FEAProdID = '0902100010' where prodid = 632343
update t_PInP set FEAProdID = '0902100010' where prodid = 632346
update t_PInP set FEAProdID = '0902100010' where prodid = 632347
update t_PInP set FEAProdID = '0902100010' where prodid = 632363
update t_PInP set FEAProdID = '0902100010' where prodid = 632364
update t_PInP set FEAProdID = '0902100010' where prodid = 632378
update t_PInP set FEAProdID = '0902100010' where prodid = 632379
update t_PInP set FEAProdID = '0902100010' where prodid = 632380
update t_PInP set FEAProdID = '0902100010' where prodid = 632381
update t_PInP set FEAProdID = '0902100010' where prodid = 632382
update t_PInP set FEAProdID = '0902100090' where prodid = 632331
update t_PInP set FEAProdID = '0902100090' where prodid = 632349
update t_PInP set FEAProdID = '0902100090' where prodid = 632350
update t_PInP set FEAProdID = '0902100090' where prodid = 632352
update t_PInP set FEAProdID = '0902100090' where prodid = 632385
update t_PInP set FEAProdID = '0902100090' where prodid = 632386
update t_PInP set FEAProdID = '0902100090' where prodid = 632387
update t_PInP set FEAProdID = '0902100090' where prodid = 632389
update t_PInP set FEAProdID = '0902300010' where prodid = 632338
update t_PInP set FEAProdID = '0902300010' where prodid = 632339
update t_PInP set FEAProdID = '0902300010' where prodid = 632344
update t_PInP set FEAProdID = '0902300010' where prodid = 632345
update t_PInP set FEAProdID = '0902300010' where prodid = 632357
update t_PInP set FEAProdID = '0902300010' where prodid = 632359
update t_PInP set FEAProdID = '0902300010' where prodid = 632360
update t_PInP set FEAProdID = '0902300010' where prodid = 632361
update t_PInP set FEAProdID = '0902300010' where prodid = 632362
update t_PInP set FEAProdID = '0902300010' where prodid = 632369
update t_PInP set FEAProdID = '0902300010' where prodid = 632370
update t_PInP set FEAProdID = '0902300010' where prodid = 632371
update t_PInP set FEAProdID = '0902300010' where prodid = 632372
update t_PInP set FEAProdID = '0902300010' where prodid = 632373
update t_PInP set FEAProdID = '0902300010' where prodid = 632374
update t_PInP set FEAProdID = '0902300010' where prodid = 632375
update t_PInP set FEAProdID = '0902300010' where prodid = 632376
update t_PInP set FEAProdID = '0902300010' where prodid = 632377
update t_PInP set FEAProdID = '0902300010' where prodid = 632388
update t_PInP set FEAProdID = '0902300010' where prodid = 632406
update t_PInP set FEAProdID = '0902300090' where prodid = 632328
update t_PInP set FEAProdID = '0902300090' where prodid = 632329
update t_PInP set FEAProdID = '0902300090' where prodid = 632330
update t_PInP set FEAProdID = '0902300090' where prodid = 632332
update t_PInP set FEAProdID = '0902300090' where prodid = 632333
update t_PInP set FEAProdID = '0902300090' where prodid = 632334
update t_PInP set FEAProdID = '0902300090' where prodid = 632335
update t_PInP set FEAProdID = '0902300090' where prodid = 632336
update t_PInP set FEAProdID = '0902300090' where prodid = 632348
update t_PInP set FEAProdID = '0902300090' where prodid = 632351
update t_PInP set FEAProdID = '0902300090' where prodid = 632353
update t_PInP set FEAProdID = '0902300090' where prodid = 632354
update t_PInP set FEAProdID = '0902300090' where prodid = 632365
update t_PInP set FEAProdID = '0902300090' where prodid = 632366
update t_PInP set FEAProdID = '0902300090' where prodid = 632367
update t_PInP set FEAProdID = '0902300090' where prodid = 632368
update t_PInP set FEAProdID = '0902300090' where prodid = 632384
update t_PInP set FEAProdID = '2106909200' where prodid = 632355
update t_PInP set FEAProdID = '2106909200' where prodid = 632356
update t_PInP set FEAProdID = '2106909200' where prodid = 632358
update t_PInP set FEAProdID = '2106909200' where prodid = 632383

END

BEGIN TRAN
;DISABLE TRIGGER ALL ON r_Prods_;  

SELECT * FROM r_Prods_ where prodid in (632337,632340,632341,632342,632343,632346,632347,632363,632364,632378,632379,632380,632381,632382,632331,632349,632350,632352,632385,632386,632387,632389,632338,632339,632344,632345,632357,632359,632360,632361,632362,632369,632370,632371,632372,632373,632374,632375,632376,632377,632388,632406,632328,632329,632330,632332,632333,632334,632335,632336,632348,632351,632353,632354,632365,632366,632367,632368,632384,632355,632356,632358,632383)
update r_Prods_ set Notes = ProdName where prodid in (632337,632340,632341,632342,632343,632346,632347,632363,632364,632378,632379,632380,632381,632382,632331,632349,632350,632352,632385,632386,632387,632389,632338,632339,632344,632345,632357,632359,632360,632361,632362,632369,632370,632371,632372,632373,632374,632375,632376,632377,632388,632406,632328,632329,632330,632332,632333,632334,632335,632336,632348,632351,632353,632354,632365,632366,632367,632368,632384,632355,632356,632358,632383)

;ENABLE  TRIGGER ALL ON r_Prods_;

ROLLBACK TRAN


if 1=0
BEGIN
	
BEGIN TRAN


;DISABLE TRIGGER ALL ON r_Prods_;  

update r_Prods_ set FEAProdID = '0902100010' where prodid = 632337
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632340
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632341
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632342
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632343
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632346
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632347
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632363
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632364
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632378
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632379
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632380
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632381
update r_Prods_ set FEAProdID = '0902100010' where prodid = 632382
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632331
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632349
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632350
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632352
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632385
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632386
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632387
update r_Prods_ set FEAProdID = '0902100090' where prodid = 632389
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632338
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632339
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632344
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632345
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632357
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632359
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632360
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632361
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632362
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632369
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632370
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632371
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632372
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632373
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632374
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632375
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632376
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632377
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632388
update r_Prods_ set FEAProdID = '0902300010' where prodid = 632406
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632328
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632329
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632330
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632332
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632333
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632334
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632335
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632336
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632348
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632351
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632353
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632354
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632365
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632366
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632367
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632368
update r_Prods_ set FEAProdID = '0902300090' where prodid = 632384
update r_Prods_ set FEAProdID = '2106909200' where prodid = 632355
update r_Prods_ set FEAProdID = '2106909200' where prodid = 632356
update r_Prods_ set FEAProdID = '2106909200' where prodid = 632358
update r_Prods_ set FEAProdID = '2106909200' where prodid = 632383

;ENABLE  TRIGGER ALL ON r_Prods_;


ROLLBACK TRAN
END