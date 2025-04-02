DROP TABLE users;
DROP TABLE posts;
DROP TABLE follow;
DROP TABLE chats;
DROP TABLE messages;

CREATE TABLE users (
    userID INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR,
    pass VARCHAR,
    email VARCHAR
);
SELECT "table USERS created";

CREATE TABLE posts (
    userID INTEGER,
    content text,
    postDateTime integer, --datetime will be stored as integer (number of milliseconds since January 01, 1970)  This is how javascript handles it (more efficient, easier to handle and sort)
    CONSTRAINT fk_post_userID FOREIGN KEY (userID) REFERENCES users(userID)
);
SELECT "table POSTS created";

CREATE TABLE follow (
    followerID INTEGER,
    followsID INTEGER,
    CONSTRAINT fk_followerID FOREIGN KEY (followerID) REFERENCES users(userID),
    CONSTRAINT fk_followsID FOREIGN KEY (followsID) REFERENCES users(userID),
    CONSTRAINT pk_follow PRIMARY KEY (followerID, followsID)
);
SELECT "table FOLLOW created";

CREATE TABLE chats (
    chatID INTEGER NOT NULL,
    userID1 INTEGER,
    userID2 INTEGER,
    CONSTRAINT fk_user1 FOREIGN KEY (userID1) REFERENCES users(userID),
    CONSTRAINT fk_user2 FOREIGN KEY (userID2) REFERENCES users(userID),
    CONSTRAINT chk_userIDs CHECK(userID1<userID2),
    CONSTRAINT PK_chats PRIMARY KEY (userID1, userID2)
);
SELECT "table CHATS created";
-- hier muss bei der dynamischen erzeugung von Daten aufgepasst werden, dass nicht 2 chats mit den selben Personen
-- nur in vertauschter Reihenfolge als user1 und user2 gibt.
-- IDEE Dazu: bei der erzeugung von chats, wird immer der user mit der kleineren userID als user1 eingesetzt

CREATE TABLE messages (
    messageID INTEGER PRIMARY KEY AUTOINCREMENT, -- zu speicher-/ rechenaufwändig bei viel Nachrichtenverkehr? evtl lieber ein zusammengesetzen PK aus den anderen werten attributen machen?
    chatID INTEGER,
    author INTEGER,
    mDateTime INTEGER,
    content TEXT,
    CONSTRAINT fk_chats_chatID FOREIGN KEY (chatID) REFERENCES chats(chatID),
    CONSTRAINT fk_chats_author FOREIGN KEY (author) REFERENCES users(userID)
);
SELECT "table MESSAGES created";