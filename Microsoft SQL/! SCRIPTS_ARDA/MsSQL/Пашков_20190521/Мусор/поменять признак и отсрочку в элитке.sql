

SELECT CodeID4 FROM r_Comps where CompID = 14009

BEGIN TRAN

update r_Comps set CodeID4 = 5012 where CompID = 14009
update r_Comps set CodeID4 = 5049 where CompID = 14041
update r_Comps set CodeID4 = 5012 where CompID = 14074
update r_Comps set CodeID4 = 5012 where CompID = 14080
update r_Comps set CodeID4 = 5012 where CompID = 14084
update r_Comps set CodeID4 = 5014 where CompID = 14106
update r_Comps set CodeID4 = 5012 where CompID = 14126
update r_Comps set CodeID4 = 5011 where CompID = 14129
update r_Comps set CodeID4 = 5012 where CompID = 14282
update r_Comps set CodeID4 = 5012 where CompID = 14512
update r_Comps set CodeID4 = 5049 where CompID = 14518
update r_Comps set CodeID4 = 5030 where CompID = 14905
update r_Comps set CodeID4 = 5014 where CompID = 14993
update r_Comps set CodeID4 = 5012 where CompID = 44376
update r_Comps set CodeID4 = 5012 where CompID = 44433
update r_Comps set CodeID4 = 5030 where CompID = 44442
update r_Comps set CodeID4 = 5012 where CompID = 44450
update r_Comps set CodeID4 = 5014 where CompID = 44487
update r_Comps set CodeID4 = 5012 where CompID = 44611
update r_Comps set CodeID4 = 5012 where CompID = 44631
update r_Comps set CodeID4 = 5012 where CompID = 44695
update r_Comps set CodeID4 = 5012 where CompID = 44729
update r_Comps set CodeID4 = 5012 where CompID = 44904
update r_Comps set CodeID4 = 5012 where CompID = 44911
update r_Comps set CodeID4 = 5012 where CompID = 44962
update r_Comps set CodeID4 = 5012 where CompID = 44985
update r_Comps set CodeID4 = 5011 where CompID = 44990
update r_Comps set CodeID4 = 5013 where CompID = 66000
update r_Comps set CodeID4 = 5012 where CompID = 66048
update r_Comps set CodeID4 = 5022 where CompID = 66049
update r_Comps set CodeID4 = 5012 where CompID = 66053
update r_Comps set CodeID4 = 5011 where CompID = 66079
update r_Comps set CodeID4 = 5012 where CompID = 66080
update r_Comps set CodeID4 = 5012 where CompID = 66081
update r_Comps set CodeID4 = 5012 where CompID = 66099
update r_Comps set CodeID4 = 5049 where CompID = 66198
update r_Comps set CodeID4 = 5049 where CompID = 66208
update r_Comps set CodeID4 = 5012 where CompID = 66244
update r_Comps set CodeID4 = 5049 where CompID = 66250
update r_Comps set CodeID4 = 5030 where CompID = 66271
update r_Comps set CodeID4 = 5014 where CompID = 66292
update r_Comps set CodeID4 = 5012 where CompID = 66295
update r_Comps set CodeID4 = 5011 where CompID = 66304
update r_Comps set CodeID4 = 5012 where CompID = 66312
update r_Comps set CodeID4 = 5030 where CompID = 66329
update r_Comps set CodeID4 = 5015 where CompID = 66331
update r_Comps set CodeID4 = 5012 where CompID = 66336
update r_Comps set CodeID4 = 5012 where CompID = 66342
update r_Comps set CodeID4 = 5012 where CompID = 66359
update r_Comps set CodeID4 = 5030 where CompID = 66385
update r_Comps set CodeID4 = 5012 where CompID = 66399
update r_Comps set CodeID4 = 5023 where CompID = 66403
update r_Comps set CodeID4 = 5012 where CompID = 66407
update r_Comps set CodeID4 = 5030 where CompID = 66409
update r_Comps set CodeID4 = 5013 where CompID = 66411
update r_Comps set CodeID4 = 5013 where CompID = 66412
update r_Comps set CodeID4 = 5012 where CompID = 66427
update r_Comps set CodeID4 = 5012 where CompID = 66451
update r_Comps set CodeID4 = 5012 where CompID = 66455
update r_Comps set CodeID4 = 5012 where CompID = 66462
update r_Comps set CodeID4 = 5012 where CompID = 66469
--update r_Comps set CodeID4 = 5012 where CompID = 66471
update r_Comps set CodeID4 = 5012 where CompID = 66485
update r_Comps set CodeID4 = 5012 where CompID = 66504
update r_Comps set CodeID4 = 5030 where CompID = 66511
update r_Comps set CodeID4 = 5049 where CompID = 66520
update r_Comps set CodeID4 = 5011 where CompID = 66531
update r_Comps set CodeID4 = 5030 where CompID = 66555
update r_Comps set CodeID4 = 5030 where CompID = 66558
update r_Comps set CodeID4 = 5030 where CompID = 66559
update r_Comps set CodeID4 = 5011 where CompID = 66565
update r_Comps set CodeID4 = 5030 where CompID = 66568
update r_Comps set CodeID4 = 5011 where CompID = 66575
update r_Comps set CodeID4 = 5012 where CompID = 66582
update r_Comps set CodeID4 = 5012 where CompID = 66584
update r_Comps set CodeID4 = 5030 where CompID = 66585
update r_Comps set CodeID4 = 5012 where CompID = 66593
update r_Comps set CodeID4 = 5030 where CompID = 66596



ROLLBACK TRAN


SELECT PayDelay, PayDelay2  FROM dbo.at_r_CompOurTerms   where OurID = 1 and CompID = 14009


BEGIN TRAN


update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 14009
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 14041
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 14074
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 14080
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 14084
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 14106
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 14126
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 14129
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 14282
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 14512
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 14518
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 14905
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 14993
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44376
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44433
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 44442
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44450
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 44487
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44611
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44631
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44695
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44729
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44904
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44911
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44962
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 44985
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 44990
update  dbo.at_r_CompOurTerms  set PayDelay = 21, PayDelay2 = 14 where OurID = 1 and CompID = 66000
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66048
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66049
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66053
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66079
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66080
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66081
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66099
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66198
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66208
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66244
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66250
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66271
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66292
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66295
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66304
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66312
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66329
update  dbo.at_r_CompOurTerms  set PayDelay = 21, PayDelay2 = 9 where OurID = 1 and CompID = 66331
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66336
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66342
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66359
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66385
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66399
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66403
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66407
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66409
update  dbo.at_r_CompOurTerms  set PayDelay = 21, PayDelay2 = 14 where OurID = 1 and CompID = 66411
update  dbo.at_r_CompOurTerms  set PayDelay = 21, PayDelay2 = 14 where OurID = 1 and CompID = 66412
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66427
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66451
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66455
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66462
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66469
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66471
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66485
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66504
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66511
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66520
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66531
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66555
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66558
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66559
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66565
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66568
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 23 where OurID = 1 and CompID = 66575
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66582
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66584
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66585
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 14 where OurID = 1 and CompID = 66593
update  dbo.at_r_CompOurTerms  set PayDelay = 30, PayDelay2 = 9 where OurID = 1 and CompID = 66596

ROLLBACK TRAN
