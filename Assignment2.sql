/* Minhwan Kim, Assignment 2

1.	What is a result set?
Result set is the outcome of joining multiple tables/views into one single result.

2.	What is the difference between Union and Union All?
Union can not be used with recursive CTE, but union all can be used with recursive CTE.
Union will give the unique records but union all gives duplicate too.
Union will sort the result set based on the first column of the first select statement, but union all will not.
Union is slower than union all.

3.	What are the other Set Operators SQL Server has?
UNION, UNION ALL, INTERSECT, EXCEPT

4.	What is the difference between Union and Join?
Union combines rows, join combines columns. 
Join needs condition (common data between tables), union doesn't.

5.	What is the difference between INNER JOIN and FULL JOIN?
Inner join brings records from the left and right table which meet the join condition, whereas full join brings 
all records from both tables, regardless of whether join condition is met or not.

6.	What is difference between left join and outer join
Left join is a type of outer join that includes all the rows from the left table specified in the LEFT OUTER clause, 
not just the ones in which the joined columns match.

7.	What is cross join?
Cross join is a type of join that returns the Cartesian product of the sets of records from the two joined tables.

8.	What is the difference between WHERE clause and HAVING clause?
Where does the filtering before grouping is done, whereas having filters the results from the group.

9.	Can there be multiple group by columns?
Yes, group by can contain more than one column.
*/

----- Query Questions -----

----- 1 -----
select count(name) from Production.product
-- 504 products

----- 2 -----
select count(name) from Production.product where ProductSubcategoryID is not Null

----- 3 -----
select ProductSubcategoryID, count(productsubcategoryid) CountedProducts from Production.product where ProductSubcategoryID is not Null group by productsubcategoryid

----- 4 -----
select count(name) from Production.product where ProductSubcategoryID is Null
-- 209 products

----- 5 -----
select productID, sum(quantity) TheSum from Production.ProductInventory group by productid

----- 6 -----
select productID, sum(quantity) TheSum 
from Production.ProductInventory
where LocationID = 40
group by productid
having sum(quantity) < 100

----- 7 -----
select shelf, productID, sum(quantity) TheSum 
from Production.ProductInventory
where LocationID = 40
group by productid, shelf
having sum(quantity) < 100

----- 8 -----
select productID, avg(quantity) TheAvg
from Production.ProductInventory
where LocationID = 10
group by productid

----- 9 -----
select productID, shelf, avg(quantity) TheAvg
from Production.ProductInventory
group by shelf, productid

----- 10 -----
select productID, shelf, avg(quantity) TheAvg
from Production.ProductInventory
where shelf <> 'N/A'
group by shelf, productid

----- 11 -----
select color, class, count(color) TheCount, avg(listprice) TheAvg
from Production.Product
where color is not Null and class is not null
group by color, class

----- 12 -----
select c.Name country, s.Name Province
from person.StateProvince s
inner join person.CountryRegion c
on s.CountryRegionCode = c.CountryRegionCode

----- 13 -----
select c.Name country, s.Name Province
from person.StateProvince s
inner join person.CountryRegion c
on s.CountryRegionCode = c.CountryRegionCode
where c.Name = 'Germany' or c.Name = 'Canada'

----- 14 -----
select distinct productname 
from dbo.products p
left join dbo.[Order Details] o
on p.productID = o.ProductID
full join dbo.orders r
on r.orderID = o.orderID
where DATEDIFF(year, r.OrderDate, 2021) < 25

----- 15 -----
select top 5 o.ShipPostalCode, sum(od.Quantity) qty 
FROM dbo.orders o
FULL JOIN dbo.[Order Details] od
ON o.orderid =  od.orderid
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
ORDER BY qty DESC;

----- 16 -----
select TOP 5 o.ShipPostalCode, SUM(od.Quantity) qty 
from dbo.orders o
full JOIN dbo.[Order Details] od
on o.OrderID =  od.OrderID
where o.ShipPostalCode IS NOT NULL AND 
DATEDIFF(year, o.OrderDate, 2021) < 20
group by ShipPostalCode
order by qty DESC;

----- 17 -----
select City, count(customerID) PeopleNum
from customers
group by City

----- 18 -----
select city, count(customerID)
from customers
group by City
having  count(customerID)>10

----- 19 -----
select distinct c.CustomerID, c.CompanyName, c.ContactName 
from dbo.Orders o
inner join dbo.Customers c
on o.CustomerID = c.CustomerID	
where OrderDate > '1998-1-1';

----- 20 -----
select c.CustomerID, c.CompanyName, c.ContactName 
from dbo.Orders o
inner join dbo.Customers c
on o.CustomerID = c.CustomerID
where o.OrderDate in 
(select top 1 OrderDate from Orders
where OrderDate is not null
group by OrderDate
order by OrderDate desc);

----- 21 -----
select c.CustomerID, c.CompanyName, c.ContactName, 
sum(od.Quantity) qty 
from dbo.Customers c 
LEFT JOIN dbo.Orders o 
on c.CustomerID = o.CustomerID
LEFT JOIN dbo.[Order Details] od
on o.OrderID = od.OrderID
group by c.CustomerID, c.CompanyName, c.ContactName
order by qty;

----- 22 -----
SELECT c.CustomerID,
SUM(od.Quantity) qty 
FROM dbo.Customers c 
LEFT JOIN dbo.Orders o 
ON c.CustomerID = o.CustomerID
LEFT JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100
ORDER BY qty;

----- 23 -----
SELECT DISTINCT sup.CompanyName, ship.CompanyName 
FROM dbo.Orders o
LEFT JOIN dbo.[Order Details] od
ON o.OrderID = od.OrderID
INNER JOIN Products p
ON od.ProductID = p.ProductID
RIGHT JOIN
Suppliers sup
ON p.SupplierID = sup.SupplierID
INNER JOIN
Shippers ship
ON o.ShipVia = ship.ShipperID;

----- 24 -----
SELECT o.OrderDate, p.ProductName FROM 
Orders o
LEFT JOIN
[Order Details] od
ON o.OrderID = od.OrderID
INNER JOIN
Products p
ON od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName
ORDER BY o.OrderDate;

----- 25 -----
SELECT Title, LastName + ' ' + FirstName AS Name 
FROM Employees
ORDER BY Title;

----- 26 -----
SELECT * FROM (SELECT * FROM Employees) AS T1
INNER JOIN
(SELECT ReportsTo, COUNT(ReportsTo) AS Subordinate  FROM Employees
WHERE ReportsTo IS NOT NULL
GROUP BY ReportsTo
HAVING COUNT(ReportsTo) > 2) T2
ON T2.ReportsTo= T1.EmployeeID;
Question: How to keep most columns but drop only a few of them?


----- 27 -----
SELECT c.City, c.CompanyName, c.ContactName, 'Customer' as Type
FROM Customers c
UNION
SELECT s.City, s.CompanyName, s.ContactName, 'Supplier' as Type
FROM Suppliers s;
