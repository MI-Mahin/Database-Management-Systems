CREATE VIEW ComicInformations AS
SELECT c.comic_id, c.comic_title, c.genre, c.no_of_characters, c.summary,
       COUNT(f.rating) AS number_of_ratings,
       NVL(AVG(f.rating), 0) AS average_rating
FROM Comic c
LEFT JOIN Feedback f ON c.comic_id = f.comic_id
GROUP BY c.comic_id, c.comic_title, c.genre, c.no_of_characters, c.summary;
