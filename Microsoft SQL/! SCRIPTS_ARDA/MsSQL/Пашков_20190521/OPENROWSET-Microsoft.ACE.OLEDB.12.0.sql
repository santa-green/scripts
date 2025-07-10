/*включен параметр Ad Hoc Distributed Queries расширенной настройки
USE master;
GO
EXEC sp_configure 'show advanced option', '1';

exec sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
*/

USE base1;
SELECT * 
into #Vkod
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; IMEX=1; Database=C:\Tmp\test.xlsx' , 'select * from [Лист1$]');

select * from #Vkod

--delete r_ProdEC where ProdID in (select prodid from #Vkod)

--insert into r_ProdEC
--from #Vkod

SELECT * FROM OPENDATASOURCE('Microsoft.Jet.OLEDB.4.0','Data Source=C:\Tmp\test.xlsx;Extended Properties=EXCEL 14.0')...[Sheet1$] ;

SELECT * FROM OPENROWSET('MSDASQL','Driver={Microsoft Excel Driver (*.xls)}; DBQ=[C:\Tmp\test.xls]', 'SELECT * FROM [Sheet1$A8:D10000]')

Несколько примеров работы из MS SQL Server  с таблицами формата Excel(.xls,.xlsx):


1)С использованием функции OPENROWSET или с OPENDATASOURCE:
SELECT * FROM OPENROWSET('MSDASQL',
'Driver={Microsoft Excel Driver (*.xls)};
DBQ=[C:\gr_otchet.xls]', 'SELECT * FROM [Sheet1$A8:D10000]'
Пример для OPENDATASOURCE из BOL:
SELECT * FROM OPENDATASOURCE('Microsoft.Jet.OLEDB.4.0',
'Data Source=C:\DataFolder\Documents\TestExcel.xls;Extended Properties=EXCEL 5.0')...[Sheet1$] ;
Одна из распространенных  проблем, это отсутствие драйверов под х64 платформу, или установка х32 битных под х64 систему. Например, драйверов Microsoft.Jet.OleDB нет 64 битных,в этом случае  можно использовать другие драйвера, к примеру  Microsoft.ACE.OLEDB.12.0.

Не забудьте только про Примечание из  BOL:
Функция OPENROWSET  или  OPENDATASOURCE может быть использована для доступа к удаленным данным из источников данных OLE DB 
только в том случае, если для заданного поставщика параметр реестра DisallowAdhocAccess явно установлен в 0 и 
включен параметр Ad Hoc Distributed Queries расширенной настройки. Если эти параметры не установлены, поведение по умолчанию запрещает нерегламентированный доступ.
Если параметр Ad Hoc Distributed Queries выключен, то  об будет информационное сообщение. Включение параметра осуществляется через хранимую процедуру sp_configure.
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

2) Второй спосб через Linkedserver и ODBC драйвер.
1-ый способ хорошо, когда необходимо использовать разово, для частого и широко использования лучше использовать технологию связанного сервера(Linked Server)
Для этого необходимо установить на сервере MS SQL Server ODBC драйвер а для Excel, затем создать источник данных( Администрирование ->Источники данных)


Указывает имя источника данных ,версию Excel и сам файл.
Сохраняем источник.
После этого создаем связанный сервер LinkedServed (связанный сервер):




Указываем имя нашего  связанного сервера и имя созданного нами раннего ODBC источника.
Сохраняем.
Теперь можно выполнять запросы к нашему связанному серверу, к примеру:
select * from openquery(excel,'select * from [sheet1$]') – получение всех данныз из экселя
select * from openquery(excel,'select * from [Sheet1$A10:D2]') – получение данных диапозона $A10:D2
select * from openquery(excel,'select * from [Sheet1$A10:D]') – получение данных диапозона с A10:D до конца файла.

3) Еще одни, способ, когда необходим импорт разово, то можно использовать «SQL Server Import and Export Wizard»:
Выделяем БД,  правая кнопка, Задачи, Выбираем пункт Импорт или Экспорт:
Выбираем источник данных, наш файл Excel, версию Excel-я. :



Выбираем куда копировать данные, указываем таблицу назначение .
После этого можно пакет запустить немедленно или его сохранить для дальнейшего использования.
4) Кстати, 4 способ, это как раз создание пакета SSIS в Microsoft Visual Studio, результатом которого так же будет пакет, похожий на то, что было создано в варианте 3
Делается он просто
Выбирается Элемент потока управления


Затем выбирается источник и сервер назначения:


В источнике соединений создается новое соединение с нашим файлом Excel, в  Назначение указываем наш MS SQL Server, указываем таблицу, сопоставляем столбцы:


После этого сохраняем пакет, и его запускаем.
Пакет создали  и должен работать.
Удачи .