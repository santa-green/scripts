;WITH TCh (ChID) AS (SELECT ChID FROM dbo.t_Inv WHERE OurID = 1 AND DocID IN (SELECT AValue FROM dbo.zf_FilterToTable(3011738))),     
TDoc AS (                    
SELECT m.ChID,Case When m.CompID = 7004 Then 'Сплачено імпортером ТОВ «Арда-Трейдинг»'end as CompIDD, m.SrcDocID, m.SrcDocDate, m.DocDate, m.TaxDocID AS TaxDocID, m.TaxDocDate AS TaxDocDate, rc3.CForm,
CASE WHEN m.CompID BETWEEN 7000 AND 7003 OR (ISNULL(NULLIF(CAST(m.TaxDocID AS VARCHAR(20)), ''), '0') = '0' AND rc3.CForm = 2) THEN m.DocID ELSE m.TaxDocID END DocID,
CAST(rd.CarName + ISNULL(' ' + rud.Notes, '') AS VARCHAR(250)) CarName, rd.CarNo, rd.TrailerNo, CASE m.CodeID4 WHEN 102 THEN 'Централізовані перевезення' ELSE 'вантажоперевезення' END TransType,                                                                                                                        
rc4.CodeName4 TransName, CASE WHEN rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' THEN rc4.Notes END RealTransCode, ro.Note1 CustShort, ro.Note2 CustName, ISNULL(red.MilCalcGrp + ' ','') + ISNULL(red.UAEmpName, rd.DriverName) DriverName,
ISNULL(red.UAEmpLastName + ' ' + LEFT(red.UAEmpFirstName,1) + '.' +  LEFT(red.UAEmpParName,1) + '.', rd.DriverName) ShortDriverName, rd.DriverLicenseNo DriverLicenseNo,
ro.Note2 FwName, ', ' + ro.[Address] + ', ' + ro.City + ', ' + ro.PostIndex FwAddress, ', ЄДРПОУ ' + ro.Code FwCode, ', р/р ' + dbo.af_GetFiltered(occ.AccountCC) + ' в ' + rsb.BankName + ', МФО ' + CAST(rsb.BankID AS VARCHAR(10)) FwBankReqs, ISNULL(', ' + NULLIF(ro.Note3, ''), '') FwLics,

rc.Contract1 CnName,
 ', ' + LTRIM(RTRIM(rc.Address)) + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.City)),''),'') + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.Region)),''),'') + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.PostIndex)),''),'')  CnAddress,
 
case when m.CompID = 7004 then 'ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ «ЛОГІСТИК ЮНІОН»' else rc.Contract1 end CnNameAtb,
case when m.CompID = 7004 then ', 52005, Дніпропетровська область, Дніпровський район, Комплекс будівель та споруд, буд.8, офіс 229' else
 ', ' + LTRIM(RTRIM(rc.Address)) + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.City)),''),'') + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.Region)),''),'') + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.PostIndex)),''),'') end CnAddressAtb,
case when m.CompID = 7004 then ', акт приймання передачі №' + 
	CAST(CASE WHEN m.CompID BETWEEN 7000 AND 7003 OR (ISNULL(NULLIF(CAST(m.TaxDocID AS VARCHAR(20)), ''), '0') = '0' AND rc3.CForm = 2) THEN m.DocID ELSE m.TaxDocID END as VARCHAR)
 + ' від ' + CONVERT( VARCHAR(10), m.DocDate, 104)  + 'р.' else '' end IncDocsAtb,
 
  ', ЄДРПОУ ' + CASE WHEN LEN(ISNULL(rc.Code, '')) IN (8,10) THEN rc.Code END CnCode, ', ІПН: ' + CASE WHEN LEN(ISNULL(rc.TaxCode, '')) IN (10,12) THEN rc.TaxCode END CnTaxCode, ', р/р ' + dbo.af_GetFiltered(rcc.CompAccountCC) + ' в ' + rcb.BankName + ', МФО ' + CAST(rcb.BankID AS VARCHAR) CnBankReqs,
', ' + ruca.Notes + ISNULL(CASE WHEN zca.LicDocTypeID IN (1,4) THEN ' ' + zca.LicSer WHEN zca.LicDocTypeID = 3 THEN '' END + ' № ' + NULLIF(zca.LicNo, ''), '') + ' від ' + dbo.zf_DateToStr(NULLIF(zca.LicBDate, 0)) + ' р.' CnLics, CASE zca.SingleAttor WHEN 1 THEN CAST(zca.AttorID AS VARCHAR(250)) WHEN 0 THEN 'кільцева' END CnAttorNum, zca.AttorDate CnAttorDate,
CASE zca.SingleAttor WHEN 1 THEN CAST(zca.AttorID AS VARCHAR(250)) WHEN 0 THEN 'кільцева' END FwAttorNum, zca.AttorDate FwAttorDate,  
rs.StockName FwStockName, m.Address CnStockName,
  
Case When cs.CompClassID = 3 Then cs.Contract2 + ', '+ cs.Contract3 + ', ' + 'ЄДРПОУ ' + rc.License1  
ELSE rc.Contract1  + ', ' + LTRIM(RTRIM(rc.Address)) + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.City)),''),'') + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.Region)),''),'') + ISNULL(', ' + NULLIF(LTRIM(RTRIM(rc.PostIndex)),''),'') + ', ЄДРПОУ ' + CASE WHEN LEN(ISNULL(rc.Code, '')) IN (8,10) THEN rc.Code END  end CnDate,

ro.Code RealFwCode, ro.Code RealCustCode, rc.Code RealCnCode,
CASE WHEN m.OurID = 3 THEN reos.UAEmpName ELSE res.UAEmpName  END as UAEmpName,--для фирмы 3  
CASE WHEN m.OurID = 3 THEN 'фахівець з логістики' ELSE res.MilCalcGrp END as MilCalcGrp ,--для фирмы 3
 ShortUAEmpName = res.UAEmpLastName + ' ' + LEFT(res.UAEmpFirstName, 1) + '.' + LEFT(res.UAEmpParName, 1) + '.',
reos.UAEmpName AccUAEmpName, reos.MilCalcGrp AccMilCalcGrp, AccShortUAEmpName = reos.UAEmpLastName + ' ' + LEFT(reos.UAEmpFirstName, 1) + '.' + LEFT(reos.UAEmpParName, 1) + '.',
(SELECT SUM(Qty) FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID = mm.ChID WHERE mm.ChID IN (SELECT ChID FROM TCh)) TQty,
case when m.CompID = 7004 then ISNULL(NULLIF((SELECT SUM(MQQty) FROM (SELECT SUM(CEILING((dd.Qty)/mq.Qty)) MQQty FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID = mm.ChID JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = dd.ProdID AND mq.UM LIKE 'ящ%' AND mq.Qty > 0 WHERE mm.ChID IN (SELECT ChID FROM TCh) GROUP BY dd.ProdID, mq.Qty) dmq), 0), 1) else ISNULL(NULLIF((SELECT SUM(MQQty) FROM (SELECT ROUND(SUM(dd.Qty)/mq.Qty, 0) MQQty FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID = mm.ChID JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = dd.ProdID AND mq.UM LIKE 'ящ%' AND mq.Qty > 0 WHERE mm.ChID IN (SELECT ChID FROM TCh) GROUP BY dd.ProdID, mq.Qty) dmq), 0), 1) end TMQQty,
ROUND((SELECT SUM(SumCC_wt) FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID = mm.ChID WHERE mm.ChID IN (SELECT ChID FROM TCh)),2) TSumCC_wt,
ROUND((SELECT SUM(TaxSum) FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID = mm.ChID WHERE mm.ChID IN (SELECT ChID FROM TCh)),2) TTaxSum,
ROUND((SELECT SUM(dd.Qty * rp.WeightGrWP) FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID = mm.ChID JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = dd.ProdID WHERE mm.ChID IN (SELECT ChID FROM TCh)) / 1000, 3) TWeight,
CAST(CASE WHEN EXISTS (SELECT * FROM dbo.t_Inv mm WITH(NOLOCK) JOIN dbo.t_InvD dd WITH(NOLOCK) ON dd.ChID = mm.ChID JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = dd.ProdID WHERE mm.ChID IN (SELECT ChID FROM TCh) AND rp.PCatID IN (24,30,32,34,38,48,49,95,99,1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19)) THEN 1 ELSE 0 END AS BIT) IsAlco                    
FROM dbo.t_Inv m WITH(NOLOCK)
join r_Comps cs WITH(NOLOCK) on m.CompID = cs.Compid    
JOIN dbo.r_Codes3 rc3 WITH(NOLOCK) ON rc3.CodeID3 = m.CodeID3
LEFT JOIN dbo.r_Codes4 rc4 WITH(NOLOCK) ON rc4.CodeID4 = m.CodeID4 AND rc4.CodeID4 != 0 AND 1 = 1
LEFT JOIN dbo.r_Codes5 rc5 WITH(NOLOCK) ON rc5.CodeID5 = m.CodeID5 AND rc5.CodeID5 != 0
JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
JOIN dbo.r_OursCC occ WITH(NOLOCK) ON occ.OurID=ro.OurID AND occ.ChID = 156
JOIN dbo.r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
JOIN dbo.r_Emps res WITH(NOLOCK) ON res.EmpID = rs.EmpID
LEFT JOIN dbo.r_Banks rsb WITH(NOLOCK) ON rsb.BankID=occ.BankID
OUTER APPLY dbo.af_GetCompReqs(m.CompID, m.TaxDocDate) rc
LEFT JOIN dbo.r_CompsCC rcc WITH(NOLOCK) ON rcc.CompID = m.CompID AND rcc.DefaultAccount = 1
LEFT JOIN dbo.r_Banks rcb WITH(NOLOCK) ON rcb.BankID = rcc.BankID AND rcb.BankID != 0
LEFT JOIN dbo.r_CompsAdd rcad WITH(NOLOCK) ON rcad.CompID = m.CompID AND rcad.CompAdd = m.Address
LEFT JOIN dbo.at_r_Drivers rd WITH(NOLOCK) ON rd.DriverID = m.DriverID AND rd.DriverId != 0 AND 1 = 1
LEFT JOIN dbo.r_Emps red WITH(NOLOCK) ON red.EmpID = rd.EmpID AND red.EmpID NOT IN (0,3)
LEFT JOIN dbo.r_Uni rud WITH(NOLOCK) ON rud.RefTypeID = 80020 AND rud.RefName = REPLACE(LTRIM(RTRIM(LEFT(rd.CarName,ISNULL(NULLIF(PATINDEX('%[0-9]%', rd.CarName),0),255) - 1))), '  ', '') AND m.CompID = 7004                                                         
LEFT JOIN dbo.z_DocLinks z WITH(NOLOCK) ON z.ChildDocCode = 11012 AND z.ParentDocCode = 666028 AND z.ChildChID = m.ChID
LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = z.ParentChID
LEFT JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
LEFT JOIN dbo.at_z_ContractsAdd zca WITH(NOLOCK) ON zca.ChID = z.ParentChID AND zca.CompID = rca.CompID AND zca.CompAddID = rca.CompAddID
LEFT JOIN dbo.r_Uni ruca WITH(NOLOCK) ON ruca.RefTypeID = 6660113 AND ruca.RefID = zca.LicDocTypeID AND ruca.RefID != 0
LEFT JOIN dbo.at_r_OurAccSector ros WITH(NOLOCK) ON ros.OurID = m.OurID AND ros.StockGID = rs.StockGID
LEFT JOIN dbo.r_Emps reos WITH(NOLOCK) ON reos.EmpID = ros.EmpID
WHERE m.ChID IN (SELECT ChID FROM TCh))

SELECT TOP 1 *
/* Если исходных документов несколько, надо выводить несколько номеров через запятую */          
, CAST(
CASE WHEN (SELECT COUNT(*) FROM TCh) > 1 THEN 'Видаткові накладні №№' + SUBSTRING((SELECT ',' + CAST(DocID AS VARCHAR) FROM TDoc FOR XML PATH('')), 2, 16000000) + ' від ' + dbo.zf_DateToStr(DocDate) + ' р.'
/* Иначе, если запись одна, выводим один номер. Текст должен тоже соответствовать одному номеру */          
  ELSE 'Видаткова накладна № ' + CAST(DocID AS VARCHAR) + ' від ' + dbo.zf_DateToStr(DocDate) + ' р.' +
    CASE WHEN TaxDocDate >= '20150101' THEN '' ELSE CHAR(13) + CHAR(10) + 'Податкова накладна № ' + CAST(TaxDocID AS VARCHAR) + ' від ' + dbo.zf_DateToStr(TaxDocDate) + ' р.' END END AS VARCHAR(250)) AS IncDocs
FROM TDoc

--[dq_Doc."CnName"][dq_Doc."CnAddress"]
--[dq_Doc."IncDocs"]
--[dq_Doc."DocID"]
--[dq_Doc."DocDate" #ddd]