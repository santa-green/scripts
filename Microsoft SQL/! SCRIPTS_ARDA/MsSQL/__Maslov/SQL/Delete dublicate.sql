/*
So. It`s script for deleting dublicates in table ALEF_EDI_ORDERS_2_POS.
How it work... Form special CTE where we find dublicates and their number.
Number of dublicates write in other row, that will be create in CTE.
For example in table three dublicates. So, in new row 'number_of_dublicates'
will be '1,2,3' right in front of dublicated records. So, we need to delete
every record where 'number_of_dublicates' bigger then 1.
*/

BEGIN TRAN;
SELECT * FROM t_IMOrdersD
;WITH
Dublicates AS (SELECT DocID, PosID, ProdID, Qty, PurPrice, Discount, RemSchID, IsVIP
, ROW_NUMBER() OVER(PARTITION BY DocID, PosID, ProdID, Qty, PurPrice, Discount, RemSchID, IsVIP ORDER BY DocID) number_of_dublicates
FROM t_IMOrdersD)

DELETE FROM Dublicates WHERE number_of_dublicates > 1
--SELECT * FROM Dublicates WHERE number_of_dublicates > 1
SELECT * FROM t_IMOrdersD
ROLLBACK TRAN;


/*
SELECT * FROM  ALEF_EDI_ORDERS_2_POS d
where  ZEP_ORDER_ID in 
(
SELECT ZEP_ORDER_ID FROM ALEF_EDI_ORDERS_2_POS group by ZEP_ORDER_ID, ZEP_POS_ID having count(ZEP_POS_ID) > 1
)
ORDER BY 1,2

*/