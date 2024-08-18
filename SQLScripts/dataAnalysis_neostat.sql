-- Results for case study


-- Total Sales by OrderID --Insights: which customer placed highest order value for how much qty and customer from what location
-- Best performing location and customer by highest order value and quantity -- Top and most valuable customer

select orderID, CustomerName, [Location],sum(Quantity) TotalQuantity, sum(TotalSales) TotalSalesbyorderID 
from [dbo].[Final_Sales_Data] 
group by orderID, CustomerName, [Location]  order by TotalSalesbyorderID desc; 

-- Best performing location and customer by highest quantity -- Top and most valuable customer
select orderID, CustomerName, [Location],sum(Quantity) TotalQuantity, sum(TotalSales) TotalSalesbyorderID 
from [dbo].[Final_Sales_Data] 
group by orderID, CustomerName, [Location]  order by TotalQuantity desc;


-- Total Sales by Product
-- best performing product by quantity of items sold and by totalsales
select Product,sum(Quantity) TotalQuantity, sum(TotalSales) TotalSalesbyProduct
from [dbo].[Final_Sales_Data] 
group by Product order by TotalSalesbyProduct desc; 

-- Average Order Value by OrderID -- Average Order value by Product
select OrderID, CustomerName, round((TotalSalesSum/orderOccurance), 2, 0) AvgOrderValuebyOrderID  from  (
    select orderID, CustomerName, Count(*) orderOccurance, 
    sum(TotalSales) TotalSalesSum 
    from [dbo].[Final_Sales_Data] 
    group by orderID, CustomerName 
) orderfreq order by AvgOrderValuebyOrderID desc

-- Top performing product by total sales and average order value
select Product, round((TotalSalesSum/orderOccurance), 2, 0) AvgOrderValuebyProduct from  (
    select Product, Count(*) orderOccurance, 
    sum(TotalSales) TotalSalesSum 
    from [dbo].[Final_Sales_Data] 
    group by Product 
) orderfreq order by AvgOrderValuebyProduct desc


-- Top performing product in each year by highest totalsalesamount

select * from (
select product, YEAR([Date]) [Year], SUM(TotalSales) [SumofTotalSalesAmtByProd],
ROW_NUMBER() OVER(PARTITION BY YEAR([Date]) ORDER BY SUM(TotalSales) DESC ) rn
from [dbo].[Final_Sales_Data]
GROUP BY product,YEAR([Date])
) A where rn =1

-- top performing product by quantity in each year
select * from (
select product, YEAR([Date]) [Year], SUM(Quantity) [SumofTotalQuantitybyProduct],
ROW_NUMBER() OVER(PARTITION BY YEAR([Date]) ORDER BY SUM(Quantity) DESC ) rn
from [dbo].[Final_Sales_Data]
GROUP BY product,YEAR([Date])
) A where rn =1


-- most valuable customer by total sales in each year
select * from (
select OrderID, CustomerName, YEAR([Date]) [Year], sum(TotalSales) TotalSalesSum,
ROW_NUMBER() OVER(PARTITION BY YEAR([Date]) ORDER BY sum(TotalSales) DESC ) rn
from [dbo].[Final_Sales_Data]
GROUP BY OrderID, CustomerName, YEAR([Date])
) A where rn =1

