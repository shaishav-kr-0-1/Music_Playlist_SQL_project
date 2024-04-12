--                 SQL PROJECT- MUSIC STORE DATA ANALYSIS
-- 1. Who is the senior most employee based on job title?
SELECT * FROM employee
ORDER BY levels DESC limit 1;

-- 2. Which countries have the most Invoices?
SELECT billing_country , count(*) from invoice
group by 1
order by 2 desc ;

-- 3. What are top 3 values of total invoice?
Select total from invoice
order by total desc limit 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
Select billing_city, sum(total) from invoice
group by 1 order by 2 desc limit 1;

-- 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
select concat(first_name," " ,last_name) , sum(total) from customer c
join invoice i
on c.customer_id= i.customer_id
group by 1 
order by 2 desc limit 1;

-- 6. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
select distinct email , first_name , last_name , g.name from customer c
join invoice i on c.customer_id= i.customer_id
join invoice_line il on il.invoice_id - i.invoice_id
join track t on t.track_id = il.track_id
join genre g on t.genre_id = g.genre_id
where g.name ="Rock"
order by 1;

-- 7. Let's invite the artists who have written the most rock music in our dataset. Write aquery that returns the Artist name and total track count of the top 10 rock bands
select a.name, count(t.name) from artist a 
join album al on al.artist_id = a.artist_id
join track t on t.album_id= al.album_id
join genre g on t.genre_id = g.genre_id
where g.name = "Rock"
group by 1
order by 2 desc limit 10;

-- 8 Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
select name , milliseconds from track 
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;


-- 9: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
