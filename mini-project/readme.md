# Movie Recommendation & Rating Analysis System - Mini project

A PostgreSQL database project that models the core data layer behind a streaming platform — storing user behaviour, movie metadata, and ratings, then using SQL to surface recommendations, trends, and engagement analytics.

---

## What This Does

Most recommendation engines start with a well-designed schema and a solid query layer before any machine learning gets involved. This project builds that foundation:

- **Schema** — normalised tables for users, movies, ratings, and watch history
- **Collaborative filtering** — SQL-based user similarity using cosine distance to recommend movies
- **Trend detection** — weighted scoring of recently watched content
- **Behaviour analytics** — completion rates, drop-off detection, genre affinity, age-group segmentation
- **Reusable views & functions** — so application code stays thin

- 
![Result 1] (mini-project/Sql mini project.png) 

## Schema

```
users          — user_id, name, age, joined_at
movies         — movie_id, title, genre, release_year, duration_min, language
ratings        — user_id → movie_id, rating (0.5–5.0), rated_at
watch_history  — user_id → movie_id, watch_date, completed, watch_percent
```

Foreign keys enforce referential integrity. `CASCADE` deletes keep the history clean when a user or movie is removed. Indexes cover the most frequent join and filter patterns (genre, user_id, movie_id, watch_date).

---

## Getting Started

### Requirements

- PostgreSQL 13+

## Queries

| # | Query | What it answers |
|---|-------|-----------------|
| 1 | Top-rated movies | Best movies by avg rating (min 3 ratings) |
| 2 | Most popular genres | Combined watch + rating popularity score |
| 3 | Collaborative filtering | Movies to recommend for a specific user |
| 4 | User behaviour | Per-user watch count, ratings, completion rate |
| 5 | Trending (30 days) | Movies gaining momentum recently |
| 6 | Genre affinity | Which genres each user gravitates toward |
| 7 | High drop-off movies | Started but rarely finished — a quality signal |
| 8 | Age-group preferences | Genre breakdown by user age segment |
| 9 | Unrated watches | Movies watched but never rated (nudge candidates) |
| 10 | Platform summary | Single-row dashboard snapshot |

---

## Recommendation Logic

The collaborative filter works in three steps:

1. **Find neighbours** — users who rated at least 2 of the same movies as the target user
2. **Score similarity** — cosine similarity between rating vectors (focuses on rating pattern, not magnitude)
3. **Aggregate candidates** — movies those neighbours rated ≥ 4.0 that the target hasn't seen, weighted by each neighbour's similarity score

This is a simplified but interpretable approach. The same query structure scales to window functions and materialised views in production, or feeds feature vectors into an ML layer.

---

## Extending This

A few directions this schema supports without breaking changes:

- **Multi-genre** — add a `movie_genres` junction table for many-to-many
- **Content-based filtering** — add `movie_tags` or embeddings, join on overlap
- **Real-time trending** — materialise `vw_trending_7d` and refresh it via a cron job or trigger
- **A/B testing** — add a `recommendation_logs` table to track which recommendations led to watches
- **Rating history** — remove the unique constraint on `(user_id, movie_id)` in ratings and add a `version` column to track how opinions change over time
