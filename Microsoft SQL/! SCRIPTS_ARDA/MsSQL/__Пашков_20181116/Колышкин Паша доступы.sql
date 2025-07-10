select * from z_UserStocks WITH (NOLOCK) where UserID = 1689 -- Колышкин Паша

select OurID from z_UserOurs WITH (NOLOCK) where UserID = 1689

select * from r_Users WITH (NOLOCK) where UserID = 1689

/*удалить 

delete z_UserStockGs where UserID = 1689

delete z_UserOurs where UserID = 1689

delete r_Users  where UserID = 1689

*/

select * from r_Users where UseOpenAge = 0