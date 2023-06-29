--Task 1. List all the states in which we have customers who have bought cellphones from 2005 till today.
	
select  distinct L.State
from FACT_TRANSACTIONS as T
Left join DIM_LOCATION as L
On T.IDLocation = L.IDLocation
where T.Date  >= '2005-01-01'


--Task2. What state in the US is buying the most 'Samsung' cell phones?
	
	select State from (
	      select Y.State, count(Y.Quantity) as Qty, Rank () over (Order by count(Y.Quantity) desc) as Rank1
			from  (
					select A1.IDModel, A2.Manufacturer_Name
					from DIM_MODEL as A1
					Left join DIM_MANUFACTURER as A2
					On A1.IDManufacturer = A2.IDManufacturer
					where A2.Manufacturer_Name = 'Samsung'
					) as X
			Right join 
					   (
						select A3.IDModel, A4.Country, A4.State, A3.Quantity
						from FACT_TRANSACTIONS as A3
						Left join DIM_LOCATION as A4
						On A3.IDLocation = A4.IDLocation
						where A4.Country = 'US'
						) as Y
			On X.IDModel = Y.IDModel
			Group by Y.State 			
			) as Z
			where Rank1 = 1



-- Task3. Show the number of transactions for each model per zip code per state.      
	
select A1.IDModel, A2.ZipCode, A2.State, count(A1.IdModel) as Transaction_Count
from FACT_TRANSACTIONS as A1
Left Join DIM_LOCATION as A2
On A1.IDLocation = A2.IDLocation
Group by A1.IDModel, A2.ZipCode, A2.State


--Task4. Show the cheapest cellphone


select Top 1 IDModel, Model_Name, Unit_price
from DIM_MODEL
Order by Unit_price asc


--Task5. Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price. 

select A1.IDModel, avg(TotalPrice) as Avg_Price
from FACT_TRANSACTIONS as A1
Left Join DIM_MODEL as A2
On A1.IDModel = A2.IDModel
where A2.IDManufacturer in ( select X.IDManufacturer
		                                  from (
							select Top 5 B2.IDManufacturer, sum(Quantity) as Tot_Qty 
						        from FACT_TRANSACTIONS as B1
							Left Join DIM_MODEL as B2
							On B1.IDModel = B2.IDModel
							Group by B2.IDManufacturer
							Order by Tot_Qty desc
										) as X )
Group by A1.IDModel



--Task 6. List the names of the customers and the average amount spent in 2009,where the average is higher than 500

select  A1.Customer_Name, A2.Date,  avg(A2.TotalPrice) as Avg_Spent
		from DIM_CUSTOMER as A1
		Right Join FACT_TRANSACTIONS as A2
		On A1.IDCustomer = A2.IDCustomer
		where Year(A2.Date) = 2009
		Group by A1.IDCustomer, A1.Customer_Name, A2.Date
		having avg(A2.TotalPrice) > 500 



--Task7. List if there is any model that was in the top 5 in terms of quantity,simultaneously in 2008, 2009 and 2010  
	
	
                    select IDModel as IDmodel_inTop5_in2008to2010
					from (
					select * from (
						select IDModel, Year(Date) as [Year], sum(Quantity) as Qty, Row_Number() over (partition by Year(Date) Order by sum(Quantity) desc  ) as Rank1
						from FACT_TRANSACTIONS
						where Year(Date) = '2008' or Year(Date) = '2009' or Year(Date) = '2010'
						Group by IDModel, Year(Date)
						) as X
						where Rank1 <= 5
						) as Y						
						group by IDModel
						having count(IDModel) = 3



--Task8. Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.


 select Manufacturer_Name, [Year] 
					from (
						select A1.IDModel, A2.Manufacturer_Name, Year(Date) as [Year], sum(A1.TotalPrice*A1.Quantity) as Total_Sales,
						Dense_Rank() over ( Partition by Year(Date)  Order by sum(A1.TotalPrice*A1.Quantity) desc) as Rank1
						from FACT_TRANSACTIONS as A1
						Left Join		(select B1.IDModel, B2.Manufacturer_Name 
											from DIM_MODEL as B1
											Left Join DIM_MANUFACTURER as B2
											On B1.IDManufacturer = B2.IDManufacturer
											) as A2
							On A1.IDModel = A2.IDModel
							Group by A1.IDModel, A2.Manufacturer_Name, Year(Date)
							) as X
	              where Year = 2009 and Rank1 = 2
				  Or
				  Year = 2010 and Rank1 = 2



--Task 9. Show the manufacturers that sold cellphones in 2010 but did not in 2009.

	select distinct A2.Manufacturer_Name
					from FACT_TRANSACTIONS as A1
					Left Join (	select B1.IDModel, B2.Manufacturer_Name 
							from DIM_MODEL as B1
							Left Join DIM_MANUFACTURER as B2
							On B1.IDManufacturer = B2.IDManufacturer
							) as A2
							On A1.IDModel = A2.IDModel	
							where Year(Date) = 2010
        Except
        select distinct A2.Manufacturer_Name
							from FACT_TRANSACTIONS as A1
							Left Join(  select B1.IDModel, B2.Manufacturer_Name 
								    from DIM_MODEL as B1
								    Left Join DIM_MANUFACTURER as B2
								    On B1.IDManufacturer = B2.IDManufacturer
									) as A2
							On A1.IDModel = A2.IDModel	
							where Year(Date) = 2009


--Task 10. Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend
	
select IDCustomer, [Year], Avg_Spend, Avg_Qty, (Lag1 - Avg_Spend)/Lag1*100 as Perc_Decrease_Spend
				from (
						select  IDCustomer, Year(Date) as [Year], avg(TotalPrice) as Avg_Spend, avg(Quantity) as Avg_Qty,
						Lag(avg(TotalPrice),1) over ( order by avg(TotalPrice) desc) as Lag1
						from FACT_TRANSACTIONS
						where IDCustomer in ( select  Top 10  IDCustomer from FACT_TRANSACTIONS
group by IDCustomer    order by sum(TotalPrice) desc )
						Group by IDCustomer, Year(Date)
						) as X


	
