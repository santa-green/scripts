--https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/orders.xml
--https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/orders/count.xml

DECLARE @https VARCHAR(8)
	   ,@login VARCHAR(40)
	   ,@pass VARCHAR(40)
	   ,@vintage VARCHAR(256)
	   ,@comand VARCHAR(256)
	   ,@result VARCHAR(MAX)
	   ,@comand_type INT = 1
	   ,@id BIGINT = 2139291156593
	   --952422203505 order
	   --2139291156593 product

SELECT @https = 'https://'
	  ,@login = '4a31bd883165bfd2bb8932c6287e7b9c:'
	  ,@pass = '6bab3199775c589f2922cd5bdb48a10b'
	  ,@vintage = '@vintagemarket-dev.myshopify.com/admin'

--1 all odrers
IF @comand_type = 1
BEGIN
SELECT @comand = '/orders.xml'
END;

--2 count of orders
IF @comand_type = 2
BEGIN
SELECT @comand = '/orders/count.xml'
END;

--3 special order
IF @comand_type = 3
BEGIN
SELECT @comand = '/orders/' + CONVERT(VARCHAR(20), @id) + '.xml'
END;

--4 get all products
IF @comand_type = 4
BEGIN
SELECT @comand = '/products.xml'
END;

--5 count of products
IF @comand_type = 5
BEGIN
SELECT @comand = '/products/count.xml'
END;

--6 special order
IF @comand_type = 6
BEGIN
SELECT @comand = '/products/' + CONVERT(VARCHAR(20), @id) + '.xml'
END;

--7 get new orders
IF @comand_type=7
BEGIN
SELECT @comand = '/orders.xml?created_at_min=' + CONVERT(VARCHAR,GETDATE(),126)
END;

SELECT @result = @https + @login + @pass + @vintage + @comand

SELECT @result URL

/*





2019-02-07 15:32:36.500
952422203505
*/