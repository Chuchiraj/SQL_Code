Task 1.  Who is the senior most employee based on job title?

select  (first_name + ' ' + last_name) as full_name, title
from employee
where reports_to is null


Task 2. Which countries have the most Invoices?

select Top 1 billing_country as country, count(invoice_id) as invoice_count
from invoice
group by billing_country
order by 2 desc

Task 3. What are top 3 values of total invoice?

select Top 3 invoice_id, total
from invoice
order by 2 desc

Task 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city as city, round(sum(total),2) as invoice_total_amt
from invoice
group by billing_city
order by 2 desc

Task 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
 

select Top 1 a.customer_id, (b.first_name + ' ' + b.last_name) as full_name, round(sum(a.total),2) as total_invoice_amt
from invoice as a
left join customer as b
on a.customer_id = b.customer_id
group by a.customer_id, (b.first_name + ' ' + b.last_name)
order by 3 desc

Task 6.  Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A

select distinct b.first_name, b.last_name, b.email 
from invoice as a
left join customer as b
on a.customer_id = b.customer_id
left join invoice_line as c
on a.invoice_id = c.invoice_id
join track as d
on c.track_id = d.track_id
join genre as e
on e.genre_id = d.genre_id
where e.name = 'Rock'
order by 3



Task 7. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands

select  Top 10 b.artist_id, b.name, count(b.artist_id) as cnt
from album as a
left join artist as b
on a.artist_id = b.artist_id
right join track as c
on a.album_id = c.album_id
left join genre as d
on c.genre_id = d.genre_id 
where d.name = 'Rock'
group by b.artist_id, b.name
order by 3 desc

Task 8. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track.  Order by the song length with the longest songs listed first


select name, milliseconds 
from track
where milliseconds > (select AVG( milliseconds) from track)
order by 2 desc


Task 9. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

select (f.first_name + ' ' + f.last_name) as full_name, b.name as artist_name, sum(cast(d.quantity as int) * cast(d.unit_price as float)) as total_amt_spent
from album as a
left join artist as b  on a.artist_id = b.artist_id
right join track as c on a.album_id = c.album_id
right join invoice_line as d on d.track_id = c.track_id
left join invoice as e on e.invoice_id = d.invoice_id
left join customer as f on f.customer_id = e.customer_id
group by  (f.first_name + ' ' + f.last_name) , b.name
order by 3 desc


Task 10. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the countryalong with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount

with top_customer_country as (
select b.billing_country, (a.first_name + ' ' + a.last_name) as full_name,  round(sum(cast(c.quantity as int) * cast(c.unit_price as float)),2) as total_amt_spent
, DENSE_RANK() over (partition by b.billing_country order by round(sum(cast(c.quantity as int) * cast(c.unit_price as float)),2) desc) as rnk
from customer as a
right join invoice as b on b.customer_id = a.customer_id
right join invoice_line as c on c.invoice_id = b.invoice_id
group by b.billing_country, (a.first_name + ' ' + a.last_name)
) 
select *
from top_customer_country
where rnk = 1
order by 3 desc



Task 11. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases.Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

select * from (

     select a.billing_country, d.name, sum(cast(b.quantity as int)) as tot_qty,
	 DENSE_RANK() over( partition by billing_country  order by sum(cast(b.quantity as int)) desc ) as rnk
     from invoice as a
     right join invoice_line as b on a.invoice_id = b.invoice_id 
     left join track as c on c.track_id = b.track_id
     left join genre as d on d.genre_id = c.genre_id
     group by a.billing_country, d.name
	) as g
	where rnk = 1






 
 
















