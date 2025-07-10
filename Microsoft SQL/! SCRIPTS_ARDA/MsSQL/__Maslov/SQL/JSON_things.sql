DECLARE @MyHierarchy Hierarchy  
INSERT INTO @myHierarchy 
--select * from af_JSON_Parse('{"update_id":960343849, "message":{"message_id":11314,"from":{"id":989837495,"is_bot":false,"first_name":"\u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440","last_name":"\u041f\u0440\u043e\u0433\u0440\u0430\u043c\u043c\u0438\u0441\u0442","username":"Vprog_1","language_code":"ru"},"chat":{"id":989837495,"first_name":"\u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440","last_name":"\u041f\u0440\u043e\u0433\u0440\u0430\u043c\u043c\u0438\u0441\u0442","username":"Vprog_1","type":"private"},"date":1567776146,"text":"1"}}')
select * from af_JSON_Parse((SELECT JSON_Text FROM at_JSON_from_Telegram WHERE ChID = 6 ))
SELECT dbo.af_JSON_convert_to_JSON_string(@MyHierarchy)
SELECT * FROM @MyHierarchy

/*
First version

DECLARE @MyHierarchy Hierarchy  
INSERT INTO @myHierarchy 
select * from parseJSON('{"update_id":960343849, "message":{"message_id":11314,"from":{"id":989837495,"is_bot":false,"first_name":"\u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440","last_name":"\u041f\u0440\u043e\u0433\u0440\u0430\u043c\u043c\u0438\u0441\u0442","username":"Vprog_1","language_code":"ru"},"chat":{"id":989837495,"first_name":"\u0412\u043b\u0430\u0434\u0438\u043c\u0438\u0440","last_name":"\u041f\u0440\u043e\u0433\u0440\u0430\u043c\u043c\u0438\u0441\u0442","username":"Vprog_1","type":"private"},"date":1567776146,"text":"1"}}')
SELECT dbo.ToJSON(@MyHierarchy)
SELECT * FROM @MyHierarchy
*/

/* 
DROP TYPE dbo.Hierarchy
go
CREATE TYPE dbo.Hierarchy AS TABLE
(
   element_id INT NOT NULL, /* internal surrogate primary key gives the order of parsing and the list order */
   sequenceNo [int] NULL, /* the place in the sequence for the element */
	   parent_ID INT,/* if the element has a parent then it is in this column. The document is the ultimate parent, so you can get the structure from recursing from the document */
   [Object_ID] INT,/* each list or object has an object id. This ties all elements to a parent. Lists are treated as objects here */
   NAME NVARCHAR(2000),/* the name of the object, null if it hasn't got one */
   StringValue NVARCHAR(MAX) NOT NULL,/*the string representation of the value of the element. */
   ValueType VARCHAR(10) NOT null /* the declared type of the value represented as a string in StringValue*/
    PRIMARY KEY (element_id)
)
*/