USE sample_sales;

-- Question 1: What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?
-- Question Breakdown For Better Understanding: Total revenue OVERALL for the assigned territory and the state and end dates that the data covers. 
SELECT MIN(ss.Transaction_Date) AS 'Start Date',
        MAX(ss.Transaction_Date) AS 'End Date',
        SUM(ss.Sale_Amount) AS 'Total Revenue'
FROM store_list stl
JOIN store_sales ss ON ss.Store_ID = stl.Store_ID
WHERE stl.State = 'New Jersey';
-- Start Date is 01/01/2022, the end date is 12/31/2025, and the total revenue is 5,175,405.87

-- Logic Behind My Answer: I was overcomplicating the entire query while writing it out and I was almost close to the answer, but just kept stepping back into a more complicated query. Finally, I managed to rethink the solution and I simplified the solution until I received an answer that I was much happier with. I went through cycling in and out the 'HAVING" and the 'WHERE' clause before settling for the 'WHERE' clause and then I took out the original 'Group By' and 'Order By' statements. 

-- Question 2: What is the month by month revenue breakdown for the sales territory?
SELECT MONTH(ss.Transaction_Date) AS 'Month',
        YEAR(ss.Transaction_Date) AS 'Year',
        SUM(ss.Sale_Amount) AS 'Total Revenue'
FROM store_list stl
JOIN store_sales ss ON ss.Store_ID = stl.Store_ID
WHERE stl.State = 'New Jersey'
GROUP BY YEAR(ss.Transaction_Date), MONTH(ss.Transaction_Date)
ORDER BY YEAR(ss.Transaction_Date), MONTH(ss.Transaction_Date);
-- Logic Behind My Answer: This query is originally something I created during the first question where I was overcomplicating things before finally simplifying query. As I was thinking of what type of query to create, I came up with the idea of using this query to obtain the data that was needed. Overcomplicating things from the previous question really came in handy for me. 

-- Question 3: Provide a comparison of total revenue for the specific sales territory and the region it belongs to
SELECT sm.Region AS 'Location',
        SUM(ss.Sale_Amount) AS 'Total Revenue'
FROM store_managers sm
JOIN store_locations sl ON sl.State = sm.State
JOIN store_sales ss ON ss.Store_ID = sl.StoreId
WHERE sm.Region = 'Northeast'
GROUP BY sm.Region
UNION
SELECT sm.State AS 'Location',
        SUM(ss.Sale_Amount) AS 'Total Revenue'
FROM store_managers sm
JOIN store_locations sl ON sl.State = sm.State
JOIN store_sales ss ON ss.Store_ID = sl.StoreId
WHERE sm.State = 'New Jersey'
GROUP BY sm.State
ORDER BY 1;

-- The total revenue for the territory, also known as the state of New Jersey, is $5,175,405.87
-- The total revenue for the region, which is the Northeast Region, is $24,237,526.98

-- Logic Behind My Query: This was a query I very mucb struggled with and had started on last night, but stopped in the middle of creating. I was struggling with how to join the specific tables, but then I went back joined them a little differently using State for the joins rather than the usual 'ID' column for it. However, I was able to re-work the query until I was able to obtain a result that I was happy with. As for the way in which this query is written, I figured it was easier to use the 'union' function rather than making two separate queries to run. 

-- Question 4: What is the number of transactions per month and average transaction size by product category for the sales territory?
-- Question Breakdown: I would need to write a query where I connect store_sales, products, and inventory_categories; inventory_categories can connect to products by Categoryid and products can connect to store_sales by ProdNum/Prod_Num.
SELECT COUNT(ss.id) AS 'Transactions Per Month',
		MONTH(ss.Transaction_Date) AS 'Month',
        YEAR(ss.Transaction_Date) AS 'Year',
        ROUND(AVG(ss.Sale_Amount),2) AS 'Avg. Transaction Size',
		ic.Category
FROM store_sales ss
JOIN products p ON p.ProdNum = ss.Prod_Num
JOIN inventory_categories ic ON ic.Categoryid = p.Categoryid
JOIN store_locations sl ON sl.StoreId = ss.Store_ID
WHERE sl.State = 'New Jersey'
GROUP by ic.Category, MONTH(ss.Transaction_Date), YEAR(ss.Transaction_Date)
ORDER BY ic.Category, MONTH(ss.Transaction_Date), YEAR(ss.Transaction_Date);

-- Logic Behind My Answer: My logic behind my query is that I was trying to join as much information as I could from the three tables that I had chosen in order to obtain the results that I needed from my data. It was a bit of a struggle to make sure each JOIN flowed properly together, using the queries from the previous ones I had created in questions 1 through 4 to figure it out as well. I did struggle a bit, but I managed to get what I needed. 

-- Question 5: Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
SELECT SUM(ss.Sale_Amount) AS 'Sales Performance',
        RANK() OVER(ORDER BY SUM(ss.Sale_Amount) DESC) AS 'Rank',
        stl.City,
        sm.State
FROM store_list stl
JOIN store_managers sm ON sm.State = stl.State
JOIN store_sales ss ON ss.Store_ID = stl.Store_ID
WHERE sm.State = 'New Jersey'
GROUP BY stl.City
ORDER BY SUM(ss.Sale_Amount);



-- The stores ranked by sales performance are Maryland, which comes at #1 in the ranking, followed by Massachusetts, New Jersey, and finally Maine being the lowest performing state. 

-- Question 6: What is your recommendation for where to focus sales attention in the next quarter?
-- My recommendation for where to focus sales within the next quarter would be to focus it more on the technology & accessories and textbooks because these are the categories with the highest amount of items sold over the span of four years and if we continue to focus more attention on those, then the revenue would continue to grow over the text four years, especially if we have the appropriate and eye catching advertisement that can entice our customers to buy more or garner a newer customer base in need of these items. A second area to focus our attention on in the next quarter would be our store location in Maine because it has the lowest total revenue compared to the other three stores in the states of Maryland, Massachussetts, and New Jersey. If we focus on selling more technology and accessories within the state of Maine, then I feel the total sales performance of the store could soar to rival that of Maryland, Massachussetts, and New Jersey. 