Select * from  anurag.netflix_titles;

Select Count(*) as total_content
 from anurag.netflix_titles;
 
 
-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows

Select 
    type,
    COUNT(*) as total_count
FROM
  anurag.netflix_titles 
  GROUP BY type
 
-- 2. find the most common rating for movies and TV shows
SELECT 
     type,
     rating
FROM
    netflix_titles

(
   select
	  type,
	   rating,
	   COUNT(*),
	   RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
   FROM 
	  anurag.netflix_titles
   GROUP BY 1, 2
) as t1
WHERE 
     ranking = 1
   -- type
-- LIMIT 1000;
-- ORDER BY 1, 3 DESC
-- ORDER BY 1, 3 ASC


SELECT * 
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS count_titles, 
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM 
        anurag.netflix_titles
    GROUP BY 
        type, rating
) AS t1
WHERE 
    ranking = 100;

-- 3. List all movies released in a specific year (e.g., 2020)

-- filter 2020
-- movies

SELECT * FROM anurag.netflix_titles 
WHERE
     type = 'Movie'
	 AND
     release_year = 2020
	 
-- 4. Find the top 5 countries with the most content on Nerflix

SELECT 
    country, 
    COUNT(*) AS total_content
FROM 
     anurag.netflix_titles
GROUP BY 
    country
ORDER BY 
    total_content DESC
LIMIT 5;

/* portfolio

SELECT 
    UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
    COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
*/
-- 5. Identify the longest movie?

SELECT * FROM anurag.netflix_titles
WHERE
    type = 'Movie'
    AND
    duration  = (SELECT MAX(duration) FROM anurag.netflix_titles)

-- 6. Find content added in the last 5 years
    
SELECT CURRENT_DATE - INTERVAL 5 YEAR;

SELECT * 
FROM anurag.netflix_titles
WHERE 
    STR_TO_DATE(date_added, '%M %d, %Y') >= CURRENT_DATE - INTERVAL 5 YEAR;

-- 7. FIND all the movies/TV Shows by director 'Rajiv Chilaka'!

SELECT * 
FROM anurag.netflix_titles
WHERE 
     director LIKE '%Hajime Kamegaki%'
 
 -- 8. List all TV shows with more than 5 seasons
 
/*SELECT 
	 *
FROM anurag.netflix_titles
WHERE 
    type = 'TV Show'
    AND
    SPLIT_PART(duration, '', 1)::numeric > '5'
*/
  
  
  
SELECT 
    SUBSTRING_INDEX('APPLE BANANA CHERRY', '', 1)

SELECT 
   *, 
   CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS sessions 
FROM 
   anurag.netflix_titles
WHERE 
   type = 'TV Show'
   AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
   
-- 9. COUNT the number of content items in each genre

SELECT
	SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1) AS genre, 
    COUNT(show_id) 
FROM anurag.netflix_titles
GROUP BY genres
ORDER BY 
	total_content DESC
    LIMIT 10;

SELECT 
	 *
FROM anurag.netflix_titles

SELECT 
    genre,
    COUNT(show_id) AS total_content
FROM (
    SELECT 
        SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1) AS genre, show_id
    FROM 
        anurag.netflix_titles
    CROSS JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
        CROSS JOIN (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    ) n
    WHERE 
        n.n <= 1 + (LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')))
) AS genres
GROUP BY genre
ORDER BY total_content DESC
LIMIT 10;


-- 10. Find each year and the average number of content release in India on netflix, return top 5 year with highest avg content release !

SELECT
    TO_DATE(date_added, '%M %d, %Y') as date,
    
FROM anurag.netflix_titles
WHERE country = 'India' 
