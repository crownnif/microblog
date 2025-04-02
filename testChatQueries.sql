-- Initialize database with initDB.sql script
-- and insert Data with the testData.sql script

SELECT "all chats:";
SELECT * FROM chats;

SELECT "all messages:";
SELECT * FROM messages;

SELECT "all chats where user1 is part of"; -- for chat overview
SELECT chatID FROM chats
WHERE userID1=1 OR userID2=1;

SELECT "last message from certain chat (e.g chatID 1)";
SELECT MAX(messageID), content FROM messages
WHERE chatID=1;


SELECT "all messages within the chat of Finn and Serafin:"; -- userID (Serafin) = 1, userID (Finn) = 2
SELECT * FROM messages AS m
JOIN chats AS c ON m.chatID=c.chatID
WHERE c.userID1=1 AND c.userID2=2;

SELECT "all messages within the chat of user1 and user2 which aren't older that two days"; -- could maybe be useful to not have to load all messages if the chat is very long
SELECT * FROM (
    SELECT * FROM messages AS m
    JOIN chats AS c ON m.chatID=c.chatID
    WHERE c.userID1=1 AND c.userID2=2
) WHERE mDateTime > (SELECT DATETIME('now','localtime','-2 days'));