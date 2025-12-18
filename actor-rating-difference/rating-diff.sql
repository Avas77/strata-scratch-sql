WITH actor_rank AS (select 
    actor_name,
    film_rating,
    release_date,
    row_number() OVER (
        partition by actor_name
        ORDER BY release_date DESC
    ) AS actor_rank
from actor_rating_shift), 
avg_rating AS (
    SELECT
        actor_name,
        AVG(film_rating) AS avg_rate
    FROM actor_rank
    WHERE actor_rank > 1
    GROUP BY actor_name
) 

SELECT 
    ar.actor_name,
    COALESCE(avgr.avg_rate, ar.film_rating) AS avg_rating,
    ar.film_rating AS latest_rating,
    ROUND((ar.film_rating - COALESCE(avgr.avg_rate, ar.film_rating))::numeric, 2) AS rating_difference
FROM actor_rank AS ar 
LEFT JOIN avg_rating AS avgr ON ar.actor_name = avgr.actor_name
WHERE ar.actor_rank = 1
