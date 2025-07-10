SELECT aer.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280'
    ORDER BY tid.SrcPosID ASC

SELECT aerp.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280'
    ORDER BY tid.SrcPosID ASC

SELECT ti.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280'
    ORDER BY tid.SrcPosID ASC

SELECT tid.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280'
    ORDER BY tid.SrcPosID ASC

SELECT pp.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280'
    ORDER BY tid.SrcPosID ASC

    
SELECT ps.* FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280'
    ORDER BY tid.SrcPosID ASC

    
SELECT aerp.REP_POS_KOD, * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.extprodid = aerp.REP_POS_KOD and rp.Compid = ti.Compid and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280' AND rp.ProdID IS NOT NULL --and aerp.REP_POS_KOD = 95263522
    
    UNION ALL

SELECT aerp.REP_POS_KOD FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.extprodid = aerp.REP_POS_KOD and rp.Compid = ti.Compid and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280' --AND rp.ProdID IS NOT NULL --and aerp.REP_POS_KOD = 95263522 
    group by aerp.REP_POS_KOD

    EXCEPT 
    SELECT aerp.REP_POS_KOD FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.extprodid = aerp.REP_POS_KOD and rp.Compid = ti.Compid and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280' AND rp.ProdID IS NOT NULL --and aerp.REP_POS_KOD = 95263522 
    group by aerp.REP_POS_KOD




    SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV aer WITH(NOLOCK)--ORDER BY REC_INV_DATE DESC
    JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_RECADV_POS aerp WITH(NOLOCK) ON aer.REC_INV_ID = aerp.REP_INV_ID and aer.REC_INV_DATE = aerp.REP_INV_DATE
    JOIN dbo.t_inv ti WITH(NOLOCK) ON ti.Orderid = aer.REC_ORD_ID
    JOIN dbo.t_InvD tid WITH(NOLOCK) ON ti.ChID = tid.ChID
    --LEFT JOIN dbo.r_prodec rp WITH(NOLOCK) ON rp.Compid = ti.Compid and rp.extprodid = aerp.REP_POS_KOD and rp.ProdID = tid.ProdID
    WHERE ti.orderid = 'пнг01084280' --AND rp.ProdID IS NOT NULL
   
   JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = tid.ProdID AND pp.PPID = tid.PPID
    JOIN dbo.r_Prods ps WITH(NOLOCK) ON ps.ProdID = tid.ProdID
    --ORDER BY rp.ProdID ASC

