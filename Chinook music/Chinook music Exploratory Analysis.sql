-- Exploratory Data Analysis

-- Customer that has spend the most and with how much
SELECT i.customer_id,
		c.last_name, 
        c.first_name, 
        ROUND(SUM(total),2) AS amount_spent
FROM invoice i
JOIN customer c
	USING (customer_id)
GROUP BY i.customer_id, c.last_name, c.first_name
ORDER BY amount_spent DESC;

-- artist with the most albums
SELECT artist_id,
		ar.name,
        COUNT(artist_id) AS total_count_album
FROM album al
JOIN artist ar
	USING(artist_id)
GROUP BY artist_id, ar.name
ORDER BY total_count_album DESC;

-- list of customer for each employee that supported the customers
SELECT customer_id,
		c.last_name,
        c.first_name,
        c.phone,
        c.support_rep_id,
        e.last_name,
        e.first_name, 
		ROW_NUMBER () OVER (PARTITION BY support_rep_id) AS list_numbering
FROM customer c
JOIN employee e
	ON c.support_rep_id = e.employee_id;

-- employee hierarchy
SELECT e.employee_id,
		e.last_name,
        e.first_name,
        e.title AS employee_title,
        em. last_name AS Lname_of_reports_to,
        em.title AS Title_of_reports_to
FROM employee e
LEFT JOIN employee em
	ON e.reports_to = em.employee_id;


-- checking to see what a customer bought
-- can use 'where clause' to check for a specific customer
SELECT i.customer_id, c.last_name, c.first_name, il.track_id, t.name AS track_name
FROM invoiceline il
JOIN invoice i
	ON il.invoice_id = i.invoice_id
JOIN customer c
	ON i.customer_id = c.customer_id
JOIN track t
	ON il.track_id = t.track_id
ORDER BY i.customer_id;



-- most bought track
SELECT il.track_id, t.name, COUNT(il.track_id) AS number_bought
FROM invoiceline il
JOIN track t
	ON il.track_id = t.track_id
GROUP BY il.track_id, t.name
ORDER BY number_bought DESC;
-- no significance since its almost balanced


-- most bought genre
SELECT t.genre_id, g.name AS genre_name, COUNT(t.genre_id) AS total_genre_bought
FROM invoiceline il
JOIN track t
	ON il.track_id = t.track_id
JOIN genre g
	ON t.genre_id = g.genre_id
GROUP BY t.genre_id, genre_name
ORDER BY total_genre_bought DESC;



-- most track are what genre
SELECT  g.genre_id, g.name AS genre_name, COUNT(t.genre_id) AS total_under_genre
FROM track t
JOIN genre g
	ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.name
ORDER BY total_under_genre DESC;


-- most bought mediatype
SELECT mt.mediatype_id, mt.name AS mediatype_name, COUNT(t.mediatype_id) AS total_mediatype_sold
FROM invoiceline il
JOIN track t
	ON il.track_id = t.track_id
JOIN mediatype mt
	ON t.mediatype_id = mt.mediatype_id
GROUP BY mt.mediatype_id, mediatype_name
ORDER BY total_mediatype_sold DESC;


-- most track is under what mediatype
SELECT mt.mediatype_id, mt.name AS mediatype_name, COUNT(t.mediatype_id) AS total_mediatype
FROM track t
JOIN mediatype mt
	ON t.mediatype_id = mt.mediatype_id
GROUP BY mt.mediatype_id, mediatype_name
ORDER BY total_mediatype DESC;


-- most track is under what album
SELECT al.album_id, al.title AS album_title, COUNT(t.album_id)  AS total_track
FROM track t
JOIN album al
	ON t.album_id = al.album_id
GROUP BY al.album_id, album_title
ORDER BY total_track DESC;


-- most track is under what playlist
SELECT p.playlist_id, p.name AS playlist_name, COUNT(pt.playlist_id) AS total_track
FROM playlisttrack pt
JOIN playlist p
	ON pt.playlist_id = p.playlist_id
GROUP BY p.playlist_id, playlist_name
ORDER BY total_track DESC;

-- there is duplication, so we will have to data clean
DELETE
FROM playlisttrack
WHERE playlist_id IN (8,10);
    
DELETE
FROM playlist
WHERE playlist_id IN (8,10);


SET @new_id = 0;
UPDATE playlist
SET Playlist_Id = (@new_id := @new_id + 1)
ORDER BY Playlist_Id;


-- most track is under what playlist (updated version)
SELECT p.playlist_id, p.name AS playlist_name, COUNT(pt.playlist_id) AS total_track
FROM playlisttrack pt
JOIN playlist p
	ON pt.playlist_id = p.playlist_id
GROUP BY p.playlist_id, playlist_name
ORDER BY total_track DESC;



-- what artist each customer likes by what they bought
-- here we are checking how many tracks the customer bought from each artist
-- here i will have to join very many tables together 
WITH ArtistPreference AS (
		SELECT c.customer_id, c.first_name, c.last_name, ar.artist_id, ar.name AS artist_name, COUNT(*) AS purchase_count
		FROM customer c
		JOIN invoice i
			ON c.customer_id = i.customer_id
		JOIN invoiceline il
			ON 	i.invoice_id = il.invoice_id
		JOIN track t
			ON t.track_id = il.track_id
		JOIN album al
			ON t.album_id = al.album_id
		JOIN artist ar
			ON ar.artist_id = al.artist_id
		GROUP BY c.customer_id, c.first_name, c.last_name, ar.artist_id, artist_name
)
SELECT ap.customer_id,
    ap.first_name,
    ap.last_name, 
    ap.artist_id,
    ap.artist_name,
    purchase_count AS purchase_count_per_artist
FROM ArtistPreference ap
WHERE ap.purchase_count = (
						SELECT MAX(purchase_count) 
						FROM ArtistPreference 
						WHERE customer_id = ap.customer_id
						)
ORDER BY customer_id;

