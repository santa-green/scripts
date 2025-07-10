/*������� �������� Ad Hoc Distributed Queries ����������� ���������
USE master;
GO
EXEC sp_configure 'show advanced option', '1';

exec sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
*/

USE base1;
SELECT * 
into #Vkod
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; IMEX=1; Database=C:\Tmp\test.xlsx' , 'select * from [����1$]');

select * from #Vkod

--delete r_ProdEC where ProdID in (select prodid from #Vkod)

--insert into r_ProdEC
--from #Vkod

SELECT * FROM OPENDATASOURCE('Microsoft.Jet.OLEDB.4.0','Data Source=C:\Tmp\test.xlsx;Extended Properties=EXCEL 14.0')...[Sheet1$] ;

SELECT * FROM OPENROWSET('MSDASQL','Driver={Microsoft Excel Driver (*.xls)}; DBQ=[C:\Tmp\test.xls]', 'SELECT * FROM [Sheet1$A8:D10000]')

��������� �������� ������ �� MS SQL Server  � ��������� ������� Excel(.xls,.xlsx):


1)� �������������� ������� OPENROWSET ��� � OPENDATASOURCE:
SELECT * FROM OPENROWSET('MSDASQL',
'Driver={Microsoft Excel Driver (*.xls)};
DBQ=[C:\gr_otchet.xls]', 'SELECT * FROM [Sheet1$A8:D10000]'
������ ��� OPENDATASOURCE �� BOL:
SELECT * FROM OPENDATASOURCE('Microsoft.Jet.OLEDB.4.0',
'Data Source=C:\DataFolder\Documents\TestExcel.xls;Extended Properties=EXCEL 5.0')...[Sheet1$] ;
���� �� ����������������  �������, ��� ���������� ��������� ��� �64 ���������, ��� ��������� �32 ������ ��� �64 �������. ��������, ��������� Microsoft.Jet.OleDB ��� 64 ������,� ���� ������  ����� ������������ ������ ��������, � �������  Microsoft.ACE.OLEDB.12.0.

�� �������� ������ ��� ���������� ��  BOL:
������� OPENROWSET  ���  OPENDATASOURCE ����� ���� ������������ ��� ������� � ��������� ������ �� ���������� ������ OLE DB 
������ � ��� ������, ���� ��� ��������� ���������� �������� ������� DisallowAdhocAccess ���� ���������� � 0 � 
������� �������� Ad Hoc Distributed Queries ����������� ���������. ���� ��� ��������� �� �����������, ��������� �� ��������� ��������� �������������������� ������.
���� �������� Ad Hoc Distributed Queries ��������, ��  �� ����� �������������� ���������. ��������� ��������� �������������� ����� �������� ��������� sp_configure.
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

2) ������ ����� ����� Linkedserver � ODBC �������.
1-�� ������ ������, ����� ���������� ������������ ������, ��� ������� � ������ ������������� ����� ������������ ���������� ���������� �������(Linked Server)
��� ����� ���������� ���������� �� ������� MS SQL Server ODBC ������� � ��� Excel, ����� ������� �������� ������( ����������������� ->��������� ������)


��������� ��� ��������� ������ ,������ Excel � ��� ����.
��������� ��������.
����� ����� ������� ��������� ������ LinkedServed (��������� ������):




��������� ��� ������  ���������� ������� � ��� ���������� ���� ������� ODBC ���������.
���������.
������ ����� ��������� ������� � ������ ���������� �������, � �������:
select * from openquery(excel,'select * from [sheet1$]') � ��������� ���� ������ �� ������
select * from openquery(excel,'select * from [Sheet1$A10:D2]') � ��������� ������ ��������� $A10:D2
select * from openquery(excel,'select * from [Sheet1$A10:D]') � ��������� ������ ��������� � A10:D �� ����� �����.

3) ��� ����, ������, ����� ��������� ������ ������, �� ����� ������������ �SQL Server Import and Export Wizard�:
�������� ��,  ������ ������, ������, �������� ����� ������ ��� �������:
�������� �������� ������, ��� ���� Excel, ������ Excel-�. :



�������� ���� ���������� ������, ��������� ������� ���������� .
����� ����� ����� ����� ��������� ���������� ��� ��� ��������� ��� ����������� �������������.
4) ������, 4 ������, ��� ��� ��� �������� ������ SSIS � Microsoft Visual Studio, ����������� �������� ��� �� ����� �����, ������� �� ��, ��� ���� ������� � �������� 3
�������� �� ������
���������� ������� ������ ����������


����� ���������� �������� � ������ ����������:


� ��������� ���������� ��������� ����� ���������� � ����� ������ Excel, �  ���������� ��������� ��� MS SQL Server, ��������� �������, ������������ �������:


����� ����� ��������� �����, � ��� ���������.
����� �������  � ������ ��������.
����� .