DECLARE @f BIT = 1
DECLARE @one VARCHAR(256), @two VARCHAR(256), @three VARCHAR(256)
DECLARE @ekka VARCHAR(MAX) = 
'<RQ V="1">
<DAT DI="198" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="2"><I N="1" SM="20000" T="0"></I><E N="2"></E></C><TS>20191122100040</TS></DAT>
<DAT DI="199" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000001" N="2" NM="Вердегар Вино Він`я Вер де Луріеро б" PRC="15500" Q="2000" SM="31000" TX="1"></P><L N="3">Полная стоимость 440.00 грн.</L><L N="4">&quot;Простая акция&quot; 29%</L><L N="5">ЧЕК:100165449 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="КАРТКА" SM="31000" T="2"></M><E CS="1" FN="3000746583" N="8" NO="194" SE="24603" SM="31000" TS="20191122100254"><TX DTPR="5.00" DTSM="1476" TX="1" TXAL="2" TXPR="20.00" TXSM="4921" TXTY="0"></TX></E></C><TS>20191122100254</TS></DAT>
<DAT DI="200" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="Пакет 39х49 з малюнком" SM="300" TX="1"></P><P C="00000000000003" N="3" NM="Барон Ріказолі Вино Бро ліо Беттіно " SM="53500" TX="1"></P><L N="4">Полная стоимость 628.10 грн.</L><L N="5">&quot;Простая акция&quot; 14%</L><L N="6">ЧЕК:100165450 501-Каса 2 маг. &quot;Він</L><L N="7">таж&quot; DP</L><M N="8" NM="ЧЕК" SM="40000" T="1"></M><M N="9" NM="ГОТIВКА" RM="1200" SM="15000" T="0"></M><E CS="1" FN="3000746583" N="10" NO="195" SE="42710" SM="53800" TS="20191122101344"><TX DTPR="5.00" DTSM="2548" TX="1" TXAL="2" TXPR="20.00" TXSM="8542" TXTY="0"></TX></E></C><TS>20191122101344</TS></DAT>
<DAT DI="201" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000004" N="2" NM="Мартіні Асті Ігристе ви но DOCG 0P><L N="3">Полная стоимость 424.50 грн.</L><L N="4">&quot;Простая акция&quot; 34%</L><L N="5">ЧЕК:100165451 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="ГОТIВКА" RM="100" SM="28000" T="0"></M><E CS="1" FN="3000746583" N="8" NO="196" SE="22142" SM="27900" TS="20191122101540"><TX DTPR="5.00" DTSM="1329" TX="1" TXAL="2" TXPR="20.00" TXSM="4429" TXTY="0"></TX></E></C><TS>20191122101540</TS></DAT>
<DAT DI="202" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000005" N="2" NM="Погіс Віскі Ірландія 0>Полная стоимость 703.20 грн.</L><L N="4">&quot;Простая акция&quot; 36%</L><L N="5">ЧЕК:100165452 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="КАРТКА" SM="44850" T="2"></M><E CS="1" FN="3000746583" N="8" NO="197" SE="35595" SM="44850" TS="20191122102658"><TX DTPR="5.00" DTSM="2136" TX="1" TXAL="2" TXPR="20.00" TXSM="7119" TXTY="0"></TX></E></C><TS>20191122102658</TS></DAT>
<DAT DI="203" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000006" N="2" NM="Кузіно Макул Вино Кабер не Совіньон " SM="24000" TX="1"></P><L N="3">Полная стоимость 364.10 грн.</L><L N="4">&quot;Простая акция&quot; 34%</L><P C="00000000000007" N="5" NM="Луїс Феліп Едвардс Вино Каберне Сов" SM="40060" TX="1"></P><P C="00000000000002" N="6" NM="Пакет 39х49 з малюнком" SM="300" TX="1"></P><L N="7">ЧЕК:100165453 501-Каса 2 маг. &quot;Він</L><L N="8">таж&quot; DP</L><M N="9" NM="КАРТКА" SM="64360" T="2"></M><E CS="1" FN="3000746583" N="10" NO="198" SE="51092" SM="64360" TS="20191122102802"><TX DTPR="5.00" DTSM="3050" TX="1" TXAL="2" TXPR="20.00" TXSM="10218" TXTY="0"></TX></E></C><TS>20191122102802</TS></DAT>
<DAT DI="204" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="Пакет 39х49 з малюнком" SM="300" TX="1"></P><P C="00000000000008" N="3" NM="Канадська Горілка 40% 1л" SM="21850" TX="1"></P><L N="4">Полная стоимость 437.00 грн.</L><L N="5">&quot;Простая акция&quot; 50%</L><L N="6">ЧЕК:100165454 501-Каса 2 маг. &quot;Він</L><L N="7">таж&quot; DP</L><M N="8" NM="КАРТКА" SM="22150" T="2"></M><E CS="1" FN="3000746583" N="9" NO="199" SE="17592" SM="22150" TS="20191122103322"><TX DTPR="5.00" DTSM="1040" TX="1" TXAL="2" TXPR="20.00" TXSM="3518" TXTY="0"></TX></E></C><TS>20191122103322</TS></DAT>
<DAT DI="205" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000009" N="2" NM="Пакет 39х49 з малюнком" SM="279" TX="1"></P><L N="3">Полная стоимость 3.00 грн.</L><L N="4">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="5">ая 7%</L><P C="00000000000010" N="6" NM="Бакарді Ром Оакхарт 1л" SM="31900" TX="1"></P><L N="7">Полная стоимость 531.50 грн.</L><L N="8">&quot;Простая акция&quot; 39%</L><P C="00000000000011" N="9" NM="Кока-Кола напій безалко гольний 2л" SM="3116" TX="1"></P><L N="10">Полная стоимость 33.50 грн.</L><L N="11">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="12">ая 7%</L><L N="13">ЧЕК:100165455 501-Каса 2 маг. &quot;Він</L><L N="14">таж&quot; DP</L><M N="15" NM="КАРТКА" SM="35295" T="2"></M><E CS="1" FN="3000746583" N="16" NO="200" SE="28146" SM="35295" TS="20191122104032"><TX DTPR="5.00" DTSM="1519" TX="1" TXAL="2" TXPR="20.00" TXSM="5630" TXTY="0"></TX></E></C><TS>20191122104032</TS></DAT>
<DAT DI="206" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000012" N="2" NM="Гофрокорзина Вінтаж на 6 пляшок" SM="1000" TX="1"></P><P C="00000000000013" N="3" NM="Набір 3+3 Халвуд Напій шипучий фрук" SM="18000" TX="1"></P><L N="4">ЧЕК:100165456 501-Каса 2 маг. &quot;Він</L><L N="5">таж&quot; DP</L><M N="6" NM="КАРТКА" SM="19000" T="2"></M><E CS="1" FN="3000746583" N="7" NO="201" SE="15119" SM="19000" TS="20191122105156"><TX DTPR="5.00" DTSM="857" TX="1" TXAL="2" TXPR="20.00" TXSM="3024" TXTY="0"></TX></E></C><TS>20191122105156</TS></DAT>
<DAT DI="207" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000014" N="2" NM="Фанта напій безалкоголь ний 0N="3">Полная стоимость 13.00 грн.</L><L N="4">Супермаркет &quot;ДК Фиксированная&quot; 10%</L><P C="00000000000015" N="5" NM="Кент Сигарети Вайт" SM="4900" TX="1"></P><L N="6">ЧЕК:100165457 501-Каса 2 маг. &quot;Він</L><L N="7">таж&quot; DP</L><M N="8" NM="КАРТКА" SM="6070" T="2"></M><E CS="1" FN="3000746583" N="9" NO="202" SE="4864" SM="6070" TS="20191122105244"><TX DTPR="5.00" DTSM="233" TX="1" TXAL="2" TXPR="20.00" TXSM="973" TXTY="0"></TX></E></C><TS>20191122105244</TS></DAT>
<DAT DI="208" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000009" N="2" NM="Пакет 39х49 з малюнком" SM="279" TX="1"></P><L N="3">Полная стоимость 3.00 грн.</L><L N="4">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="5">ая 7%</L><P C="00000000000016" N="6" NM="Терра Вега Вино Шардоне біле 0TX="1"></P><L N="7">Полная стоимость 453.20 грн.</L><L N="8">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="9">ая 7%</L><L N="10">Супермаркет &quot;Скидка при покупке 2х</L><L N="11"> и более бутылок&quot; (количественная)</L><L N="12"> 2%</L><L N="13">ЧЕК:100165458 501-Каса 2 маг. &quot;Він</L><L N="14">таж&quot; DP</L><M N="15" NM="КАРТКА" SM="41585" T="2"></M><E CS="1" FN="3000746583" N="16" NO="203" SE="33014" SM="41585" TS="20191122110610"><TX DTPR="5.00" DTSM="1967" TX="1" TXAL="2" TXPR="20.00" TXSM="6604" TXTY="0"></TX></E></C><TS>20191122110610</TS></DAT>
<DAT DI="209" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000017" N="2" NM="Торт Наполеон 120гПолная стоимость 32.00 грн.</L><L N="4">Супермаркет &quot;ДК Фиксированная&quot; 10%</L><L N="5">ЧЕК:100165459 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="КАРТКА" SM="2880" T="2"></M><E CS="1" FN="3000746583" N="8" NO="204" SE="2400" SM="2880" TS="20191122111022"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="480" TXTY="0"></TX></E></C><TS>20191122111022</TS></DAT>
<DAT DI="210" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="Пакет 39х49 з малюнком" SM="300" TX="1"></P><P C="00000000000018" N="3" NM="Біджи Вино Орвієто Клас іко Амабілія" SM="18000" TX="1"></P><L N="4">Полная стоимость 225.00 грн.</L><L N="5">&quot;Простая акция&quot; 20%</L><P C="00000000000019" N="6" NM="Сандора Нектар Манго 1л" SM="3710" TX="1"></P><L N="7">ЧЕК:100165460 501-Каса 2 маг. &quot;Він</L><L N="8">таж&quot; DP</L><M N="9" NM="ГОТIВКА" SM="22010" T="0"></M><E CS="1" FN="3000746583" N="10" NO="205" SE="17628" SM="22010" TS="20191122111208"><TX DTPR="5.00" DTSM="857" TX="1" TXAL="2" TXPR="20.00" TXSM="3525" TXTY="0"></TX></E></C><TS>20191122111208</TS></DAT>
<DAT DI="211" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000020" N="2" NM="Зонін Ігристе вино Прос екко Брют 18" PRC="33000" Q="4000" SM="132000" TX="1"></P><P C="00000000000021" N="3" NM="Зонін Вино ігристе Прос екко Дресско" PRC="34200" Q="4000" SM="136800" TX="1"></P><L N="4">ЧЕК:100165461 501-Каса 2 маг. &quot;Він</L><L N="5">таж&quot; DP</L><M N="6" NM="КАРТКА" SM="268800" T="2"></M><E CS="1" FN="3000746583" N="7" NO="206" SE="213333" SM="268800" TS="20191122111504"><TX DTPR="5.00" DTSM="12800" TX="1" TXAL="2" TXPR="20.00" TXSM="42667" TXTY="0"></TX></E></C><TS>20191122111504</TS></DAT>
<DAT DI="212" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000022" N="2" NM="Кузіно Макул Вино Карме нер чер 0P><P C="00000000000023" N="3" NM="Дуруджі Велі Вино Кіндз мараулі черв" SM="18050" TX="1"></P><L N="4">ЧЕК:100165462 501-Каса 2 маг. &quot;Він</L><L N="5">таж&quot; DP</L><M N="6" NM="ГОТIВКА" RM="9150" SM="50000" T="0"></M><E CS="1" FN="3000746583" N="7" NO="207" SE="32421" SM="40850" TS="20191122111602"><TX DTPR="5.00" DTSM="1945" TX="1" TXAL="2" TXPR="20.00" TXSM="6484" TXTY="0"></TX></E></C><TS>20191122111602</TS></DAT>
<DAT DI="213" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000024" N="2" NM="Канадська Горілка 40% 1л" PRC="20800" Q="6000" SM="124800" TX="1"></P><L N="3">ЧЕК:100165463 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" RM="200" SM="125000" T="0"></M><E CS="1" FN="3000746583" N="6" NO="208" SE="99047" SM="124800" TS="20191122111626"><TX DTPR="5.00" DTSM="5943" TX="1" TXAL="2" TXPR="20.00" TXSM="19810" TXTY="0"></TX></E></C><TS>20191122111626</TS></DAT>
<DAT DI="214" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000025" N="2" NM="Есполон Текіла Репосадо 0="3">Полная стоимость 675.50 грн.</L><L N="4">&quot;Простая акция&quot; 14%</L><L N="5">ЧЕК:100165464 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="ГОТIВКА" RM="2580" SM="60000" T="0"></M><E CS="1" FN="3000746583" N="8" NO="209" SE="45572" SM="57420" TS="20191122112042"><TX DTPR="5.00" DTSM="2734" TX="1" TXAL="2" TXPR="20.00" TXSM="9114" TXTY="0"></TX></E></C><TS>20191122112042</TS></DAT>
<DAT DI="215" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000026" N="2" NM="Тістечко Кошик з кремом і горіхами " PRC="1500" Q="2000" SM="3000" TX="1"></P><L N="3">ЧЕК:100165465 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="КАРТКА" SM="3000" T="2"></M><E CS="1" FN="3000746583" N="6" NO="210" SE="2500" SM="3000" TS="20191122112844"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="500" TXTY="0"></TX></E></C><TS>20191122112844</TS></DAT>
<DAT DI="216" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000027" N="2" NM="Пакет 39х49 з малюнком" SM="291" TX="1"></P><L N="3">Полная стоимость 3.00 грн.</L><L N="4">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="5">ая 3%</L><P C="00000000000028" N="6" NM="Робер Саро Вино Божоле Нуво 2019 че" SM="18899" TX="1"></P><L N="7">Полная стоимость 235.00 грн.</L><L N="8">&quot;Простая акция&quot; 19%</L><L N="9">ЧЕК:100165466 501-Каса 2 маг. &quot;Він</L><L N="10">таж&quot; DP</L><M N="11" NM="ГОТIВКА" RM="31010" SM="50200" T="0"></M><E CS="1" FN="3000746583" N="12" NO="211" SE="15241" SM="19190" TS="20191122113038"><TX DTPR="5.00" DTSM="900" TX="1" TXAL="2" TXPR="20.00" TXSM="3049" TXTY="0"></TX></E></C><TS>20191122113038</TS></DAT>
<DAT DI="218" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000032" N="2" NM="Торт Пінчер 150г"1"></P><L N="3">Полная стоимость 60.00 грн.</L><P C="00000000000033" N="4" NM="Салат Оселедець під шуб ою="6">ЧЕК:100165468 501-Каса 2 маг. &quot;Він</L><L N="7">таж&quot; DP</L><M N="8" NM="ГОТIВКА" RM="4000" SM="20140" T="0"></M><E CS="1" FN="3000746583" N="9" NO="213" SE="13450" SM="16140" TS="20191122113816"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="2690" TXTY="0"></TX></E></C><TS>20191122113816</TS></DAT>
<DAT DI="219" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="Пакет 39х49 з малюнком" SM="300" TX="1"></P><P C="00000000000034" N="3" NM="Ле Ванс Ожу Вино Божоле Віляж Нуво " SM="19900" TX="1"></P><L N="4">Полная стоимость 265.00 грн.</L><L N="5">&quot;Простая акция&quot; 24%</L><L N="6">ЧЕК:100165469 501-Каса 2 маг. &quot;Він</L><L N="7">таж&quot; DP</L><M N="8" NM="ГОТIВКА" SM="20200" T="0"></M><E CS="1" FN="3000746583" N="9" NO="214" SE="16043" SM="20200" TS="20191122114230"><TX DTPR="5.00" DTSM="948" TX="1" TXAL="2" TXPR="20.00" TXSM="3209" TXTY="0"></TX></E></C><TS>20191122114230</TS></DAT>
<DAT DI="220" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000035" N="2" NM="Моршинська Вода негазов ана мінераль" SM="1140" TX="1"></P><L N="3">ЧЕК:100165470 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" RM="860" SM="2000" T="0"></M><E CS="1" FN="3000746583" N="6" NO="215" SE="950" SM="1140" TS="20191122114452"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="190" TXTY="0"></TX></E></C><TS>20191122114452</TS></DAT>
<DAT DI="221" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000036" N="2" NM="Ферреро Драже Тік Так М інт 16г" SM="1710" TX="1"></P><L N="3">ЧЕК:100165471 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" RM="300" SM="2010" T="0"></M><E CS="1" FN="3000746583" N="6" NO="216" SE="1425" SM="1710" TS="20191122114710"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="285" TXTY="0"></TX></E></C><TS>20191122114710</TS></DAT>
<DAT DI="222" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="Пакет 39х49 з малюнком" SM="300" TX="1"></P><P C="00000000000037" N="3" NM="Тагаро Вино Пассо дель Суд Едіціоне" PRC="30000" Q="2000" SM="60000" TX="1"></P><L N="4">Полная стоимость 753.80 грн.</L><L N="5">&quot;Простая акция&quot; 20%</L><P C="00000000000038" N="6" NM="Томмаси Вино Лугана Лі Форнасі 2017" PRC="31000" Q="2000" SM="62000" TX="1"></P><L N="7">Полная стоимость 732.00 грн.</L><L N="8">&quot;Простая акция&quot; 15%</L><L N="9">ЧЕК:100165472 501-Каса 2 маг. &quot;Він</L><L N="10">таж&quot; DP</L><M N="11" NM="КАРТКА" SM="122300" T="2"></M><E CS="1" FN="3000746583" N="12" NO="217" SE="97075" SM="122300" TS="20191122114846"><TX DTPR="5.00" DTSM="5810" TX="1" TXAL="2" TXPR="20.00" TXSM="19415" TXTY="0"></TX></E></C><TS>20191122114846</TS></DAT>
<DAT DI="223" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000039" N="2" NM="Ф`южн Вайнс Вино Ф`южн Альта Каберн" SM="18000" TX="1"></P><L N="3">Полная стоимость 280.00 грн.</L><L N="4">&quot;Простая акция&quot; 35%</L><P C="00000000000040" N="5" NM="Маркес де Толедо Вино К ріанца черво" SM="15000" TX="1"></P><L N="6">Полная стоимость 191.00 грн.</L><L N="7">&quot;Простая акция&quot; 21%</L><L N="8">ЧЕК:100165474 501-Каса 2 маг. &quot;Він</L><L N="9">таж&quot; DP</L><M N="10" NM="КАРТКА" SM="33000" T="2"></M><E CS="1" FN="3000746583" N="11" NO="218" SE="26191" SM="33000" TS="20191122115320"><TX DTPR="5.00" DTSM="1571" TX="1" TXAL="2" TXPR="20.00" TXSM="5238" TXTY="0"></TX></E></C><TS>20191122115320</TS></DAT>
<DAT DI="224" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000041" N="2" NM="МакАртурс Віскі шотл 0>Полная стоимость 278.40 грн.</L><L N="4">&quot;Простая акция&quot; 35%</L><P C="00000000000042" N="5" NM="Маркес де Толедо Вино В ердехо біле " SM="14000" TX="1"></P><L N="6">Полная стоимость 191.50 грн.</L><L N="7">&quot;Простая акция&quot; 26%</L><L N="8">ЧЕК:100165476 501-Каса 2 маг. &quot;Він</L><L N="9">таж&quot; DP</L><M N="10" NM="КАРТКА" SM="31900" T="2"></M><E CS="1" FN="3000746583" N="11" NO="219" SE="25317" SM="31900" TS="20191122115656"><TX DTPR="5.00" DTSM="1519" TX="1" TXAL="2" TXPR="20.00" TXSM="5064" TXTY="0"></TX></E></C><TS>20191122115656</TS></DAT>
<DAT DI="225" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="Пакет 39х49 з малюнком" SM="300" TX="1"></P><L N="3">ЧЕК:100165477 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" SM="300" T="0"></M><E CS="1" FN="3000746583" N="6" NO="220" SE="250" SM="300" TS="20191122115730"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="50" TXTY="0"></TX></E></C><TS>20191122115730</TS></DAT>
<DAT DI="226" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000043" N="2" NM="Плюшка з цукром 100г (с упермаркет)" SM="650" TX="1"></P><L N="3">ЧЕК:100165478 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" SM="650" T="0"></M><E CS="1" FN="3000746583" N="6" NO="221" SE="542" SM="650" TS="20191122115752"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="108" TXTY="0"></TX></E></C><TS>20191122115752</TS></DAT>
<DAT DI="227" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000044" N="2" NM="Річ Комбіфіт Сік Яблуко 1л" SM="3130" TX="1"></P><L N="3">ЧЕК:100165479 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" RM="6870" SM="10000" T="0"></M><E CS="1" FN="3000746583" N="6" NO="222" SE="2608" SM="3130" TS="20191122115808"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="522" TXTY="0"></TX></E></C><TS>20191122115808</TS></DAT>
<DAT DI="228" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000045" N="2" NM="Булочка з вишнею 100г" SM="950" TX="1"></P><L N="3">ЧЕК:100165480 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" SM="950" T="0"></M><E CS="1" FN="3000746583" N="6" NO="223" SE="792" SM="950" TS="20191122115840"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="158" TXTY="0"></TX></E></C><TS>20191122115840</TS></DAT>
<DAT DI="229" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000046" N="2" NM="Курвуазьє Коньяк VS 000000000047" N="3" NM="Вісенте Гандіа Вино Плу віум Тінто П" PRC="6560" Q="3000" SM="19680" TX="1"></P><P C="00000000000048" N="4" NM="Вісенте Гандіа Вино Плу віум Росадо " PRC="6560" Q="12000" SM="78720" TX="1"></P><L N="5">ЧЕК:100165481 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="ГОТIВКА" SM="203300" T="0"></M><E CS="1" FN="3000746583" N="8" NO="224" SE="161349" SM="203300" TS="20191122120310"><TX DTPR="5.00" DTSM="9681" TX="1" TXAL="2" TXPR="20.00" TXSM="32270" TXTY="0"></TX></E></C><TS>20191122120310</TS></DAT>
<DAT DI="230" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000049" N="2" NM="Хліб Литовський чорний бездріжджови" SM="1265" TX="1"></P><P C="00000000000045" N="3" NM="Булочка з вишнею 100г" SM="950" TX="1"></P><L N="4">ЧЕК:100165482 501-Каса 2 маг. &quot;Він</L><L N="5">таж&quot; DP</L><M N="6" NM="КАРТКА" SM="2215" T="2"></M><E CS="1" FN="3000746583" N="7" NO="225" SE="1846" SM="2215" TS="20191122120628"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="369" TXTY="0"></TX></E></C><TS>20191122120628</TS></DAT>
<DAT DI="231" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000050" N="2" NM="Він Букет Відкривачка F ID 017" SM="17950" TX="1"></P><L N="3">ЧЕК:100165483 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="КАРТКА" SM="17950" T="2"></M><E CS="1" FN="3000746583" N="6" NO="226" SE="14958" SM="17950" TS="20191122121350"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="2992" TXTY="0"></TX></E></C><TS>20191122121350</TS></DAT>
<DAT DI="232" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000043" N="2" NM="Плюшка з цукром 100г (с упермаркет)" PRC="650" Q="4000" SM="2600" TX="1"></P><L N="3">ЧЕК:100165484 501-Каса 2 маг. &quot;Він</L><L N="4">таж&quot; DP</L><M N="5" NM="ГОТIВКА" SM="2600" T="0"></M><E CS="1" FN="3000746583" N="6" NO="227" SE="2167" SM="2600" TS="20191122121556"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="433" TXTY="0"></TX></E></C><TS>20191122121556</TS></DAT>
<DAT DI="233" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000051" N="2" NM="Моршинська Вода слабога зована мінер" SM="1230" TX="1"></P><L N="3">Полная стоимость 15.40 грн.</L><L N="4">&quot;Простая акция&quot; 20%</L><L N="5">ЧЕК:100165485 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="КАРТКА" SM="1230" T="2"></M><E CS="1" FN="3000746583" N="8" NO="228" SE="1025" SM="1230" TS="20191122122956"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="205" TXTY="0"></TX></E></C><TS>20191122122956</TS></DAT>
<DAT DI="234" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000052" N="2" NM="Тютюнові стіки Хітс Емб ер" PRC="5000" Q="2000" SM="10000" TX="1"></P><P C="00000000000053" N="3" NM="Булочка Баварська 30г " PRC="250" Q="2000" SM="500" TX="1"></P><P C="00000000000054" N="4" NM="Салат Вінегрет<L N="5">Полная стоимость 31.03 грн.</L><L N="6">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="7">ая 10%</L><P C="00000000000055" N="8" NM="Котлети курячі="1"></P><L N="9">Полная стоимость 23.40 грн.</L><L N="10">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="11">ая 10%</L><L N="12">ЧЕК:100165486 501-Каса 2 маг. &quot;Він</L><L N="13">таж&quot; DP</L><M N="14" NM="ГОТIВКА" RM="4601" SM="20000" T="0"></M><E CS="1" FN="3000746583" N="15" NO="229" SE="12436" SM="15399" TS="20191122123256"><TX DTPR="5.00" DTSM="476" TX="1" TXAL="2" TXPR="20.00" TXSM="2487" TXTY="0"></TX></E></C><TS>20191122123256</TS></DAT>
<DAT DI="235" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000056" N="2" NM="Торт Пінчер 150гная стоимость 30.00 грн.</L><P C="00000000000043" N="4" NM="Плюшка з цукром 100г (с упермаркет)" SM="650" TX="1"></P><L N="5">Полная стоимость 6.50 грн.</L><P C="00000000000057" N="6" NM="Відбивна курячаЕК:100165487 501-Каса 2 маг. &quot;Він</L><L N="9">таж&quot; DP</L><M N="10" NM="ГОТIВКА" RM="4100" SM="11000" T="0"></M><E CS="1" FN="3000746583" N="11" NO="230" SE="5750" SM="6900" TS="20191122123718"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="1150" TXTY="0"></TX></E></C><TS>20191122123718</TS></DAT>
<DAT DI="236" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000058" N="2" NM="Торт Пінчер 150гная стоимость 30.00 грн.</L><L N="4">Супермаркет &quot;ДК Фиксированная&quot; 10%</L><P C="00000000000059" N="5" NM="Булочка Тріо 100г" SM="1250" TX="1"></P><L N="6">ЧЕК:100165488 501-Каса 2 маг. &quot;Він</L><L N="7">таж&quot; DP</L><M N="8" NM="КАРТКА" SM="3950" T="2"></M><E CS="1" FN="3000746583" N="9" NO="231" SE="3292" SM="3950" TS="20191122123842"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="658" TXTY="0"></TX></E></C><TS>20191122123842</TS></DAT>
<DAT DI="237" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000060" N="2" NM="Парламент Сигарети Аква" SM="5300" TX="1"></P><P C="00000000000061" N="3" NM="Парламент Сигарети Сіль вер" SM="5300" TX="1"></P><P C="00000000000053" N="4" NM="Булочка Баварська 30г " PRC="250" Q="2000" SM="500" TX="1"></P><P C="00000000000062" N="5" NM="Салат Вінегрет N="7">Супермаркет &quot;ДК Накопительная&quot; нов</L><L N="8">ая 10%</L><L N="9">ЧЕК:100165489 501-Каса 2 маг. &quot;Він</L><L N="10">таж&quot; DP</L><M N="11" NM="КАРТКА" SM="13710" T="2"></M><E CS="1" FN="3000746583" N="12" NO="232" SE="11004" SM="13710" TS="20191122123956"><TX DTPR="5.00" DTSM="505" TX="1" TXAL="2" TXPR="20.00" TXSM="2201" TXTY="0"></TX></E></C><TS>20191122123956</TS></DAT>
<DAT DI="238" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000063" N="2" NM="Терра Вега Вино Мерло ч ервоне 0 SM="39970" TX="1"></P><L N="3">Полная стоимость 453.20 грн.</L><L N="4">Полная стоимость 453.20 грн.</L><L N="5">Супермаркет &quot;ДК Фиксированная&quot; 10%</L><L N="6">Супермаркет &quot;Скидка при покупке 2х</L><L N="7"> и более бутылок&quot; (количественная)</L><L N="8"> 2%</L><L N="9">ЧЕК:100165490 501-Каса 2 маг. &quot;Він</L><L N="10">таж&quot; DP</L><M N="11" NM="ГОТIВКА" RM="30" SM="40000" T="0"></M><E CS="1" FN="3000746583" N="12" NO="233" SE="31722" SM="39970" TS="20191122124032"><TX DTPR="5.00" DTSM="1903" TX="1" TXAL="2" TXPR="20.00" TXSM="6345" TXTY="0"></TX></E></C><TS>20191122124032</TS></DAT>
<DAT DI="239" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000064" N="2" NM="Вісенте Гандіа Вино Плу віум Тінто П" PRC="6900" Q="3000" SM="20700" TX="1"></P><L N="3">Полная стоимость 281.70 грн.</L><L N="4">&quot;Простая акция&quot; 26%</L><L N="5">ЧЕК:100165491 501-Каса 2 маг. &quot;Він</L><L N="6">таж&quot; DP</L><M N="7" NM="ГОТIВКА" SM="20700" T="0"></M><E CS="1" FN="3000746583" N="8" NO="234" SE="16428" SM="20700" TS="20191122124830"><TX DTPR="5.00" DTSM="986" TX="1" TXAL="2" TXPR="20.00" TXSM="3286" TXTY="0"></TX></E></C><TS>20191122124830</TS></DAT>
<DAT DI="241" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="236" VD="1" TS="20191122161712"></E></C><TS>20191122161712</TS></DAT>
<DAT DI="242" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="237" VD="1" TS="20191122161828"></E></C><TS>20191122161828</TS></DAT>
<DAT DI="243" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="238" VD="1" TS="20191122170144"></E></C><TS>20191122170144</TS></DAT>
<DAT DI="244" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="239" VD="1" TS="20191122171146"></E></C><TS>20191122171146</TS></DAT>
<DAT DI="245" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><C T="2"><O N="1" SM="669139" T="0"></O><E N="2"></E></C><TS>20191122172242</TS></DAT>
<DAT DI="246" DT="0" FN="3000746583" TN="ПН 410869004616" V="1" ZN="КЛ00002112"><Z NO="2"><TXS DTI="69943" DTPR="5.00" SMI="1564075" TS="20191121" TX="1" TXAL="2" TXI="249022" TXO="0" TXPR="20.00" TXTY="0"></TXS><M NM="ГОТIВКА" SMI="649139" SMO="0" T="0"></M><M NM="ЧЕК" SMI="40000" T="1"></M><M NM="КАРТКА" SMI="874936" T="2"></M><IO SMI="20000" SMO="669139" T="0"></IO><NC NI="46" NO="0"></NC></Z><TS>20191122172334</TS></DAT>
</RQ>'

IF OBJECT_ID (N'tempdb..#temp_table_name',N'U') IS NOT NULL DROP TABLE #temp_table_name
CREATE TABLE #temp_table_name
(row1 VARCHAR(MAX)
 ,row2 VARCHAR(MAX)
 ,row3 VARCHAR(MAX)
)

WHILE (@f = 1)
BEGIN

	SELECT @ekka = SUBSTRING(@ekka, CHARINDEX('DI="',@ekka) + LEN('DI="'),LEN(@ekka) )
	SELECT @one = SUBSTRING(@ekka,1,CHARINDEX('"',@ekka)-1)
	SELECT @ekka = SUBSTRING(@ekka, CHARINDEX('<M',@ekka) + LEN('<M'),LEN(@ekka) )
	SELECT @ekka = SUBSTRING(@ekka, CHARINDEX('NM="',@ekka) + LEN('NM="'),LEN(@ekka) )
	SELECT @two = SUBSTRING(@ekka,1,CHARINDEX('"',@ekka)-1)
	SELECT @ekka = SUBSTRING(@ekka, CHARINDEX('SM="',@ekka) + LEN('SM="'),LEN(@ekka) )
	SELECT @three = SUBSTRING(@ekka,1,CHARINDEX('"',@ekka)-1)

	INSERT INTO #temp_table_name
	SELECT @one,@two,@three

	IF (SELECT CHARINDEX('DI="',@ekka)) = 0
	BEGIN
		SELECT @f = 0
	END;
END;

SELECT * FROM #temp_table_name




/*
IF OBJECT_ID (N'tempdb..#temp_table_name',N'U') IS NOT NULL DROP TABLE #temp_table_name
CREATE TABLE #temp_table_name
(row1 INT
 ,row2 int
 ,row3 NUMERIC(21,9))

INSERT INTO #temp_table_name
SELECT q.kek
      ,CASE WHEN q.lol = 'КАРТКА'
	  THEN 27 ELSE 0 END
	  ,q.tet/100
FROM (
SELECT 199 AS kek, 'КАРТКА' AS lol, 31000 AS tet UNION ALL
SELECT 200 AS kek, 'ЧЕК' AS lol, 40000 AS tet UNION ALL
SELECT 201 AS kek, 'ГОТIВКА' AS lol, 28000 AS tet UNION ALL
SELECT 202 AS kek, 'КАРТКА' AS lol, 44850 AS tet UNION ALL
SELECT 203 AS kek, 'КАРТКА' AS lol, 64360 AS tet UNION ALL
SELECT 204 AS kek, 'КАРТКА' AS lol, 22150 AS tet UNION ALL
SELECT 205 AS kek, 'КАРТКА' AS lol, 35295 AS tet UNION ALL
SELECT 206 AS kek, 'КАРТКА' AS lol, 19000 AS tet UNION ALL
SELECT 207 AS kek, 'КАРТКА' AS lol, 6070 AS tet UNION ALL
SELECT 208 AS kek, 'КАРТКА' AS lol, 41585 AS tet UNION ALL
SELECT 209 AS kek, 'КАРТКА' AS lol, 2880 AS tet UNION ALL
SELECT 210 AS kek, 'ГОТIВКА' AS lol, 22010 AS tet UNION ALL
SELECT 211 AS kek, 'КАРТКА' AS lol, 268800 AS tet UNION ALL
SELECT 212 AS kek, 'ГОТIВКА' AS lol, 50000 AS tet UNION ALL
SELECT 213 AS kek, 'ГОТIВКА' AS lol, 125000 AS tet UNION ALL
SELECT 214 AS kek, 'ГОТIВКА' AS lol, 60000 AS tet UNION ALL
SELECT 215 AS kek, 'КАРТКА' AS lol, 3000 AS tet UNION ALL
SELECT 216 AS kek, 'ГОТIВКА' AS lol, 50200 AS tet UNION ALL
SELECT 218 AS kek, 'ГОТIВКА' AS lol, 20140 AS tet UNION ALL
SELECT 219 AS kek, 'ГОТIВКА' AS lol, 20200 AS tet UNION ALL
SELECT 220 AS kek, 'ГОТIВКА' AS lol, 2000 AS tet UNION ALL
SELECT 221 AS kek, 'ГОТIВКА' AS lol, 2010 AS tet UNION ALL
SELECT 222 AS kek, 'КАРТКА' AS lol, 122300 AS tet UNION ALL
SELECT 223 AS kek, 'КАРТКА' AS lol, 33000 AS tet UNION ALL
SELECT 224 AS kek, 'КАРТКА' AS lol, 31900 AS tet UNION ALL
SELECT 225 AS kek, 'ГОТIВКА' AS lol, 300 AS tet UNION ALL
SELECT 226 AS kek, 'ГОТIВКА' AS lol, 650 AS tet UNION ALL
SELECT 227 AS kek, 'ГОТIВКА' AS lol, 10000 AS tet UNION ALL
SELECT 228 AS kek, 'ГОТIВКА' AS lol, 950 AS tet UNION ALL
SELECT 229 AS kek, 'ГОТIВКА' AS lol, 203300 AS tet UNION ALL
SELECT 230 AS kek, 'КАРТКА' AS lol, 2215 AS tet UNION ALL
SELECT 231 AS kek, 'КАРТКА' AS lol, 17950 AS tet UNION ALL
SELECT 232 AS kek, 'ГОТIВКА' AS lol, 2600 AS tet UNION ALL
SELECT 233 AS kek, 'КАРТКА' AS lol, 1230 AS tet UNION ALL
SELECT 234 AS kek, 'ГОТIВКА' AS lol, 20000 AS tet UNION ALL
SELECT 235 AS kek, 'ГОТIВКА' AS lol, 11000 AS tet UNION ALL
SELECT 236 AS kek, 'КАРТКА' AS lol, 3950 AS tet UNION ALL
SELECT 237 AS kek, 'КАРТКА' AS lol, 13710 AS tet UNION ALL
SELECT 238 AS kek, 'ГОТIВКА' AS lol, 40000 AS tet UNION ALL
SELECT 239 AS kek, 'ГОТIВКА' AS lol, 20700 AS tet
) q
*/


SELECT * FROM #temp_table_name
--WHERE row2 = 27

SELECT m.ChID, m.TRealSum,*--, d.SumCC_wt, lv.LevySum--sp.*
FROM t_Sale m
--left JOIN t_SaleD d on d.ChID = m.ChID
--left JOIN t_SalePays sp on sp.ChID = m.ChID
--left JOIN r_Prods p on p.ProdID = d.ProdID
--LEFT JOIN t_SaleDLV lv on lv.ChID = m.ChID and d.SrcPosID = lv.SrcPosID
--LEFT JOIN t_MonRec mr on mr.DocID = m.DocID and mr.OurID = m.OurID
WHERE m.DocDate = '20191120' --AND (m.ChID BETWEEN 100051476 AND 100750999 OR m.ChID IN (100751546,100751547,100751595) )--190751476
	 AND m.CRID = 501
	 --AND (m.ChID > 100750999 OR m.ChID IN (100750982))
	 --AND m.CodeID3 != 27
	 --AND sp.SrcPosID = 1
	 --AND m.ChID NOT IN (100750983, 100750982,    100750984)
	 --AND m.ChID NOT IN (100750983)
ORDER BY 1
--27 no cash
--other cash
SELECT * FROM t_Sale
WHERE ChID BETWEEN 100000000 AND 100750999
--WHERE DocID <0
ORDER BY 1

SELECT * FROM t_SaleDLV
WHERE ChID = 100751546

SELECT * FROM t_MonRec
WHERE DocID = 100165172  AND OurID = 6

SELECT * FROM t_MonRec WHERE ChID = 100540787
SELECT * FROM t_MonRec
WHERE ChID BETWEEN 100000000 AND 190540787
ORDER BY 1 DESC

SELECT * FROM r_Prods
WHERE UAProdName LIKE 'Шато де Монтіфо Коньяк Кеопс VSOP 4%'
--WHERE UAProdName LIKE 'Вісенте Гандіа Вино Плувіум Тінто%'

SELECT TRealSum,*--m.DocDate, m.DocTime, m.DocCreateTime
FROM t_Sale m
WHERE m.ChID = 100750525--BETWEEN 100750999 AND 190750999
ORDER BY ChID
/*
BEGIN TRAN;
	UPDATE t_Sale
	SET CRID = 777
	   ,WPID = 777
	WHERE ChID = 100750983
ROLLBACK TRAN;

	--UPDATE t_Sale
	--SET DocDate = '2019-11-22 00:00:00'
	--   ,DocTime = '2019-11-22 12:48:30.228'
	--   ,DocCreateTime = '2019-11-22 12:47:29.310'
	--   ,CRID = 501
	--     ,WPID = 501
	--WHERE ChID = 100751546

	--UPDATE t_Sale
	--SET DocDate = '2019-11-22 00:00:00'
	--   ,DocTime = '2019-11-22 11:53:20.113'
	--   ,DocCreateTime = '2019-11-22 11:52:20.712'
	--   ,CRID = 501
	--   ,WPID = 501
	--WHERE ChID = 100751547

	UPDATE t_Sale
	SET DocDate = '2019-11-22 00:00:00'
	   ,DocTime = '2019-11-22 12:51:28.378'
	   ,DocCreateTime = '2019-11-22 12:50:09.568'
	   ,CRID = 501
	   ,WPID = 501
	WHERE ChID = 100751595




SELECT * FROM t_Sale m
left JOIN t_SaleD d on d.ChID = m.ChID
left JOIN t_SalePays sp on sp.ChID = m.ChID
left JOIN r_Prods p on p.ProdID = d.ProdID
LEFT JOIN t_SaleDLV lv on lv.ChID = m.ChID and d.SrcPosID = lv.SrcPosID
LEFT JOIN t_MonRec mr on mr.DocID = m.DocID and mr.OurID = m.OurID
WHERE m.DocID = 100165481-- 100750983

SELECT * FROM t_Sale WHERE CRID = 777
ORDER BY 1 DESC
*/
/*
BEGIN TRAN;
INSERT INTO [S-SQL-D4].ElitR.dbo.t_Sale
SELECT 100000004, 100000004, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, Notes, CRID, OperID, CreditID, DocTime, TaxDocID, TaxDocDate, DCardID, EmpID, IntDocID, CashSumCC, ChangeSumCC, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DeskCode, Visitors, TPurSumCC_nt, TPurTaxSum, TPurSumCC_wt, DocCreateTime, DepID, ClientID, InDocID, ExpTime, DeclNum, DeclDate, BLineID, TRealSum, TLevySum, RemSChId, WPID, DCardChID
FROM t_Sale
WHERE ChID = 100750983
ROLLBACK TRAN;


INSERT INTO [S-SQL-D4].ElitR.dbo.t_SaleD
SELECT 100000004, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount, DepID, IsFiscal, SubStockID, OutQty, EmpID, '2019-11-22 17:39:43.432', '2019-11-22 17:39:43.432', TaxTypeID, RealPrice, RealSum
FROM t_SaleD
WHERE ChID = 100750983

INSERT INTO [S-SQL-D4].ElitR.dbo.t_SalePays
SELECT 100000004, SrcPosID, PayFormCode, SumCC_wt, Notes, POSPayID, POSPayDocID, POSPayRRN, IsFiscal, ChequeText, BServID, PayPartsQty, ContractNo, POSPayText
FROM t_SalePays
WHERE ChID = 100750983

INSERT INTO [S-SQL-D4].ElitR.dbo.t_SaleDLV
SELECT 100000004, SrcPosID, LevyID, LevySum
FROM t_SaleDLV
WHERE ChID = 100750983 AND SrcPosID = 1

INSERT INTO [S-SQL-D4].ElitR.dbo.t_MonRec
SELECT 100000677, OurID, AccountAC, DocDate, 100000004, StockID, CompID, CompAccountAC, CurrID, KursMC, KursCC, SumAC, Subject, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, StateCode, DepID
FROM t_MonRec
WHERE ChID = 100540787
*/
