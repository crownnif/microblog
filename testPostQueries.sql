-- Initialize database with initDB.sql script
-- and insert Data with the testData.sql script

SELECT 'show all posts'; -- like a print("message")
SELECT * from posts;

SELECT 'show posts from people followed by serafin'; -- like a print("message")
SELECT userID, content, postDateTime FROM posts
JOIN follow ON followsID=userID WHERE followerID=1
ORDER BY postDateTime DESC;

SELECT 'show posts from people followed by serafin and posts form serafin';
SELECT userID, content, postDateTime FROM posts
JOIN follow ON followsID=userID WHERE followerID=1
UNION
SELECT userID, content, postDateTime FROM posts WHERE userID=1;