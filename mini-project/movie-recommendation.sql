-- ============================================================
--  Movie Recommendation & Rating Analysis System
--  PostgreSQL 13+  
-- ============================================================


-- ============================================================
--  SECTION 1 — SCHEMA
-- ============================================================

DROP TABLE IF EXISTS watch_history CASCADE;
DROP TABLE IF EXISTS ratings       CASCADE;
DROP TABLE IF EXISTS movies        CASCADE;
DROP TABLE IF EXISTS users         CASCADE;


-- USERS
CREATE TABLE users (
    user_id   SERIAL PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    age       SMALLINT     NOT NULL CHECK (age BETWEEN 1 AND 120),
    joined_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  users           IS 'Registered platform users';
COMMENT ON COLUMN users.age       IS 'Used for age-group segmentation in recommendations';
COMMENT ON COLUMN users.joined_at IS 'Account creation timestamp';


-- MOVIES
CREATE TABLE movies (
    movie_id     SERIAL PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    genre        VARCHAR(60)  NOT NULL,
    release_year SMALLINT     NOT NULL CHECK (release_year BETWEEN 1888 AND 2100),
    duration_min SMALLINT     CHECK (duration_min > 0),
    language     VARCHAR(50)  NOT NULL DEFAULT 'English'
);

COMMENT ON TABLE  movies              IS 'Movie catalogue';
COMMENT ON COLUMN movies.genre        IS 'Primary genre';
COMMENT ON COLUMN movies.duration_min IS 'Runtime in minutes';


-- RATINGS
CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id   INT           NOT NULL REFERENCES users(user_id)  ON DELETE CASCADE,
    movie_id  INT           NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    rating    NUMERIC(2, 1) NOT NULL CHECK (rating BETWEEN 0.5 AND 5.0),
    rated_at  TIMESTAMP     NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_user_movie_rating UNIQUE (user_id, movie_id)
);

COMMENT ON COLUMN ratings.rating IS '0.5–5.0 in half-star increments';


-- WATCH HISTORY
CREATE TABLE watch_history (
    history_id    SERIAL  PRIMARY KEY,
    user_id       INT     NOT NULL REFERENCES users(user_id)  ON DELETE CASCADE,
    movie_id      INT     NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    watch_date    DATE    NOT NULL DEFAULT CURRENT_DATE,
    completed     BOOLEAN NOT NULL DEFAULT TRUE,
    watch_percent SMALLINT CHECK (watch_percent BETWEEN 0 AND 100)
);

COMMENT ON COLUMN watch_history.completed     IS 'Whether the user finished the movie';
COMMENT ON COLUMN watch_history.watch_percent IS 'Percentage of runtime watched';


-- INDEXES
CREATE INDEX idx_ratings_movie  ON ratings(movie_id);
CREATE INDEX idx_ratings_user   ON ratings(user_id);
CREATE INDEX idx_watch_user     ON watch_history(user_id);
CREATE INDEX idx_watch_date     ON watch_history(watch_date);
CREATE INDEX idx_watch_movie    ON watch_history(movie_id);
CREATE INDEX idx_movies_genre   ON movies(genre);


-- ============================================================
--  SECTION 2 — 
-- ============================================================

INSERT INTO users (name, age) VALUES
    ('Aisha Nair',       27),
    ('Rohan Mehta',      34),
    ('Priya Krishnan',   22),
    ('Carlos Mendes',    45),
    ('Liu Wei',          30),
    ('Sara Okonkwo',     19),
    ('James Harrington', 52),
    ('Meera Pillai',     38),
    ('Arjun Sharma',     25),
    ('Elena Vasquez',    41);


INSERT INTO movies (title, genre, release_year, duration_min, language) VALUES
    ('Inception',                'Sci-Fi',    2010, 148, 'English'),
    ('Parasite',                 'Thriller',  2019, 132, 'Korean'),
    ('The Dark Knight',          'Action',    2008, 152, 'English'),
    ('Spirited Away',            'Animation', 2001, 125, 'Japanese'),
    ('Interstellar',             'Sci-Fi',    2014, 169, 'English'),
    ('Get Out',                  'Horror',    2017, 104, 'English'),
    ('La La Land',               'Drama',     2016, 128, 'English'),
    ('Avengers: Endgame',        'Action',    2019, 181, 'English'),
    ('The Shawshank Redemption', 'Drama',     1994, 142, 'English'),
    ('Your Name',                'Animation', 2016, 106, 'Japanese'),
    ('Dune',                     'Sci-Fi',    2021, 155, 'English'),
    ('Everything Everywhere',    'Sci-Fi',    2022, 139, 'English'),
    ('Oldboy',                   'Thriller',  2003, 120, 'Korean'),
    ('Mad Max: Fury Road',       'Action',    2015, 120, 'English'),
    ('Hereditary',               'Horror',    2018, 127, 'English');


INSERT INTO ratings (user_id, movie_id, rating) VALUES
    (1, 1, 4.5), (1, 2, 5.0), (1, 5, 4.0), (1, 11, 4.5),
    (2, 1, 4.0), (2, 3, 5.0), (2, 8, 4.5), (2, 14, 4.0), (2, 9, 5.0),
    (3, 4, 5.0), (3, 10, 5.0), (3, 7, 4.0), (3, 2, 4.5),
    (4, 9, 5.0), (4, 7, 4.5), (4, 3, 4.0), (4, 6, 3.5),
    (5, 2, 4.5), (5, 13, 5.0), (5, 4, 4.5), (5, 10, 4.5), (5, 1, 4.0),
    (6, 6, 4.5), (6, 15, 5.0), (6, 8, 3.5),
    (7, 9, 4.5), (7, 3, 5.0), (7, 14, 4.5), (7, 5, 4.0),
    (8, 7, 5.0), (8, 9, 4.5), (8, 12, 4.5), (8, 2, 4.0),
    (9, 1, 5.0), (9, 5, 5.0), (9, 11, 5.0), (9, 12, 4.5), (9, 8, 4.0),
    (10, 2, 5.0), (10, 13, 4.5), (10, 6, 4.0), (10, 15, 4.0);


INSERT INTO watch_history (user_id, movie_id, watch_date, completed, watch_percent) VALUES
    (1, 1,  '2024-10-01', TRUE,  100),
    (1, 2,  '2024-10-05', TRUE,  100),
    (1, 5,  '2024-11-10', TRUE,  100),
    (1, 11, '2024-12-01', TRUE,  100),
    (2, 1,  '2024-09-15', TRUE,  100),
    (2, 3,  '2024-09-20', TRUE,  100),
    (2, 8,  '2024-10-18', TRUE,  100),
    (2, 14, '2024-11-05', TRUE,  100),
    (2, 9,  '2024-12-10', TRUE,  100),
    (3, 4,  '2024-08-22', TRUE,  100),
    (3, 10, '2024-09-14', TRUE,  100),
    (3, 7,  '2024-10-30', TRUE,  100),
    (3, 2,  '2024-11-25', FALSE,  60),
    (4, 9,  '2024-07-11', TRUE,  100),
    (4, 7,  '2024-08-03', TRUE,  100),
    (4, 3,  '2024-10-12', TRUE,  100),
    (4, 6,  '2024-12-05', FALSE,  45),
    (5, 2,  '2024-09-01', TRUE,  100),
    (5, 13, '2024-09-22', TRUE,  100),
    (5, 4,  '2024-10-07', TRUE,  100),
    (5, 10, '2024-11-18', TRUE,  100),
    (5, 1,  '2024-12-03', TRUE,  100),
    (6, 6,  '2024-10-31', TRUE,  100),
    (6, 15, '2024-11-01', TRUE,  100),
    (6, 8,  '2024-11-20', FALSE,  70),
    (7, 9,  '2024-06-15', TRUE,  100),
    (7, 3,  '2024-07-04', TRUE,  100),
    (7, 14, '2024-09-09', TRUE,  100),
    (7, 5,  '2024-11-11', TRUE,  100),
    (8, 7,  '2024-10-14', TRUE,  100),
    (8, 9,  '2024-10-29', TRUE,  100),
    (8, 12, '2024-11-22', TRUE,  100),
    (8, 2,  '2024-12-08', TRUE,  100),
    (9, 1,  '2024-11-01', TRUE,  100),
    (9, 5,  '2024-11-08', TRUE,  100),
    (9, 11, '2024-11-15', TRUE,  100),
    (9, 12, '2024-11-22', TRUE,  100),
    (9, 8,  '2024-12-01', TRUE,  100),
    (10, 2, '2024-10-10', TRUE,  100),
    (10, 13,'2024-10-24', TRUE,  100),
    (10, 6, '2024-11-13', FALSE,  55),
    (10, 15,'2024-12-07', TRUE,  100);


-- ============================================================
--  SECTION 3 — VIEWS
-- ============================================================

CREATE OR REPLACE VIEW vw_movie_stats AS
SELECT
    m.movie_id,
    m.title,
    m.genre,
    m.release_year,
    m.duration_min,
    m.language,
    COUNT(DISTINCT r.rating_id)    AS rating_count,
    ROUND(AVG(r.rating), 2)        AS avg_rating,
    COUNT(DISTINCT wh.history_id)  AS watch_count,
    SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END) AS completion_count,
    ROUND(
        100.0
        * SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END)
        / NULLIF(COUNT(wh.history_id), 0)
    , 1)                           AS completion_rate_pct
FROM movies m
LEFT JOIN ratings       r  ON r.movie_id  = m.movie_id
LEFT JOIN watch_history wh ON wh.movie_id = m.movie_id
GROUP BY m.movie_id, m.title, m.genre, m.release_year, m.duration_min, m.language;


CREATE OR REPLACE VIEW vw_user_stats AS
SELECT
    u.user_id,
    u.name,
    u.age,
    CASE
        WHEN u.age BETWEEN 13 AND 24 THEN '13-24'
        WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 49 THEN '35-49'
        ELSE '50+'
    END                            AS age_group,
    COUNT(DISTINCT wh.movie_id)    AS movies_watched,
    COUNT(DISTINCT r.movie_id)     AS movies_rated,
    ROUND(AVG(r.rating), 2)        AS avg_rating_given,
    ROUND(
        100.0
        * SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END)
        / NULLIF(COUNT(wh.history_id), 0)
    , 1)                           AS completion_rate_pct,
    MAX(wh.watch_date)             AS last_active
FROM users u
LEFT JOIN watch_history wh ON wh.user_id = u.user_id
LEFT JOIN ratings r        ON r.user_id  = u.user_id
GROUP BY u.user_id, u.name, u.age;


CREATE OR REPLACE VIEW vw_trending_7d AS
SELECT
    m.movie_id,
    m.title,
    m.genre,
    COUNT(wh.history_id)                     AS watches_7d,
    ROUND(AVG(r.rating), 2)                  AS avg_rating,
    ROUND((
        COUNT(wh.history_id) * 0.6
        + COALESCE(AVG(r.rating), 0) * 0.4
    ), 2)                                    AS trend_score
FROM movies m
JOIN watch_history wh ON wh.movie_id = m.movie_id
LEFT JOIN ratings r   ON r.movie_id  = m.movie_id
WHERE wh.watch_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY m.movie_id, m.title, m.genre
ORDER BY trend_score DESC;


-- ============================================================
--  SECTION 4 — FUNCTIONS
-- ============================================================

-- Collaborative filtering recommendations for a user
CREATE OR REPLACE FUNCTION fn_recommend_for_user(
    p_user_id INT,
    p_limit   INT DEFAULT 5
)
RETURNS TABLE (
    movie_id             INT,
    title                VARCHAR,
    genre                VARCHAR,
    release_year         SMALLINT,
    recommendation_score NUMERIC,
    recommender_count    BIGINT
)
LANGUAGE SQL STABLE AS $$
    WITH target_ratings AS (
        SELECT movie_id, rating
        FROM   ratings
        WHERE  user_id = p_user_id
    ),
    similar_users AS (
        SELECT
            r.user_id,
            SUM(r.rating * tr.rating)
                / (SQRT(SUM(r.rating ^ 2)) * SQRT(SUM(tr.rating ^ 2))) AS cosine_sim
        FROM ratings r
        JOIN target_ratings tr ON tr.movie_id = r.movie_id
        WHERE r.user_id != p_user_id
        GROUP BY r.user_id
        HAVING COUNT(*) >= 2
        ORDER BY cosine_sim DESC
        LIMIT 10
    ),
    candidates AS (
        SELECT
            r.movie_id,
            SUM(su.cosine_sim * r.rating) AS weighted_score,
            COUNT(DISTINCT r.user_id)     AS recommender_count
        FROM ratings r
        JOIN similar_users su ON su.user_id = r.user_id
        WHERE r.movie_id NOT IN (SELECT movie_id FROM target_ratings)
          AND r.rating >= 4.0
        GROUP BY r.movie_id
    )
    SELECT
        m.movie_id,
        m.title,
        m.genre,
        m.release_year,
        ROUND(c.weighted_score::NUMERIC, 3),
        c.recommender_count
    FROM candidates c
    JOIN movies m ON m.movie_id = c.movie_id
    ORDER BY weighted_score DESC
    LIMIT p_limit;
$$;


-- Genre-based recommendations (cold-start fallback)
CREATE OR REPLACE FUNCTION fn_genre_recommendations(
    p_genre VARCHAR,
    p_limit INT DEFAULT 5
)
RETURNS TABLE (
    movie_id     INT,
    title        VARCHAR,
    genre        VARCHAR,
    release_year SMALLINT,
    avg_rating   NUMERIC,
    rating_count BIGINT
)
LANGUAGE SQL STABLE AS $$
    SELECT
        m.movie_id,
        m.title,
        m.genre,
        m.release_year,
        ROUND(AVG(r.rating)::NUMERIC, 2),
        COUNT(r.rating_id)
    FROM movies m
    JOIN ratings r ON r.movie_id = m.movie_id
    WHERE m.genre ILIKE p_genre
    GROUP BY m.movie_id, m.title, m.genre, m.release_year
    HAVING COUNT(r.rating_id) >= 2
    ORDER BY AVG(r.rating) DESC, COUNT(r.rating_id) DESC
    LIMIT p_limit;
$$;


-- Genre affinity ranking for a user
CREATE OR REPLACE FUNCTION fn_user_genre_affinity(
    p_user_id INT
)
RETURNS TABLE (
    genre          VARCHAR,
    watch_count    BIGINT,
    avg_rating     NUMERIC,
    affinity_score NUMERIC
)
LANGUAGE SQL STABLE AS $$
    SELECT
        m.genre,
        COUNT(wh.history_id)             AS watch_count,
        ROUND(AVG(r.rating)::NUMERIC, 2) AS avg_rating,
        ROUND((
            COUNT(wh.history_id) * 0.5
            + COALESCE(AVG(r.rating), 3.0) * 0.5
        )::NUMERIC, 2)                   AS affinity_score
    FROM watch_history wh
    JOIN movies m ON m.movie_id = wh.movie_id
    LEFT JOIN ratings r ON r.user_id  = wh.user_id
                       AND r.movie_id = wh.movie_id
    WHERE wh.user_id = p_user_id
    GROUP BY m.genre
    ORDER BY affinity_score DESC;
$$;


-- ============================================================
--  SECTION 5 — ANALYSIS QUERIES
-- ============================================================

-- 1. Top-rated movies (min 3 ratings)
SELECT
    m.title,
    m.genre,
    m.release_year,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.rating_id)      AS total_ratings
FROM movies m
JOIN ratings r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title, m.genre, m.release_year
HAVING COUNT(r.rating_id) >= 3
ORDER BY avg_rating DESC, total_ratings DESC
LIMIT 10;


-- 2. Most popular genres
SELECT
    m.genre,
    COUNT(DISTINCT wh.history_id) AS total_watches,
    COUNT(DISTINCT r.rating_id)   AS total_ratings,
    ROUND(AVG(r.rating), 2)       AS avg_rating,
    ROUND(
        (COUNT(DISTINCT wh.history_id) * 0.6)
        + (AVG(r.rating) * COUNT(DISTINCT r.rating_id) * 0.4)
    , 1)                          AS popularity_score
FROM movies m
LEFT JOIN watch_history wh ON wh.movie_id = m.movie_id
LEFT JOIN ratings r        ON r.movie_id  = m.movie_id
GROUP BY m.genre
ORDER BY popularity_score DESC;


-- 3. Collaborative filtering — change user_id to test different users
WITH target_ratings AS (
    SELECT movie_id, rating FROM ratings WHERE user_id = 1
),
similar_users AS (
    SELECT
        r.user_id,
        COUNT(*)                                                    AS shared_movies,
        SUM(r.rating * tr.rating)
            / (SQRT(SUM(r.rating * r.rating))
               * SQRT(SUM(tr.rating * tr.rating)))                 AS cosine_sim
    FROM ratings r
    JOIN target_ratings tr ON tr.movie_id = r.movie_id
    WHERE r.user_id != 1
    GROUP BY r.user_id
    HAVING COUNT(*) >= 2
    ORDER BY cosine_sim DESC
    LIMIT 10
),
candidate_movies AS (
    SELECT
        r.movie_id,
        SUM(su.cosine_sim * r.rating) AS weighted_score,
        COUNT(DISTINCT r.user_id)     AS recommender_count
    FROM ratings r
    JOIN similar_users su ON su.user_id = r.user_id
    WHERE r.movie_id NOT IN (SELECT movie_id FROM target_ratings)
      AND r.rating >= 4.0
    GROUP BY r.movie_id
)
SELECT
    m.title,
    m.genre,
    m.release_year,
    ROUND(cm.weighted_score::NUMERIC, 3) AS recommendation_score,
    cm.recommender_count
FROM candidate_movies cm
JOIN movies m ON m.movie_id = cm.movie_id
ORDER BY recommendation_score DESC
LIMIT 5;


-- 4. User behaviour analysis
SELECT
    u.user_id,
    u.name,
    u.age,
    COUNT(DISTINCT wh.movie_id)  AS movies_watched,
    COUNT(DISTINCT r.movie_id)   AS movies_rated,
    ROUND(AVG(r.rating), 2)      AS avg_rating_given,
    SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END) AS completed_count,
    ROUND(
        100.0
        * SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END)
        / NULLIF(COUNT(wh.history_id), 0)
    , 1)                         AS completion_rate_pct,
    MAX(wh.watch_date)           AS latest_watch
FROM users u
LEFT JOIN watch_history wh ON wh.user_id = u.user_id
LEFT JOIN ratings r        ON r.user_id  = u.user_id
GROUP BY u.user_id, u.name, u.age
ORDER BY movies_watched DESC;


-- 5. Trending movies (last 30 days)
SELECT
    m.title,
    m.genre,
    COUNT(wh.history_id)                              AS recent_watches,
    ROUND(AVG(r.rating), 2)                           AS avg_rating,
    SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END)     AS completions,
    ROUND(
        COUNT(wh.history_id) * 0.5
        + AVG(r.rating) * 0.3
        + SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END) * 0.2
    , 2)                                              AS trend_score
FROM movies m
JOIN watch_history wh ON wh.movie_id = m.movie_id
LEFT JOIN ratings r   ON r.movie_id  = m.movie_id
WHERE wh.watch_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY m.movie_id, m.title, m.genre
ORDER BY trend_score DESC
LIMIT 10;


-- 6. Genre affinity per user
SELECT
    u.user_id,
    u.name,
    m.genre,
    COUNT(wh.history_id)    AS watch_count,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM users u
JOIN watch_history wh ON wh.user_id  = u.user_id
JOIN movies m         ON m.movie_id  = wh.movie_id
LEFT JOIN ratings r   ON r.user_id   = u.user_id
                     AND r.movie_id  = wh.movie_id
GROUP BY u.user_id, u.name, m.genre
ORDER BY u.user_id, watch_count DESC;


-- 7. High drop-off movies
SELECT
    m.title,
    m.genre,
    COUNT(wh.history_id)                              AS total_starts,
    SUM(CASE WHEN wh.completed THEN 1 ELSE 0 END)     AS completions,
    ROUND(
        100.0
        * SUM(CASE WHEN NOT wh.completed THEN 1 ELSE 0 END)
        / NULLIF(COUNT(wh.history_id), 0)
    , 1)                                              AS drop_off_pct,
    ROUND(AVG(wh.watch_percent), 1)                   AS avg_watch_pct
FROM movies m
JOIN watch_history wh ON wh.movie_id = m.movie_id
GROUP BY m.movie_id, m.title, m.genre
HAVING COUNT(wh.history_id) >= 2
ORDER BY drop_off_pct DESC;


-- 8. Age-group genre preferences
SELECT
    CASE
        WHEN u.age BETWEEN 13 AND 24 THEN '13-24'
        WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 49 THEN '35-49'
        ELSE '50+'
    END                      AS age_group,
    m.genre,
    COUNT(wh.history_id)     AS watch_count,
    ROUND(AVG(r.rating), 2)  AS avg_rating
FROM users u
JOIN watch_history wh ON wh.user_id = u.user_id
JOIN movies m         ON m.movie_id = wh.movie_id
LEFT JOIN ratings r   ON r.user_id  = u.user_id
                     AND r.movie_id = wh.movie_id
GROUP BY age_group, m.genre
ORDER BY age_group, watch_count DESC;


-- 9. Watched but never rated
SELECT
    u.user_id,
    u.name,
    m.title,
    wh.watch_date,
    wh.completed
FROM watch_history wh
JOIN users  u ON u.user_id  = wh.user_id
JOIN movies m ON m.movie_id = wh.movie_id
WHERE NOT EXISTS (
    SELECT 1 FROM ratings r
    WHERE r.user_id  = wh.user_id
      AND r.movie_id = wh.movie_id
)
ORDER BY u.user_id, wh.watch_date DESC;


-- 10. Platform overview dashboard
SELECT
    (SELECT COUNT(*) FROM users)                                    AS total_users,
    (SELECT COUNT(*) FROM movies)                                   AS total_movies,
    (SELECT COUNT(*) FROM ratings)                                  AS total_ratings,
    (SELECT COUNT(*) FROM watch_history)                            AS total_watches,
    (SELECT ROUND(AVG(rating), 2) FROM ratings)                     AS platform_avg_rating,
    (SELECT COUNT(*) FROM watch_history WHERE completed = TRUE)     AS total_completions,
    (SELECT title FROM movies m
     JOIN ratings r ON r.movie_id = m.movie_id
     GROUP BY m.movie_id, m.title
     ORDER BY AVG(r.rating) DESC LIMIT 1)                           AS highest_rated_movie,
    (SELECT genre FROM movies m
     JOIN watch_history wh ON wh.movie_id = m.movie_id
     GROUP BY m.genre
     ORDER BY COUNT(*) DESC LIMIT 1)                                AS most_watched_genre;


-- ============================================================
--  SECTION 6 — SAMPLE FUNCTION CALLS
-- ============================================================

-- Get top 5 recommendations for user 1
SELECT * FROM fn_recommend_for_user(1, 5);

-- Cold-start: best Sci-Fi movies for a new user
SELECT * FROM fn_genre_recommendations('Sci-Fi', 5);

-- Genre affinity for user 3
SELECT * FROM fn_user_genre_affinity(3);

-- Quick view checks
SELECT * FROM vw_movie_stats ORDER BY avg_rating DESC;
SELECT * FROM vw_user_stats  ORDER BY movies_watched DESC;
