DECLARE @f BIT = 1
DECLARE @one VARCHAR(256), @two VARCHAR(256), @three VARCHAR(256)
DECLARE @ekka VARCHAR(MAX) = 
'<RQ V="1">
<DAT DI="198" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="2"><I N="1" SM="20000" T="0"></I><E N="2"></E></C><TS>20191122100040</TS></DAT>
<DAT DI="199" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000001" N="2" NM="�������� ���� ³�`� ��� �� ������ �" PRC="15500" Q="2000" SM="31000" TX="1"></P><L N="3">������ ��������� 440.00 ���.</L><L N="4">&quot;������� �����&quot; 29%</L><L N="5">���:100165449 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="������" SM="31000" T="2"></M><E CS="1" FN="3000746583" N="8" NO="194" SE="24603" SM="31000" TS="20191122100254"><TX DTPR="5.00" DTSM="1476" TX="1" TXAL="2" TXPR="20.00" TXSM="4921" TXTY="0"></TX></E></C><TS>20191122100254</TS></DAT>
<DAT DI="200" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="����� 39�49 � ��������" SM="300" TX="1"></P><P C="00000000000003" N="3" NM="����� г����� ���� ��� �� ������ " SM="53500" TX="1"></P><L N="4">������ ��������� 628.10 ���.</L><L N="5">&quot;������� �����&quot; 14%</L><L N="6">���:100165450 501-���� 2 ���. &quot;³�</L><L N="7">���&quot; DP</L><M N="8" NM="���" SM="40000" T="1"></M><M N="9" NM="���I���" RM="1200" SM="15000" T="0"></M><E CS="1" FN="3000746583" N="10" NO="195" SE="42710" SM="53800" TS="20191122101344"><TX DTPR="5.00" DTSM="2548" TX="1" TXAL="2" TXPR="20.00" TXSM="8542" TXTY="0"></TX></E></C><TS>20191122101344</TS></DAT>
<DAT DI="201" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000004" N="2" NM="����� ��� ������� �� �� DOCG 0P><L N="3">������ ��������� 424.50 ���.</L><L N="4">&quot;������� �����&quot; 34%</L><L N="5">���:100165451 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="���I���" RM="100" SM="28000" T="0"></M><E CS="1" FN="3000746583" N="8" NO="196" SE="22142" SM="27900" TS="20191122101540"><TX DTPR="5.00" DTSM="1329" TX="1" TXAL="2" TXPR="20.00" TXSM="4429" TXTY="0"></TX></E></C><TS>20191122101540</TS></DAT>
<DAT DI="202" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000005" N="2" NM="���� ³�� ������� 0>������ ��������� 703.20 ���.</L><L N="4">&quot;������� �����&quot; 36%</L><L N="5">���:100165452 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="������" SM="44850" T="2"></M><E CS="1" FN="3000746583" N="8" NO="197" SE="35595" SM="44850" TS="20191122102658"><TX DTPR="5.00" DTSM="2136" TX="1" TXAL="2" TXPR="20.00" TXSM="7119" TXTY="0"></TX></E></C><TS>20191122102658</TS></DAT>
<DAT DI="203" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000006" N="2" NM="����� ����� ���� ����� �� ������� " SM="24000" TX="1"></P><L N="3">������ ��������� 364.10 ���.</L><L N="4">&quot;������� �����&quot; 34%</L><P C="00000000000007" N="5" NM="��� ���� ������� ���� ������� ���" SM="40060" TX="1"></P><P C="00000000000002" N="6" NM="����� 39�49 � ��������" SM="300" TX="1"></P><L N="7">���:100165453 501-���� 2 ���. &quot;³�</L><L N="8">���&quot; DP</L><M N="9" NM="������" SM="64360" T="2"></M><E CS="1" FN="3000746583" N="10" NO="198" SE="51092" SM="64360" TS="20191122102802"><TX DTPR="5.00" DTSM="3050" TX="1" TXAL="2" TXPR="20.00" TXSM="10218" TXTY="0"></TX></E></C><TS>20191122102802</TS></DAT>
<DAT DI="204" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="����� 39�49 � ��������" SM="300" TX="1"></P><P C="00000000000008" N="3" NM="��������� ������ 40% 1�" SM="21850" TX="1"></P><L N="4">������ ��������� 437.00 ���.</L><L N="5">&quot;������� �����&quot; 50%</L><L N="6">���:100165454 501-���� 2 ���. &quot;³�</L><L N="7">���&quot; DP</L><M N="8" NM="������" SM="22150" T="2"></M><E CS="1" FN="3000746583" N="9" NO="199" SE="17592" SM="22150" TS="20191122103322"><TX DTPR="5.00" DTSM="1040" TX="1" TXAL="2" TXPR="20.00" TXSM="3518" TXTY="0"></TX></E></C><TS>20191122103322</TS></DAT>
<DAT DI="205" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000009" N="2" NM="����� 39�49 � ��������" SM="279" TX="1"></P><L N="3">������ ��������� 3.00 ���.</L><L N="4">����������� &quot;�� �������������&quot; ���</L><L N="5">�� 7%</L><P C="00000000000010" N="6" NM="������ ��� ������� 1�" SM="31900" TX="1"></P><L N="7">������ ��������� 531.50 ���.</L><L N="8">&quot;������� �����&quot; 39%</L><P C="00000000000011" N="9" NM="����-���� ���� ������� ������� 2�" SM="3116" TX="1"></P><L N="10">������ ��������� 33.50 ���.</L><L N="11">����������� &quot;�� �������������&quot; ���</L><L N="12">�� 7%</L><L N="13">���:100165455 501-���� 2 ���. &quot;³�</L><L N="14">���&quot; DP</L><M N="15" NM="������" SM="35295" T="2"></M><E CS="1" FN="3000746583" N="16" NO="200" SE="28146" SM="35295" TS="20191122104032"><TX DTPR="5.00" DTSM="1519" TX="1" TXAL="2" TXPR="20.00" TXSM="5630" TXTY="0"></TX></E></C><TS>20191122104032</TS></DAT>
<DAT DI="206" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000012" N="2" NM="������������ ³���� �� 6 ������" SM="1000" TX="1"></P><P C="00000000000013" N="3" NM="���� 3+3 ������ ���� ������� ����" SM="18000" TX="1"></P><L N="4">���:100165456 501-���� 2 ���. &quot;³�</L><L N="5">���&quot; DP</L><M N="6" NM="������" SM="19000" T="2"></M><E CS="1" FN="3000746583" N="7" NO="201" SE="15119" SM="19000" TS="20191122105156"><TX DTPR="5.00" DTSM="857" TX="1" TXAL="2" TXPR="20.00" TXSM="3024" TXTY="0"></TX></E></C><TS>20191122105156</TS></DAT>
<DAT DI="207" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000014" N="2" NM="����� ���� ����������� ��� 0N="3">������ ��������� 13.00 ���.</L><L N="4">����������� &quot;�� �������������&quot; 10%</L><P C="00000000000015" N="5" NM="���� �������� ����" SM="4900" TX="1"></P><L N="6">���:100165457 501-���� 2 ���. &quot;³�</L><L N="7">���&quot; DP</L><M N="8" NM="������" SM="6070" T="2"></M><E CS="1" FN="3000746583" N="9" NO="202" SE="4864" SM="6070" TS="20191122105244"><TX DTPR="5.00" DTSM="233" TX="1" TXAL="2" TXPR="20.00" TXSM="973" TXTY="0"></TX></E></C><TS>20191122105244</TS></DAT>
<DAT DI="208" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000009" N="2" NM="����� 39�49 � ��������" SM="279" TX="1"></P><L N="3">������ ��������� 3.00 ���.</L><L N="4">����������� &quot;�� �������������&quot; ���</L><L N="5">�� 7%</L><P C="00000000000016" N="6" NM="����� ���� ���� ������� ��� 0TX="1"></P><L N="7">������ ��������� 453.20 ���.</L><L N="8">����������� &quot;�� �������������&quot; ���</L><L N="9">�� 7%</L><L N="10">����������� &quot;������ ��� ������� 2�</L><L N="11"> � ����� �������&quot; (��������������)</L><L N="12"> 2%</L><L N="13">���:100165458 501-���� 2 ���. &quot;³�</L><L N="14">���&quot; DP</L><M N="15" NM="������" SM="41585" T="2"></M><E CS="1" FN="3000746583" N="16" NO="203" SE="33014" SM="41585" TS="20191122110610"><TX DTPR="5.00" DTSM="1967" TX="1" TXAL="2" TXPR="20.00" TXSM="6604" TXTY="0"></TX></E></C><TS>20191122110610</TS></DAT>
<DAT DI="209" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000017" N="2" NM="���� �������� 120������� ��������� 32.00 ���.</L><L N="4">����������� &quot;�� �������������&quot; 10%</L><L N="5">���:100165459 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="������" SM="2880" T="2"></M><E CS="1" FN="3000746583" N="8" NO="204" SE="2400" SM="2880" TS="20191122111022"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="480" TXTY="0"></TX></E></C><TS>20191122111022</TS></DAT>
<DAT DI="210" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="����� 39�49 � ��������" SM="300" TX="1"></P><P C="00000000000018" N="3" NM="����� ���� ��⳺�� ���� ��� ������" SM="18000" TX="1"></P><L N="4">������ ��������� 225.00 ���.</L><L N="5">&quot;������� �����&quot; 20%</L><P C="00000000000019" N="6" NM="������� ������ ����� 1�" SM="3710" TX="1"></P><L N="7">���:100165460 501-���� 2 ���. &quot;³�</L><L N="8">���&quot; DP</L><M N="9" NM="���I���" SM="22010" T="0"></M><E CS="1" FN="3000746583" N="10" NO="205" SE="17628" SM="22010" TS="20191122111208"><TX DTPR="5.00" DTSM="857" TX="1" TXAL="2" TXPR="20.00" TXSM="3525" TXTY="0"></TX></E></C><TS>20191122111208</TS></DAT>
<DAT DI="211" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000020" N="2" NM="���� ������� ���� ���� ���� ���� 18" PRC="33000" Q="4000" SM="132000" TX="1"></P><P C="00000000000021" N="3" NM="���� ���� ������� ���� ���� �������" PRC="34200" Q="4000" SM="136800" TX="1"></P><L N="4">���:100165461 501-���� 2 ���. &quot;³�</L><L N="5">���&quot; DP</L><M N="6" NM="������" SM="268800" T="2"></M><E CS="1" FN="3000746583" N="7" NO="206" SE="213333" SM="268800" TS="20191122111504"><TX DTPR="5.00" DTSM="12800" TX="1" TXAL="2" TXPR="20.00" TXSM="42667" TXTY="0"></TX></E></C><TS>20191122111504</TS></DAT>
<DAT DI="212" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000022" N="2" NM="����� ����� ���� ����� ��� ��� 0P><P C="00000000000023" N="3" NM="������ ��� ���� ʳ��� ������ ����" SM="18050" TX="1"></P><L N="4">���:100165462 501-���� 2 ���. &quot;³�</L><L N="5">���&quot; DP</L><M N="6" NM="���I���" RM="9150" SM="50000" T="0"></M><E CS="1" FN="3000746583" N="7" NO="207" SE="32421" SM="40850" TS="20191122111602"><TX DTPR="5.00" DTSM="1945" TX="1" TXAL="2" TXPR="20.00" TXSM="6484" TXTY="0"></TX></E></C><TS>20191122111602</TS></DAT>
<DAT DI="213" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000024" N="2" NM="��������� ������ 40% 1�" PRC="20800" Q="6000" SM="124800" TX="1"></P><L N="3">���:100165463 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" RM="200" SM="125000" T="0"></M><E CS="1" FN="3000746583" N="6" NO="208" SE="99047" SM="124800" TS="20191122111626"><TX DTPR="5.00" DTSM="5943" TX="1" TXAL="2" TXPR="20.00" TXSM="19810" TXTY="0"></TX></E></C><TS>20191122111626</TS></DAT>
<DAT DI="214" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000025" N="2" NM="������� ����� �������� 0="3">������ ��������� 675.50 ���.</L><L N="4">&quot;������� �����&quot; 14%</L><L N="5">���:100165464 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="���I���" RM="2580" SM="60000" T="0"></M><E CS="1" FN="3000746583" N="8" NO="209" SE="45572" SM="57420" TS="20191122112042"><TX DTPR="5.00" DTSM="2734" TX="1" TXAL="2" TXPR="20.00" TXSM="9114" TXTY="0"></TX></E></C><TS>20191122112042</TS></DAT>
<DAT DI="215" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000026" N="2" NM="ҳ������ ����� � ������ � ������� " PRC="1500" Q="2000" SM="3000" TX="1"></P><L N="3">���:100165465 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="������" SM="3000" T="2"></M><E CS="1" FN="3000746583" N="6" NO="210" SE="2500" SM="3000" TS="20191122112844"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="500" TXTY="0"></TX></E></C><TS>20191122112844</TS></DAT>
<DAT DI="216" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000027" N="2" NM="����� 39�49 � ��������" SM="291" TX="1"></P><L N="3">������ ��������� 3.00 ���.</L><L N="4">����������� &quot;�� �������������&quot; ���</L><L N="5">�� 3%</L><P C="00000000000028" N="6" NM="����� ���� ���� ������ ���� 2019 ��" SM="18899" TX="1"></P><L N="7">������ ��������� 235.00 ���.</L><L N="8">&quot;������� �����&quot; 19%</L><L N="9">���:100165466 501-���� 2 ���. &quot;³�</L><L N="10">���&quot; DP</L><M N="11" NM="���I���" RM="31010" SM="50200" T="0"></M><E CS="1" FN="3000746583" N="12" NO="211" SE="15241" SM="19190" TS="20191122113038"><TX DTPR="5.00" DTSM="900" TX="1" TXAL="2" TXPR="20.00" TXSM="3049" TXTY="0"></TX></E></C><TS>20191122113038</TS></DAT>
<DAT DI="218" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000032" N="2" NM="���� ϳ���� 150�"1"></P><L N="3">������ ��������� 60.00 ���.</L><P C="00000000000033" N="4" NM="����� ��������� �� ��� ��="6">���:100165468 501-���� 2 ���. &quot;³�</L><L N="7">���&quot; DP</L><M N="8" NM="���I���" RM="4000" SM="20140" T="0"></M><E CS="1" FN="3000746583" N="9" NO="213" SE="13450" SM="16140" TS="20191122113816"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="2690" TXTY="0"></TX></E></C><TS>20191122113816</TS></DAT>
<DAT DI="219" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="����� 39�49 � ��������" SM="300" TX="1"></P><P C="00000000000034" N="3" NM="�� ���� ��� ���� ������ ³��� ���� " SM="19900" TX="1"></P><L N="4">������ ��������� 265.00 ���.</L><L N="5">&quot;������� �����&quot; 24%</L><L N="6">���:100165469 501-���� 2 ���. &quot;³�</L><L N="7">���&quot; DP</L><M N="8" NM="���I���" SM="20200" T="0"></M><E CS="1" FN="3000746583" N="9" NO="214" SE="16043" SM="20200" TS="20191122114230"><TX DTPR="5.00" DTSM="948" TX="1" TXAL="2" TXPR="20.00" TXSM="3209" TXTY="0"></TX></E></C><TS>20191122114230</TS></DAT>
<DAT DI="220" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000035" N="2" NM="���������� ���� ������� ��� �������" SM="1140" TX="1"></P><L N="3">���:100165470 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" RM="860" SM="2000" T="0"></M><E CS="1" FN="3000746583" N="6" NO="215" SE="950" SM="1140" TS="20191122114452"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="190" TXTY="0"></TX></E></C><TS>20191122114452</TS></DAT>
<DAT DI="221" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000036" N="2" NM="������� ����� ҳ� ��� � ��� 16�" SM="1710" TX="1"></P><L N="3">���:100165471 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" RM="300" SM="2010" T="0"></M><E CS="1" FN="3000746583" N="6" NO="216" SE="1425" SM="1710" TS="20191122114710"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="285" TXTY="0"></TX></E></C><TS>20191122114710</TS></DAT>
<DAT DI="222" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="����� 39�49 � ��������" SM="300" TX="1"></P><P C="00000000000037" N="3" NM="������ ���� ����� ���� ��� �������" PRC="30000" Q="2000" SM="60000" TX="1"></P><L N="4">������ ��������� 753.80 ���.</L><L N="5">&quot;������� �����&quot; 20%</L><P C="00000000000038" N="6" NM="������� ���� ������ ˳ ������ 2017" PRC="31000" Q="2000" SM="62000" TX="1"></P><L N="7">������ ��������� 732.00 ���.</L><L N="8">&quot;������� �����&quot; 15%</L><L N="9">���:100165472 501-���� 2 ���. &quot;³�</L><L N="10">���&quot; DP</L><M N="11" NM="������" SM="122300" T="2"></M><E CS="1" FN="3000746583" N="12" NO="217" SE="97075" SM="122300" TS="20191122114846"><TX DTPR="5.00" DTSM="5810" TX="1" TXAL="2" TXPR="20.00" TXSM="19415" TXTY="0"></TX></E></C><TS>20191122114846</TS></DAT>
<DAT DI="223" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000039" N="2" NM="�`��� ����� ���� �`��� ����� ������" SM="18000" TX="1"></P><L N="3">������ ��������� 280.00 ���.</L><L N="4">&quot;������� �����&quot; 35%</L><P C="00000000000040" N="5" NM="������ �� ������ ���� � ����� �����" SM="15000" TX="1"></P><L N="6">������ ��������� 191.00 ���.</L><L N="7">&quot;������� �����&quot; 21%</L><L N="8">���:100165474 501-���� 2 ���. &quot;³�</L><L N="9">���&quot; DP</L><M N="10" NM="������" SM="33000" T="2"></M><E CS="1" FN="3000746583" N="11" NO="218" SE="26191" SM="33000" TS="20191122115320"><TX DTPR="5.00" DTSM="1571" TX="1" TXAL="2" TXPR="20.00" TXSM="5238" TXTY="0"></TX></E></C><TS>20191122115320</TS></DAT>
<DAT DI="224" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000041" N="2" NM="��������� ³�� ���� 0>������ ��������� 278.40 ���.</L><L N="4">&quot;������� �����&quot; 35%</L><P C="00000000000042" N="5" NM="������ �� ������ ���� � ������ ��� " SM="14000" TX="1"></P><L N="6">������ ��������� 191.50 ���.</L><L N="7">&quot;������� �����&quot; 26%</L><L N="8">���:100165476 501-���� 2 ���. &quot;³�</L><L N="9">���&quot; DP</L><M N="10" NM="������" SM="31900" T="2"></M><E CS="1" FN="3000746583" N="11" NO="219" SE="25317" SM="31900" TS="20191122115656"><TX DTPR="5.00" DTSM="1519" TX="1" TXAL="2" TXPR="20.00" TXSM="5064" TXTY="0"></TX></E></C><TS>20191122115656</TS></DAT>
<DAT DI="225" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000002" N="2" NM="����� 39�49 � ��������" SM="300" TX="1"></P><L N="3">���:100165477 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" SM="300" T="0"></M><E CS="1" FN="3000746583" N="6" NO="220" SE="250" SM="300" TS="20191122115730"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="50" TXTY="0"></TX></E></C><TS>20191122115730</TS></DAT>
<DAT DI="226" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000043" N="2" NM="������ � ������ 100� (� ����������)" SM="650" TX="1"></P><L N="3">���:100165478 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" SM="650" T="0"></M><E CS="1" FN="3000746583" N="6" NO="221" SE="542" SM="650" TS="20191122115752"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="108" TXTY="0"></TX></E></C><TS>20191122115752</TS></DAT>
<DAT DI="227" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000044" N="2" NM="г� ������� ѳ� ������ 1�" SM="3130" TX="1"></P><L N="3">���:100165479 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" RM="6870" SM="10000" T="0"></M><E CS="1" FN="3000746583" N="6" NO="222" SE="2608" SM="3130" TS="20191122115808"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="522" TXTY="0"></TX></E></C><TS>20191122115808</TS></DAT>
<DAT DI="228" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000045" N="2" NM="������� � ������ 100�" SM="950" TX="1"></P><L N="3">���:100165480 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" SM="950" T="0"></M><E CS="1" FN="3000746583" N="6" NO="223" SE="792" SM="950" TS="20191122115840"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="158" TXTY="0"></TX></E></C><TS>20191122115840</TS></DAT>
<DAT DI="229" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000046" N="2" NM="��������� ������ VS 000000000047" N="3" NM="³����� ����� ���� ��� ��� ҳ��� �" PRC="6560" Q="3000" SM="19680" TX="1"></P><P C="00000000000048" N="4" NM="³����� ����� ���� ��� ��� ������ " PRC="6560" Q="12000" SM="78720" TX="1"></P><L N="5">���:100165481 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="���I���" SM="203300" T="0"></M><E CS="1" FN="3000746583" N="8" NO="224" SE="161349" SM="203300" TS="20191122120310"><TX DTPR="5.00" DTSM="9681" TX="1" TXAL="2" TXPR="20.00" TXSM="32270" TXTY="0"></TX></E></C><TS>20191122120310</TS></DAT>
<DAT DI="230" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000049" N="2" NM="��� ���������� ������ �����������" SM="1265" TX="1"></P><P C="00000000000045" N="3" NM="������� � ������ 100�" SM="950" TX="1"></P><L N="4">���:100165482 501-���� 2 ���. &quot;³�</L><L N="5">���&quot; DP</L><M N="6" NM="������" SM="2215" T="2"></M><E CS="1" FN="3000746583" N="7" NO="225" SE="1846" SM="2215" TS="20191122120628"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="369" TXTY="0"></TX></E></C><TS>20191122120628</TS></DAT>
<DAT DI="231" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000050" N="2" NM="³� ����� ³��������� F ID 017" SM="17950" TX="1"></P><L N="3">���:100165483 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="������" SM="17950" T="2"></M><E CS="1" FN="3000746583" N="6" NO="226" SE="14958" SM="17950" TS="20191122121350"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="2992" TXTY="0"></TX></E></C><TS>20191122121350</TS></DAT>
<DAT DI="232" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000043" N="2" NM="������ � ������ 100� (� ����������)" PRC="650" Q="4000" SM="2600" TX="1"></P><L N="3">���:100165484 501-���� 2 ���. &quot;³�</L><L N="4">���&quot; DP</L><M N="5" NM="���I���" SM="2600" T="0"></M><E CS="1" FN="3000746583" N="6" NO="227" SE="2167" SM="2600" TS="20191122121556"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="433" TXTY="0"></TX></E></C><TS>20191122121556</TS></DAT>
<DAT DI="233" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000051" N="2" NM="���������� ���� ������� ������ ����" SM="1230" TX="1"></P><L N="3">������ ��������� 15.40 ���.</L><L N="4">&quot;������� �����&quot; 20%</L><L N="5">���:100165485 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="������" SM="1230" T="2"></M><E CS="1" FN="3000746583" N="8" NO="228" SE="1025" SM="1230" TS="20191122122956"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="205" TXTY="0"></TX></E></C><TS>20191122122956</TS></DAT>
<DAT DI="234" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000052" N="2" NM="������� ���� ճ�� ��� ��" PRC="5000" Q="2000" SM="10000" TX="1"></P><P C="00000000000053" N="3" NM="������� ��������� 30� " PRC="250" Q="2000" SM="500" TX="1"></P><P C="00000000000054" N="4" NM="����� ³������<L N="5">������ ��������� 31.03 ���.</L><L N="6">����������� &quot;�� �������������&quot; ���</L><L N="7">�� 10%</L><P C="00000000000055" N="8" NM="������� ������="1"></P><L N="9">������ ��������� 23.40 ���.</L><L N="10">����������� &quot;�� �������������&quot; ���</L><L N="11">�� 10%</L><L N="12">���:100165486 501-���� 2 ���. &quot;³�</L><L N="13">���&quot; DP</L><M N="14" NM="���I���" RM="4601" SM="20000" T="0"></M><E CS="1" FN="3000746583" N="15" NO="229" SE="12436" SM="15399" TS="20191122123256"><TX DTPR="5.00" DTSM="476" TX="1" TXAL="2" TXPR="20.00" TXSM="2487" TXTY="0"></TX></E></C><TS>20191122123256</TS></DAT>
<DAT DI="235" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000056" N="2" NM="���� ϳ���� 150���� ��������� 30.00 ���.</L><P C="00000000000043" N="4" NM="������ � ������ 100� (� ����������)" SM="650" TX="1"></P><L N="5">������ ��������� 6.50 ���.</L><P C="00000000000057" N="6" NM="³������ ��������:100165487 501-���� 2 ���. &quot;³�</L><L N="9">���&quot; DP</L><M N="10" NM="���I���" RM="4100" SM="11000" T="0"></M><E CS="1" FN="3000746583" N="11" NO="230" SE="5750" SM="6900" TS="20191122123718"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="1150" TXTY="0"></TX></E></C><TS>20191122123718</TS></DAT>
<DAT DI="236" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000058" N="2" NM="���� ϳ���� 150���� ��������� 30.00 ���.</L><L N="4">����������� &quot;�� �������������&quot; 10%</L><P C="00000000000059" N="5" NM="������� ��� 100�" SM="1250" TX="1"></P><L N="6">���:100165488 501-���� 2 ���. &quot;³�</L><L N="7">���&quot; DP</L><M N="8" NM="������" SM="3950" T="2"></M><E CS="1" FN="3000746583" N="9" NO="231" SE="3292" SM="3950" TS="20191122123842"><TX DTPR="0.00" DTSM="0" TX="1" TXAL="0" TXPR="20.00" TXSM="658" TXTY="0"></TX></E></C><TS>20191122123842</TS></DAT>
<DAT DI="237" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000060" N="2" NM="��������� �������� ����" SM="5300" TX="1"></P><P C="00000000000061" N="3" NM="��������� �������� ѳ�� ���" SM="5300" TX="1"></P><P C="00000000000053" N="4" NM="������� ��������� 30� " PRC="250" Q="2000" SM="500" TX="1"></P><P C="00000000000062" N="5" NM="����� ³������ N="7">����������� &quot;�� �������������&quot; ���</L><L N="8">�� 10%</L><L N="9">���:100165489 501-���� 2 ���. &quot;³�</L><L N="10">���&quot; DP</L><M N="11" NM="������" SM="13710" T="2"></M><E CS="1" FN="3000746583" N="12" NO="232" SE="11004" SM="13710" TS="20191122123956"><TX DTPR="5.00" DTSM="505" TX="1" TXAL="2" TXPR="20.00" TXSM="2201" TXTY="0"></TX></E></C><TS>20191122123956</TS></DAT>
<DAT DI="238" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000063" N="2" NM="����� ���� ���� ����� � ������ 0 SM="39970" TX="1"></P><L N="3">������ ��������� 453.20 ���.</L><L N="4">������ ��������� 453.20 ���.</L><L N="5">����������� &quot;�� �������������&quot; 10%</L><L N="6">����������� &quot;������ ��� ������� 2�</L><L N="7"> � ����� �������&quot; (��������������)</L><L N="8"> 2%</L><L N="9">���:100165490 501-���� 2 ���. &quot;³�</L><L N="10">���&quot; DP</L><M N="11" NM="���I���" RM="30" SM="40000" T="0"></M><E CS="1" FN="3000746583" N="12" NO="233" SE="31722" SM="39970" TS="20191122124032"><TX DTPR="5.00" DTSM="1903" TX="1" TXAL="2" TXPR="20.00" TXSM="6345" TXTY="0"></TX></E></C><TS>20191122124032</TS></DAT>
<DAT DI="239" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><P C="00000000000064" N="2" NM="³����� ����� ���� ��� ��� ҳ��� �" PRC="6900" Q="3000" SM="20700" TX="1"></P><L N="3">������ ��������� 281.70 ���.</L><L N="4">&quot;������� �����&quot; 26%</L><L N="5">���:100165491 501-���� 2 ���. &quot;³�</L><L N="6">���&quot; DP</L><M N="7" NM="���I���" SM="20700" T="0"></M><E CS="1" FN="3000746583" N="8" NO="234" SE="16428" SM="20700" TS="20191122124830"><TX DTPR="5.00" DTSM="986" TX="1" TXAL="2" TXPR="20.00" TXSM="3286" TXTY="0"></TX></E></C><TS>20191122124830</TS></DAT>
<DAT DI="241" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="236" VD="1" TS="20191122161712"></E></C><TS>20191122161712</TS></DAT>
<DAT DI="242" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="237" VD="1" TS="20191122161828"></E></C><TS>20191122161828</TS></DAT>
<DAT DI="243" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="238" VD="1" TS="20191122170144"></E></C><TS>20191122170144</TS></DAT>
<DAT DI="244" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="0"><L N="1">00001 01</L><E CS="1" FN="3000746583" N="2" NO="239" VD="1" TS="20191122171146"></E></C><TS>20191122171146</TS></DAT>
<DAT DI="245" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><C T="2"><O N="1" SM="669139" T="0"></O><E N="2"></E></C><TS>20191122172242</TS></DAT>
<DAT DI="246" DT="0" FN="3000746583" TN="�� 410869004616" V="1" ZN="��00002112"><Z NO="2"><TXS DTI="69943" DTPR="5.00" SMI="1564075" TS="20191121" TX="1" TXAL="2" TXI="249022" TXO="0" TXPR="20.00" TXTY="0"></TXS><M NM="���I���" SMI="649139" SMO="0" T="0"></M><M NM="���" SMI="40000" T="1"></M><M NM="������" SMI="874936" T="2"></M><IO SMI="20000" SMO="669139" T="0"></IO><NC NI="46" NO="0"></NC></Z><TS>20191122172334</TS></DAT>
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
      ,CASE WHEN q.lol = '������'
	  THEN 27 ELSE 0 END
	  ,q.tet/100
FROM (
SELECT 199 AS kek, '������' AS lol, 31000 AS tet UNION ALL
SELECT 200 AS kek, '���' AS lol, 40000 AS tet UNION ALL
SELECT 201 AS kek, '���I���' AS lol, 28000 AS tet UNION ALL
SELECT 202 AS kek, '������' AS lol, 44850 AS tet UNION ALL
SELECT 203 AS kek, '������' AS lol, 64360 AS tet UNION ALL
SELECT 204 AS kek, '������' AS lol, 22150 AS tet UNION ALL
SELECT 205 AS kek, '������' AS lol, 35295 AS tet UNION ALL
SELECT 206 AS kek, '������' AS lol, 19000 AS tet UNION ALL
SELECT 207 AS kek, '������' AS lol, 6070 AS tet UNION ALL
SELECT 208 AS kek, '������' AS lol, 41585 AS tet UNION ALL
SELECT 209 AS kek, '������' AS lol, 2880 AS tet UNION ALL
SELECT 210 AS kek, '���I���' AS lol, 22010 AS tet UNION ALL
SELECT 211 AS kek, '������' AS lol, 268800 AS tet UNION ALL
SELECT 212 AS kek, '���I���' AS lol, 50000 AS tet UNION ALL
SELECT 213 AS kek, '���I���' AS lol, 125000 AS tet UNION ALL
SELECT 214 AS kek, '���I���' AS lol, 60000 AS tet UNION ALL
SELECT 215 AS kek, '������' AS lol, 3000 AS tet UNION ALL
SELECT 216 AS kek, '���I���' AS lol, 50200 AS tet UNION ALL
SELECT 218 AS kek, '���I���' AS lol, 20140 AS tet UNION ALL
SELECT 219 AS kek, '���I���' AS lol, 20200 AS tet UNION ALL
SELECT 220 AS kek, '���I���' AS lol, 2000 AS tet UNION ALL
SELECT 221 AS kek, '���I���' AS lol, 2010 AS tet UNION ALL
SELECT 222 AS kek, '������' AS lol, 122300 AS tet UNION ALL
SELECT 223 AS kek, '������' AS lol, 33000 AS tet UNION ALL
SELECT 224 AS kek, '������' AS lol, 31900 AS tet UNION ALL
SELECT 225 AS kek, '���I���' AS lol, 300 AS tet UNION ALL
SELECT 226 AS kek, '���I���' AS lol, 650 AS tet UNION ALL
SELECT 227 AS kek, '���I���' AS lol, 10000 AS tet UNION ALL
SELECT 228 AS kek, '���I���' AS lol, 950 AS tet UNION ALL
SELECT 229 AS kek, '���I���' AS lol, 203300 AS tet UNION ALL
SELECT 230 AS kek, '������' AS lol, 2215 AS tet UNION ALL
SELECT 231 AS kek, '������' AS lol, 17950 AS tet UNION ALL
SELECT 232 AS kek, '���I���' AS lol, 2600 AS tet UNION ALL
SELECT 233 AS kek, '������' AS lol, 1230 AS tet UNION ALL
SELECT 234 AS kek, '���I���' AS lol, 20000 AS tet UNION ALL
SELECT 235 AS kek, '���I���' AS lol, 11000 AS tet UNION ALL
SELECT 236 AS kek, '������' AS lol, 3950 AS tet UNION ALL
SELECT 237 AS kek, '������' AS lol, 13710 AS tet UNION ALL
SELECT 238 AS kek, '���I���' AS lol, 40000 AS tet UNION ALL
SELECT 239 AS kek, '���I���' AS lol, 20700 AS tet
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
WHERE UAProdName LIKE '���� �� ������ ������ ����� VSOP 4%'
--WHERE UAProdName LIKE '³����� ����� ���� ������ ҳ���%'

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
