--s1
SELECT c.genre
FROM Comic c
JOIN Feedback f ON c.comic_id = f.comic_id
JOIN Reviewer r ON f.reviewer_id = r.reviewer_id
WHERE r.gender = 'female'
GROUP BY c.genre
HAVING COUNT(DISTINCT r.reviewer_id) > 
   (SELECT COUNT(DISTINCT reviewer_id) 
    FROM Feedback 
    WHERE comic_id = c.comic_id AND gender = 'male');


--s2
SELECT w.writer_id, w.name, SUM(f.rating) AS total_ratings
FROM Writer w
JOIN Comic c ON w.writer_id = c.writer_id
JOIN Feedback f ON c.comic_id = f.comic_id
GROUP BY w.writer_id, w.name
HAVING SUM(f.rating) > (
    SELECT AVG(rating)
    FROM Feedback
)
ORDER BY total_ratings DESC

