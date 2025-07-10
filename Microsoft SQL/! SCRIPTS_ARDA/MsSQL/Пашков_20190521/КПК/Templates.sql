
-- Таблица опций базы:

select *
from D_Options;

Аttr:128 (Сегмент) default
Аttr:561 (Арда/АкваВит) default

exec DMT_Set_Option 128,'все',null,null,305664  -- установка Сегмента по умолчанию
exec DMT_Set_Option 9,'Алеф Элит',null,null,null -- новая строка заголовка в приложении
exec DMT_Set_Option 19,0,null,null,0  -- режим продажи с колес отключен
exec DMT_Set_Option 20,3,null,null,3  -- трех уровневая организация товара: категория -- группа -- товар
exec DMT_Set_Option 832,1,null,null,1 -- отображать справочник типы документов в приложении
exec DMT_Set_Option 745,1,null,null,1 -- привязка единиц измерения непосредственно к товару
exec DMT_Set_Option 112,0,null,null,0 -- остатки по складам целочисленные
exec DMT_Set_Option 82,2,null,null,2 -- торговому разрешить привязывать нескольео складов
exec DMT_Set_Option 761,1,null,null,1 -- торговому разграничивать доступ ко всему товару

exec dbo.DMT_Set_Attribute @ExAttrId='600', @AttrID=600, @AttrTypeID=1, @AttrName='Ассортимент', @AttrSystemFlag=2080, @ActiveFlag=1, @Sort=null, @OtherFields=null -- создание атрибута "Ассортимент"
exec dbo.DMT_Set_AttributeValueEx @AttrID=600, @ExAttrId='600', @AttrValueID=null, @AttrValueName='Арда Трейдинг', @ExAttrValueId='1', @AttrValueSystemFlag=1002, @ActiveFlag=1, @OtherFields=null
exec dbo.DMT_Set_AttributeValueEx @AttrID=600, @ExAttrId='600', @AttrValueID=null, @AttrValueName='Аква Вит', @ExAttrValueId='3', @AttrValueSystemFlag=1002, @ActiveFlag=1, @OtherFields=null 


exec dbo.DMT_Set_ClientEx @exid='61077', @exidRep='4367', @activeFlag=1, @name='Нестеренко Г.А. ЧП', @ShortName='Нестеренко Г.А.', @Address='вул. Широка, 1/7', @inn='', @ftype=10, @exidOwner='61077', @fcomment='', @OKPO='', @OKONH=''
exec dbo.DMT_Set_ClientEx @exid='0061077001', @exidRep='4367', @activeFlag=1, @name='Нестеренко Г.А. ЧП (павільйон 24 години)/пр. Леніна, 54в', @ShortName='Нестеренко Г.А./пр. Леніна, 54в', @Address='м. Дніпродзержинськ, пр. Леніна, 54в', @inn='', @ftype=1, @exidOwner='61077', @fcomment='', @OKPO='', @OKONH=''


exec DMT_Set_Option 302,'225;',null,null,null -- новая строка заголовка в приложении
exec DMT_Set_Option 1029,'{Item.Name}\n{Is:Prices}{Цена: {OrItem.Cost} Грн. Итого: {Or.Sum} Грн.\n}',null,null,null

exec dbo.DMT_Set_FirmEx @exid='1', @activeFlag=1, @Name='Арда Трейдинг', @ShortName='Арда Трейдинг', @Address='52500, м.Синельникове, вул.Миру, б.29, кв.28', @Prefix='arda', @UrAddress='52500, м.Синельникове, вул.Миру, б.29, кв.28', @inn='370295404124'
exec dbo.DMT_Set_FirmEx @exid='3', @activeFlag=1, @Name='Аква Вит', @ShortName='Аква Вит', @Address='49083, м.Дніпропетровськ, вул.Собiнова, б.1', @Prefix='aqua', @UrAddress='49083, м.Дніпропетровськ, вул.Собiнова, б.1', @inn='368410304616'

-- создание разовых маршрутов 
exec DMT_Set_ClientRouteEx @RepIDD='140', @ClientIDD='0002570001A', @PlaneDate='20120606', @Ord=null, @Period=null, @ActiveFlag=2

-- создание циклических маршрутов 
exec DMT_Set_ClientService @ServiceExId='0040607001A-20120716', @FidExId='0040607001A', @StartDate='20120716', @EndDate='20500101', @Period=7, @ReqTimeBegin='09:00:00', @ReqTimeEnd=null, @Options=null, @ActiveFlag=1
exec DMT_Set_ServiceMatrix @MasterFidExId='547', @ServiceExId='0040607001A-20120716', @StartDate='20120716', @EndDate='20500101', @ReqTimeBegin='09:00:00', @ReqTimeEnd=null, @ActiveFlag=1
-- удаление циклических маршрутов 
Exec DSFS_Set_ServiceMatrix @SMID=1990349, @MasterFid=1003206, @ServiceId=1014239, @Startdate=null, @EndDate=null, @ReqTimeBegin=null, @ReqTimeEnd=null, @ActiveFlag=0, @OwnerDistId=1
exec DMT_Set_ClientService @ServiceExId='0040607001A-20120716', @FidExId='0040607001A', @StartDate=null, @EndDate=null, @Period=null, @ReqTimeBegin=null, @ReqTimeEnd=null, @Options=null, @ActiveFlag=0

---------------------------------------------------------

-- Таблица единиц измерений;

select *
from dbo.DS_UnitTypes;

exec DMT_Set_UnitEx null,'11','бутылка','бут.','бутылка',1
exec DMT_Set_UnitEx null,'21','пачка','пач.','пачка',1
exec DMT_Set_UnitEx null,'31','стик','стик','стик',1
exec DMT_Set_UnitEx null,'41','штука','шт.','штука',1
exec DMT_Set_UnitEx null,'51','набор','наб.','набор',1
exec DMT_Set_UnitEx null,'12','ящик','ящ.','ящик',1
exec DMT_Set_UnitEx null,'22','упаковка','уп.','упаковка',1

----------------------------------------------------------

-- Таблица категорий товара;

select *
from dbo.DS_ITYPES

exec DMT_Set_ItemTypes '11','Арманьяк',1
exec DMT_Set_ItemTypes '3','Вермут',1
exec DMT_Set_ItemTypes '1','Вино',1
exec DMT_Set_ItemTypes '19','Вино игрист.',1
exec DMT_Set_ItemTypes '18','Вино шамп.',1
exec DMT_Set_ItemTypes '4','Виски',1
exec DMT_Set_ItemTypes '21','Вода',1
exec DMT_Set_ItemTypes '2','Водка',1
exec DMT_Set_ItemTypes '12','Граппа',1
exec DMT_Set_ItemTypes '6','Джин',1
exec DMT_Set_ItemTypes '10','Кальвадос',1
exec DMT_Set_ItemTypes '9','Кашаца',1
exec DMT_Set_ItemTypes '8','Коньяк',1
exec DMT_Set_ItemTypes '5','Ликер',1
exec DMT_Set_ItemTypes '20','Масло оливк.',1
exec DMT_Set_ItemTypes '16','Ром',1
exec DMT_Set_ItemTypes '22','Сироп',1
exec DMT_Set_ItemTypes '15','Текила',1
exec DMT_Set_ItemTypes '23','Чай',1
exec DMT_Set_ItemTypes '29','Кофе',1
exec DMT_Set_ItemTypes '97','Макаронные изделия',1
exec DMT_Set_ItemTypes '501','Сахар',1

----------------------------------------------------------

-- Таблица групп товара;

select *
from  DS_IGroups 

exec DMT_Set_ItemGroups '1101','Лобад',1
exec DMT_Set_ItemGroups '305','Марио',1
exec DMT_Set_ItemGroups '302','Мартини',1
exec DMT_Set_ItemGroups '300','Трино',1
exec DMT_Set_ItemGroups '172','Итальянский клуб',1
exec DMT_Set_ItemGroups '192','Агмарти',1
exec DMT_Set_ItemGroups '112','Алиас',1
exec DMT_Set_ItemGroups '133','Баланд И Менере',1
exec DMT_Set_ItemGroups '161','Барон Риказоли',1
exec DMT_Set_ItemGroups '27','Бергальйо Никола',1
exec DMT_Set_ItemGroups '132','Бодегас Чивите',1
exec DMT_Set_ItemGroups '101','Бори Моню',1
exec DMT_Set_ItemGroups '103','Бушар Пер & Фиc',1
exec DMT_Set_ItemGroups '169','Бруно Рокка',1
exec DMT_Set_ItemGroups '141','Кодорниу',1
exec DMT_Set_ItemGroups '105','Кольмар',1
exec DMT_Set_ItemGroups '165','Ка Дель Боско',1
exec DMT_Set_ItemGroups '94','Кантина Галура',1
exec DMT_Set_ItemGroups '178','Кастелло Ди Волпайа',1
exec DMT_Set_ItemGroups '114','Шато Болонь',1
exec DMT_Set_ItemGroups '153','Кристиан Коэли',1
exec DMT_Set_ItemGroups '179','Контерно',1
exec DMT_Set_ItemGroups '191','Макул',1
exec DMT_Set_ItemGroups '147','Кузумано',1
exec DMT_Set_ItemGroups '106','Дом Веинбах',1
exec DMT_Set_ItemGroups '104','Дом Вильям Февре Шабли',1
exec DMT_Set_ItemGroups '187','Эльфенхоф',1
exec DMT_Set_ItemGroups '168','Гарофоли',1
exec DMT_Set_ItemGroups '108','Ги Саже',1
exec DMT_Set_ItemGroups '26','Иституто Энологико Итальяно',1
exec DMT_Set_ItemGroups '124','Джинджин',1
exec DMT_Set_ItemGroups '152','Жан-Филипп Маршан',1
exec DMT_Set_ItemGroups '184','Ла Масса',1
exec DMT_Set_ItemGroups '166','Ла Сколка',1
exec DMT_Set_ItemGroups '122','Лэйк Чалис',1
exec DMT_Set_ItemGroups '195','Леонсио Аризу',1
exec DMT_Set_ItemGroups '125','Летрари',1
exec DMT_Set_ItemGroups '134','Лозано',1
exec DMT_Set_ItemGroups '149','Луис Фелип Эдвардс',1
exec DMT_Set_ItemGroups '190','Монтана',1
exec DMT_Set_ItemGroups '176','Марк Де Грациа',1
exec DMT_Set_ItemGroups '175','Марчези Ди Греси',1
exec DMT_Set_ItemGroups '142','Маркос де Касерес',1
exec DMT_Set_ItemGroups '131','Маркиз де Рискал',1
exec DMT_Set_ItemGroups '30','Мартин Керпен',1
exec DMT_Set_ItemGroups '99','Монт Грас',1
exec DMT_Set_ItemGroups '164','Паоло Скавино',1
exec DMT_Set_ItemGroups '127','Паскаль Бушар',1
exec DMT_Set_ItemGroups '98','Петалума',1
exec DMT_Set_ItemGroups '174','Подэри Боскарели',1
exec DMT_Set_ItemGroups '109','Помероль',1
exec DMT_Set_ItemGroups '160','Провенза',1
exec DMT_Set_ItemGroups '173','Куантарели',1
exec DMT_Set_ItemGroups '197','Речине',1
exec DMT_Set_ItemGroups '102','Роберт Жиро',1
exec DMT_Set_ItemGroups '171','Ронко Гелсо',1
exec DMT_Set_ItemGroups '25','Санта Каролина',1
exec DMT_Set_ItemGroups '93','Сэйнт Клэр',1
exec DMT_Set_ItemGroups '100','Сильвио Нарди',1
exec DMT_Set_ItemGroups '151','Стоунхедж',1
exec DMT_Set_ItemGroups '126','Свортланд Вайнери',1
exec DMT_Set_ItemGroups '170','Томмаси',1
exec DMT_Set_ItemGroups '123','Трэш',1
exec DMT_Set_ItemGroups '162','Тенута иль Пожионэ',1
exec DMT_Set_ItemGroups '130','Три Пайнз Трэйдинг',1
exec DMT_Set_ItemGroups '145','Торбрек',1
exec DMT_Set_ItemGroups '92','Вальдуэро',1
exec DMT_Set_ItemGroups '28','Висенте Гандиа',1
exec DMT_Set_ItemGroups '107','Видал Флери',1
exec DMT_Set_ItemGroups '150','Вилла Матильде',1
exec DMT_Set_ItemGroups '185','Вилла Виньямаджио',1
exec DMT_Set_ItemGroups '163','Зонин',1
exec DMT_Set_ItemGroups '430','Дюарс',1
exec DMT_Set_ItemGroups '407','Канадское виски',1
exec DMT_Set_ItemGroups '408','Тюлламор Дью',1
exec DMT_Set_ItemGroups '402','Шотландский ассорт.',1
exec DMT_Set_ItemGroups '429','Каттос',1
exec DMT_Set_ItemGroups '400','Ханки Баннистер',1
exec DMT_Set_ItemGroups '412','Джим Бим',1
exec DMT_Set_ItemGroups '428','МакАртурс',1
exec DMT_Set_ItemGroups '410','Сигнатори',1
exec DMT_Set_ItemGroups '2104','Бадуа',1
exec DMT_Set_ItemGroups '2100','Эвиан',1
exec DMT_Set_ItemGroups '203','Абсолют',1
exec DMT_Set_ItemGroups '201','Финляндия',1
exec DMT_Set_ItemGroups '205','Грей Гус',1
exec DMT_Set_ItemGroups '1200','Нонино',1
exec DMT_Set_ItemGroups '606','Бомбей',1
exec DMT_Set_ItemGroups '600','Финсбари',1
exec DMT_Set_ItemGroups '1901','Мартини',1
exec DMT_Set_ItemGroups '167','Кавикьоли',1
exec DMT_Set_ItemGroups '141','Кодорниу',1
exec DMT_Set_ItemGroups '19','Тосо Гран Десерт',1
exec DMT_Set_ItemGroups '1000','Пер Маглуар',1
exec DMT_Set_ItemGroups '900','Канарио',1
exec DMT_Set_ItemGroups '901','Питу',1
exec DMT_Set_ItemGroups '814','Отард',1
exec DMT_Set_ItemGroups '820','Шато де Луи',1
exec DMT_Set_ItemGroups '800','Шато Монтифо',1
exec DMT_Set_ItemGroups '811','До',1
exec DMT_Set_ItemGroups '803','Курвуазье',1
exec DMT_Set_ItemGroups '810','Шато Болонь',1
exec DMT_Set_ItemGroups '505','Кэролайнс',1
exec DMT_Set_ItemGroups '500','Де Кайпер',1
exec DMT_Set_ItemGroups '518','Франжелико',1
exec DMT_Set_ItemGroups '502','Лимончелло',1
exec DMT_Set_ItemGroups '501','Самбука',1
exec DMT_Set_ItemGroups '519','Цвак Уникум',1
exec DMT_Set_ItemGroups '2002','Барон Риказоли',1
exec DMT_Set_ItemGroups '1600','Бакарди',1
exec DMT_Set_ItemGroups '2201','Рутен',1
exec DMT_Set_ItemGroups '1512','Камино Реаль',1
exec DMT_Set_ItemGroups '1501','Сауза',1
exec DMT_Set_ItemGroups '1506','Сиерра',1
exec DMT_Set_ItemGroups '2902','Бруно',1
exec DMT_Set_ItemGroups '2905','Интеро',1
exec DMT_Set_ItemGroups '2901','Ривер',1
exec DMT_Set_ItemGroups '2301','Форте',1
exec DMT_Set_ItemGroups '2302','Герберт',1
exec DMT_Set_ItemGroups '1800','Анрио',1
exec DMT_Set_ItemGroups '9700','Такі Справи',1
exec DMT_Set_ItemGroups '3000','Сахар Бруно',1


select *
from  DS_IGroups 
exec DMT_Set_ItemGroups '553','Ликер Сиерра',1
-----------------------------------------------------------------

-- Таблица товаров;

select *
from dbo.DS_ITEMS


declare @Cat int
declare @Pid int
declare @ProdN nvarchar(100)
declare @ProdSN nvarchar(50)
declare @W money
declare @UM int
declare @Tax money
declare @Gr int

declare importProdsFromOT cursor
FOR select PCatID,prodid,left(ProdName,100) full_name,'*NEW* ' + left(ProdName,42) short_name,[Weight],isnull((select Qty from [s-sql-d4].elit.dbo.r_ProdMQ q where UM = 'ящ.' and q.ProdID = p.ProdID),1) um, TaxPercent, PGrID
from [s-sql-d4].elit.dbo.r_prods p
where PCatID in (
	select ItIdText
	from dbo.DS_ITYPES
	where isnumeric(ItIdText) = 1)
and PGrID in (
	select IgIdText
	from DS_IGroups
	where isnumeric(IgIdText) = 1)
and not exists(select * from dbo.DS_ITEMS where itID <> 21 and iidText = p.prodid)
and exists(select SUM(Qty) from [s-sql-d4].elit.dbo.t_Rem r where r.prodid = p.prodid and OurID in (1,3) and stockid in (select cast(left(exid,3) as tinyint) from dbo.DS_FACES where fType = 6) having SUM(Qty) > 0)
and exists(select * from [s-sql-d4].elit.dbo.r_ProdMP mp where plid in (24,25,26) and mp.prodid = p.prodid and pricemc > 0)

OPEN importProdsFromOT
FETCH NEXT FROM importProdsFromOT INTO @Cat, @Pid, @ProdN, @ProdSN, @W, @UM, @Tax, @Gr

WHILE @@fetch_status=0
BEGIN

exec DMT_Set_ItemsEx @exidType=@Cat, @exid=@Pid, @iName=@ProdN, @iShortname=@ProdSN, @activeFlag=0, @weight=@W, @unit3=@UM, @VAT=@Tax, @sort=0, @exidGroup=@Gr;

FETCH NEXT FROM importProdsFromOT INTO @Cat, @Pid, @ProdN, @ProdSN, @W, @UM, @Tax, @Gr
END

CLOSE importProdsFromOT
DEALLOCATE importProdsFromOT


--------------------------------------------------------------------

-- Таблица складов;

select *
from dbo.DS_FACES
where fType = 6

exec DMT_Set_StoreEx @ExId='135', @ActiveFlag=1, @Name='Склад Луганск 135', @ShortName='Луганск 135';
exec DMT_Set_StoreEx @ExId='123', @ActiveFlag=1, @Name='Склад Одесса 123', @ShortName='Одесса 123';
exec DMT_Set_StoreEx @ExId='124', @ActiveFlag=1, @Name='Склад Запорожье 124', @ShortName='Запорожье 124';
exec DMT_Set_StoreEx @ExId='134', @ActiveFlag=1, @Name='Склад Киев 134', @ShortName='Киев 134';
exec DMT_Set_StoreEx @ExId='136', @ActiveFlag=1, @Name='Склад Винница 136', @ShortName='Винница 136';
exec DMT_Set_StoreEx @ExId='138', @ActiveFlag=1, @Name='Склад Николаев 138', @ShortName='Николаев 138';
exec DMT_Set_StoreEx @ExId='181', @ActiveFlag=1, @Name='Склад Луцк 181', @ShortName='Луцк 181';
exec DMT_Set_StoreEx @ExId='184', @ActiveFlag=1, @Name='Склад Ив.Франк. 184', @ShortName='Ив.-Франк. 184';
exec DMT_Set_StoreEx @ExId='185', @ActiveFlag=1, @Name='Склад Черкассы 185', @ShortName='Черкассы 185';
exec DMT_Set_StoreEx @ExId='197', @ActiveFlag=1, @Name='Склад Полтава 197', @ShortName='Полтава 197';
exec DMT_Set_StoreEx @ExId='4', @ActiveFlag=1, @Name='Склад Днепр 004', @ShortName='Днепр 004';
exec DMT_Set_StoreEx @ExId='28', @ActiveFlag=1, @Name='Склад Симф. 028', @ShortName='Симф. 028';
exec DMT_Set_StoreEx @ExId='27', @ActiveFlag=1, @Name='Склад Львов 027', @ShortName='Львов 027';
exec DMT_Set_StoreEx @ExId='30', @ActiveFlag=1, @Name='Склад Киев 030', @ShortName='Киев 030';
exec DMT_Set_StoreEx @ExId='24', @ActiveFlag=1, @Name='Склад Запорожье 024', @ShortName='Запорожье 024';
exec DMT_Set_StoreEx @ExId='11', @ActiveFlag=1, @Name='Склад Харьков 011', @ShortName='Харьков 011';
exec DMT_Set_StoreEx @ExId='23', @ActiveFlag=1, @Name='Склад Одесса 023', @ShortName='Одесса 023';
exec DMT_Set_StoreEx @ExId='29', @ActiveFlag=1, @Name='Склад Донецк 029', @ShortName='Донецк 029';
exec DMT_Set_StoreEx @ExId='35', @ActiveFlag=1, @Name='Склад Луганск 035', @ShortName='Луганск 035';
exec DMT_Set_StoreEx @ExId='38', @ActiveFlag=1, @Name='Склад Николаев 038', @ShortName='Николаев 038';
exec DMT_Set_StoreEx @ExId='81', @ActiveFlag=1, @Name='Склад Луцк 081', @ShortName='Луцк 081';
exec DMT_Set_StoreEx @ExId='84', @ActiveFlag=1, @Name='Склад Ив.-Франк. 084', @ShortName='Ив.-Франк. 084';
exec DMT_Set_StoreEx @ExId='85', @ActiveFlag=1, @Name='Склад Черкассы 085', @ShortName='Черкассы 085';
exec DMT_Set_StoreEx @ExId='36', @ActiveFlag=1, @Name='Склад Винница 036', @ShortName='Винница 036';
exec DMT_Set_StoreEx @ExId='53', @ActiveFlag=1, @Name='Склад Киев 053', @ShortName='Киев 053';
exec DMT_Set_StoreEx @ExId='130', @ActiveFlag=1, @Name='Склад Киев 130', @ShortName='Киев 130';
exec DMT_Set_StoreEx @ExId='111', @ActiveFlag=1, @Name='Склад Харьков 111', @ShortName='Харьков 111';
exec DMT_Set_StoreEx @ExId='129', @ActiveFlag=1, @Name='Склад Донецк 129', @ShortName='Донецк 129';
exec DMT_Set_StoreEx @ExId='104', @ActiveFlag=1, @Name='Склад Днепр 104', @ShortName='Днепр 104';
exec DMT_Set_StoreEx @ExId='204', @ActiveFlag=1, @Name='Склад Днепр 204', @ShortName='Днепр 204';
exec DMT_Set_StoreEx @ExId='127', @ActiveFlag=1, @Name='Склад Львов 127', @ShortName='Львов 127';
exec DMT_Set_StoreEx @ExId='97', @ActiveFlag=1, @Name='Склад Полтава 097', @ShortName='Полтава 097';
exec DMT_Set_StoreEx @ExId='128', @ActiveFlag=1, @Name='Склад Симф. 128', @ShortName='Симф. 128';
exec DMT_Set_StoreEx @ExId='20', @ActiveFlag=1, @Name='Склад Центр. 020', @ShortName='Центр. 020';

----------------------------------------------------------------------------------------

-- Таблица остатков по складам;

select *
from dbo.DS_Amounts


declare @exid_a nvarchar(50)
declare @prd_a nvarchar(50) 
declare @rem_a decimal(19,9)
declare rem_import cursor
for select exid, prd, isnull(Qty,0) AS rem
from
	(select exid, cast(left(exid,3) as tinyint) stck, cast(right(exid,1) as tinyint) firm, cast(iidText as int) prd
	from dbo.DS_Faces, dbo.DS_ITEMS
	where factiveflag = 1
	and ftype = 6
	and activeFlag = 1) as T1
left join 
	(SELECT StockID, OurID, ProdID, cast(SUM(Qty-AccQty)as int) Qty
	FROM [s-sql-d4].Elit.dbo.t_Rem
	WHERE OurID IN (1,3)
	AND StockID IN (select cast(left(exid,3) as int) from dbo.DS_Faces where factiveflag = 1 and ftype = 6)
	AND ProdID IN (select cast(iidText as int) from dbo.DS_ITEMS where activeFlag = 1)
	GROUP BY OurID, StockID, ProdID) as T2
on prd = ProdID AND firm = OurID AND stck = StockID

open rem_import 
fetch next from rem_import into @exid_a, @prd_a, @rem_a

while @@fetch_status = 0
begin

exec DMT_Set_StockEx  @ItemIdd = @prd_a, @amount = @rem_a, @StoreIDD = @exid_a

fetch next from rem_import into @exid_a, @prd_a, @rem_a
end

close rem_import
deallocate rem_import


----------------------------------------------------------------------------------------

exec DMT_Set_AgentEx '2430',1,'Базалевский Валерий','Базалевский Валерий','2430','004_1','2430';
exec DMT_Set_AgentEx '2482',1,'Бернадский Владимир','Бернадский Владимир','2482','004_1','2482';
exec DMT_Set_AgentEx '4381',1,'Савченко Николай','Савченко Николай','4381','004_1','4381';
exec DMT_Set_AgentEx '4378',1,'Сизов Иван','Сизов Иван','4378','004_1','4378';
exec DMT_Set_AgentEx '4377',1,'Шрам Дмитрий','Шрам Дмитрий','4377','004_1','4377';
exec DMT_Set_AgentEx '4367',1,'Шутько Даниил','Шутько Даниил','4367','004_1','4367';
exec DMT_Set_AgentEx '1405',1,'Мищенко Иван','Мищенко Иван','1405','004_1','1405';
exec DMT_Set_AgentEx '4339',1,'Скрыпник Александр','Скрыпник Александр','4339','004_1','4339';
exec DMT_Set_AgentEx '18',1,'Шулика Сергей','Шулика Сергей','18','004_1','18';
exec DMT_Set_AgentEx '4358',1,'Грицюк Александр','Грицюк Александр','4358','004_3','4358';
exec DMT_Set_AgentEx '41',1,'Полехина Ирина','Полехина Ирина','41','004_3','41';
exec DMT_Set_AgentEx '3492',1,'Резниченко Александр','Резниченко Александр','3492','004_3','3492';
exec DMT_Set_AgentEx '3475',1,'Шаблыко Андрей','Шаблыко Андрей','3475','004_3','3475';

-------------------------------------------------------------------------

exec DMT_Set_PriceLists '018','Метро',1;
exec DMT_Set_PriceLists '019','BK',1;
exec DMT_Set_PriceLists '023','Окей',1;
exec DMT_Set_PriceLists '024','Базовый',1;
exec DMT_Set_PriceLists '025','Базовый5',1;
exec DMT_Set_PriceLists '026','Базовый10',1;
exec DMT_Set_PriceLists '029','АТБ',1;
exec DMT_Set_PriceLists '032','Таврия',1;
exec DMT_Set_PriceLists '033','КБ(ХоРеКа)',1;
exec DMT_Set_PriceLists '034','КБМин',1;
exec DMT_Set_PriceLists '036','Реал',1;
exec DMT_Set_PriceLists '037','Базовый5(ХоРеКа)',1;
exec DMT_Set_PriceLists '038','Базовый10(ХоРеКа)',1;
exec DMT_Set_PriceLists '041','Кофе30',1;
exec DMT_Set_PriceLists '042','Кофе50',1;
exec DMT_Set_PriceLists '043','Вино15',1;
exec DMT_Set_PriceLists '044','Вино20',1;
exec DMT_Set_PriceLists '047','Сушия',1;
exec DMT_Set_PriceLists '048','Амстор',1;
exec DMT_Set_PriceLists '049','Сильпо',1;
exec DMT_Set_PriceLists '050','Варус',1;
exec DMT_Set_PriceLists '055','Апельсин',1;
exec DMT_Set_PriceLists '056','Базовый15',1;
exec DMT_Set_PriceLists '057','Базовый5(МакАртус)',1;
exec DMT_Set_PriceLists '058','Базовый10(МакАртус)',1;
exec DMT_Set_PriceLists '060','Спар',1;
exec DMT_Set_PriceLists '067','Базовый5_ХБ',1;
exec DMT_Set_PriceLists '068','Базовый5(МакАртус+ХБ)',1;
exec DMT_Set_PriceLists '080','Караван',1;
exec DMT_Set_PriceLists '082','Фуршет2',1;
exec DMT_Set_PriceLists '083','Ашан',1;
exec DMT_Set_PriceLists '086','Фуршет',1;
exec DMT_Set_PriceLists '089','МК',1;
exec DMT_Set_PriceLists '037041','Базовый5(ХоРеКа)_Кофе30',1;
exec DMT_Set_PriceLists '037042','Базовый5(ХоРеКа)_Кофе50',1;
exec DMT_Set_PriceLists '038041','Базовый10(ХоРеКа)_Кофе30',1;
exec DMT_Set_PriceLists '038042','Базовый10(ХоРеКа)_Кофе50',1;
exec DMT_Set_PriceLists '025041','Базовый5_Кофе30',1;
exec DMT_Set_PriceLists '025042','Базовый5_Кофе50',1;
exec DMT_Set_PriceLists '026041','Базовый10_Кофе30',1;
exec DMT_Set_PriceLists '026042','Базовый10_Кофе50',1;
exec DMT_Set_PriceLists '037044','Базовый5(ХоРеКа)_Вино20',1;
exec DMT_Set_PriceLists '038043','Базовый10(ХоРеКа)_Вино15',1;
exec DMT_Set_PriceLists '038044','Базовый10(ХоРеКа)_Вино20',1;
exec DMT_Set_PriceLists '057042','Базовый5(МакАртус)_Кофе50',1;


-------------------------------------------------------------------------

-- Перепривязка прайсов у клиентов Оптимум 
select T.ExID, (select exid from dbo.DS_PRICELISTS where c.job3 = plName and activeFlag = 1) plName
into #TPL
from 
	(select cast(LEFT(exid,7) as int) shortExID, ExID 
	from dbo.DS_FACES
	where fActiveFlag = 1
	and ftype = 1) T
inner join [s-sql-d4].Elit.dbo.r_Comps c on compid = shortExID

declare @compadd nvarchar(20)
declare @PriceEx nvarchar(20)
declare curr cursor
for select exid, plName
from #TPL
where plName is not null

open curr
fetch next from curr into @compadd, @PriceEx

while @@FETCH_STATUS = 0
begin	
	
	exec DMT_Set_ClientPriceList @exidClient = @compadd, @exidPriceList = @PriceEx, @activeFlag = 2;
	
	fetch next from curr into @compadd, @PriceEx

end

close curr
deallocate curr

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- сети сбрасывающие заказы через exite
select ZEO_OT_KOD, (select (select CodeName2 from [s-sql-d4].Elit.dbo.r_Codes2 c2 where c2.codeid2 = c.codeid2) from [s-sql-d4].Elit.dbo.r_Comps c where compid = ZEO_OT_KOD), MIN(ZEO_ORDER_STATUS), MAX(ZEO_ORDER_STATUS), MIN(ZEO_OUR_KOD) Arda, MAX(ZEO_OUR_KOD) AV
from dbo.ALEF_EDI_ORDERS
where ZEO_ORDER_STATUS > 2
group by ZEO_OT_KOD
order by 2





select * from dbo.r_CompsAdd
where CompID=7018