SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<rkv0>
-- Create date: <'2021-05-31 17:42'>
-- Description:	<Информация о расходной накладной по номеру заказа>
-- =============================================
alter PROCEDURE dbo.[ap_EXITE_tInvDoc_info] @n varchar(255)
AS
BEGIN

	--TEST
	--EXEC dbo.ap_EXITE_tInvDoc_info '  PO001WN7KX  '

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @n = (SELECT LTRIM(RTRIM(REPLACE('	    	 	 	PO001WN7KX            ', CHAR(9), ''))))
	-- Insert statements for procedure here
	--#region РН
	SELECT ''                'ЗАГОЛОВОК'
	,      ChID              'ChID'
	,      DocID             'Номер документа'
	,      DocDate           'Дата документа'
	,      TaxDocID          '№ налоговой накладной'
	,      TaxDocDate        'Дата налоговой накладной'
	,      TSumCC_nt         'Всего без НДС'
	,      TTaxSum           'НДС по документу'
	,      TSumCC            'Всего с НДС'
	,      OrderID          
	,      OurID            
	,      (SELECT SUM(qty)
	FROM t_InvD
	WHERE ChID = (SELECT MAX(ChID)
		FROM t_inv
		WHERE OrderID = @n)) '|| Всего бутылок отгружено ||'
	,      i.CompID         
	,      (
	SELECT TOP 1 CompShort
	FROM dbo.r_Comps c WITH(NOLOCK)
	WHERE c.CompID = i.CompID
	)                        'CompShort'
	,      [Address]        
	,      *                
	FROM dbo.t_Inv i WITH(NOLOCK)
	WHERE OrderID LIKE cast((@n + '%') as varchar) --cast(@n AS VARCHAR) --t_Inv
		AND EXISTS (
		SELECT *
		FROM dbo.t_InvD d
		WHERE d.ChID = i.ChID
		)
	SELECT ''              'ДЕТАЛИ'
	,      pp.CstProdCode 
	,      ps.ProdName    
	,      pc.ExtProdID   
	,      i.ChID         
	,      i.SrcPosID     
	,      i.ProdID       
	,      i.PPID         
	,      i.UM           
	,      i.Qty          
	,      i.PriceCC_nt   
	,      i.SumCC_nt     
	,      i.Tax          
	,      i.TaxSum       
	,      i.PriceCC_wt   
	,      i.SumCC_wt     
	,      i.BarCode      
	,      i.SecID        
	,      i.PurPriceCC_wt
	FROM      dbo.t_InvD   i WITH(NOLOCK) 
	JOIN      dbo.t_PInP   pp WITH(NOLOCK) ON pp.ProdID = i.ProdID
			AND pp.PPID = i.PPID
	JOIN      dbo.r_Prods  ps WITH(NOLOCK) ON ps.ProdID = i.ProdID
	JOIN      dbo.t_Inv    d WITH(NOLOCK)  ON d.chid = i.chid
	LEFT JOIN dbo.r_ProdEC pc WITH(NOLOCK) ON pc.ProdID = i.ProdID
			AND pc.CompID = d.CompID
	WHERE i.ChID IN (
		SELECT ChID
		FROM dbo.t_Inv i
		WHERE OrderID LIKE cast((@n + '%') as varchar) --LIKE cast(@n AS VARCHAR)
		)
	--ORDER BY 1, 2
	ORDER BY i.SumCC_nt DESC
	SELECT '' 'ЕЩЕ БОЛЬШЕ ДЕТАЛЕЙ'
	,      * 
	FROM dbo.at_t_InvLoad il WITH(NOLOCK)
	WHERE il.ChID IN (
		SELECT ChID
		FROM dbo.t_Inv i
		WHERE OrderID LIKE cast((@n + '%') as varchar) --LIKE cast(@n AS VARCHAR)
		)
--#endregion № РН
END
GO
