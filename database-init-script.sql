-- initial script for the project "microblog"
-- author: Serafin Heier
-- group: 'microblog' (Finn Kronjäger, Alexander Stark, Serafin Heier)
-- this script is written for SQLITE3 for the usage of a SQLITE3 Database in Nodejs with the package 'better-sqlite3'
-- To run the script type in your shell:
-- directory of database.db and script.sql>> sqlite3 database.db < script.sql
-- if that does not work, try inside the database file in sqlite3:
-- sqlite3>> .read script.sql

-- deleting old tables to avoid errors:
DROP TABLE users;
DROP TABLE posts;
DROP TABLE follow;


CREATE TABLE users (
    userID INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR,
    pass VARCHAR,
    email VARCHAR
);

CREATE TABLE posts (
    userID INTEGER,
    content text,
    postDateTime integer, --datetime will be stored as integer (number of milliseconds since January 01, 1970)  This is how javascript handles it (more efficient, easier to handle and sort)
    CONSTRAINT fk_post_userID FOREIGN KEY (userID) REFERENCES users(userID)
);

CREATE TABLE follow (
    followerID INTEGER,
    followsID INTEGER,
    CONSTRAINT fk_followerID FOREIGN KEY (followerID) REFERENCES users(userID),
    CONSTRAINT fk_followsID FOREIGN KEY (followsID) REFERENCES users(userID),
    CONSTRAINT pk_follow PRIMARY KEY (followerID, followsID)
);

---------------------------------
-- Test data
-- the data here inserted is only for test purpose the passwords do not meet savety reqiurments
INSERT INTO users(username, pass, email) VALUES ('admin','$2b$10$Kv0AME6pXwS98MKLi94D4.vf/GCC.Er6k2veV.CvVMC2IkroUOSsu','admin@microblog.de'); --Password is 'sicher'
INSERT INTO users(username, pass, email) VALUES ('Serafin','$2b$10$7Q4UVN57X.E8GuBhrxorj.LZrfafEsljIQ4e.4qTPyUio5kRFedvC','heier.serafin@gmail.com'); --Password is 'Serafin0902'
INSERT INTO users(username, pass, email) VALUES ('Finn','$2b$10$nx5EKOV1M5v3vbzFB7JSi.HUmLhfSfJHF8Cxt1EbnUmA59E1jGn3W','finn.kronjäger@haw-hamburg.de'); --Password is 'Phynn1312'
INSERT INTO users(username, pass, email) VALUES ('Alex','$2b$10$/bvJnJeDGKeNm8CsH./.t.funcWN.75KzAP7deU6OqTwbdh1.wkjC','alexander.stark@haw-hamburg.de'); --Password is  'AlexaPlease1'
INSERT INTO users(username, pass, email) VALUES ('Maria','$2b$10$3/cDEzdXGdD9tKY4QN.gIuWUC7hag8t9tOcu5O3ZxsJcgt5RSFcsi','maria.musterfrau@haw-hamburg.de'); --Password is 'password'
INSERT INTO users(username, pass, email) VALUES ('Max','$2b$10$3/cDEzdXGdD9tKY4QN.gIuWUC7hag8t9tOcu5O3ZxsJcgt5RSFcsi','max.mustermann@haw-hamburg.de'); --Password is 'passwort'


INSERT INTO posts(userid, content, postdatetime)
VALUES (2, 'Das ist der allererste Post in der Datenbank.:) (DB-hardcoded)',1000);

-- don't forget brackets around the statement when you use inline SELECT!
INSERT INTO posts(
    userid,
    content,
    postdatetime
) VALUES (
    (SELECT userid FROM users WHERE username='Serafin'), 
    'zweiter Test-Post one hour later (DB-hardcoded)',
    2000
);

INSERT INTO posts(
    userid,
    content,
    postdatetime
) VALUES (
    3,
    'Finn möchte auch was posten (DB-hardcoded)',
    30405050
);

-- string concatenation test
INSERT INTO POSTS(
    USERID,
    CONTENT,
    POSTDATETIME
) VALUES (
    4,
    'alex auch und zwar um: '
        || (SELECT DATETIME('now', 'localtime')),
    347329847832
);

INSERT INTO posts(
    userid,
    content,
    postdatetime
) VALUES (
    2,
    'test :)',
    423432423432
);

-- how to use the DATE() function with unix timestamp: (less storage because it only stores one INTEGER)
-- CREATE TABLE posts (
--    userID INTEGER,
--    content TEXT,
--    postDateTime INTEGER, --INTEGER as Unix Time, the number of seconds since 1970-01-01 00:00:00 UTC. This tranformation will be made by the function Date()
--    CONSTRAINT fk_post_userID FOREIGN KEY (userID) REFERENCES users(userID)
-- );
-- SELECT unixepoch(); -- Computes the current unix timestamp.
-- SELECT datetime( (SELECT unixepoch()), 'unixepoch', 'localtime'); -- gibt die aktuelle Zeit im Format YYYY-MM-DD HH-MM-SS
-- INSERT INTO posts(userID, content, postDateTime) VALUES (2,"Das ist der allererste Post in der Datenbank.:) (DB-hardcoded)", SELECT unixepoch() );
-- INSERT INTO posts(userID, content, postDateTime) VALUES ( SELECT userID FROM users WHERE username="Serafin", "zweiter Test-Post (DB-hardcoded)", SELECT unixepoch());


INSERT INTO follow(followerID, followsID) VALUES (3,2); -- anmerkung für später: wir müssen bedenken dass man sich selbst nicht folgt, auf dem Feed aber auch die eigenen Posts sichtbar sein sollten.
INSERT INTO follow(followerID, followsID) VALUES (3,4);
INSERT INTO follow(followerID, followsID) VALUES (3,5);
INSERT INTO follow(followerID, followsID) VALUES (3,6);
INSERT INTO follow(followerID, followsID) VALUES (2,4);
INSERT INTO follow(followerID, followsID) VALUES (2,6);
INSERT INTO follow(followerID, followsID) VALUES (4,2);
INSERT INTO follow(followerID, followsID) VALUES (4,6);
INSERT INTO follow(followerID, followsID) VALUES (5,2);
INSERT INTO follow(followerID, followsID) VALUES (5,4);
INSERT INTO follow(followerID, followsID) VALUES (5,3);
INSERT INTO follow(followerID, followsID) VALUES (6,3);

-- negative tests: errors should occur:
-- for easier debuging try: .headers on
INSERT INTO follow(followerID, followsID) VALUES (5,5000123); -- not referencing existing user
-- TODO: komischer weise wird der Wert trotzdem eingefügt. das darf eigentlich nicht.

---------------------------
-- SELECTS:

-- all posts joined with username:
SELECT
    username,
    content,
    postdatetime
FROM
    posts
JOIN users ON posts.userID=users.userID;

-- are followed by 'Finn' 
SELECT followsID FROM follow WHERE followerID=3; -- 3 = userID from 'Finn'

-- followers from 'Serafin'
SELECT u.username
FROM users AS u
JOIN follow AS f ON u.userID=f.followerID
JOIN users AS u2 ON f.followsID=u2.userID WHERE u2.username='Serafin';


-- all post's from people followed by 'Alex' with userID=4
SELECT userID, content, postDateTime FROM posts
JOIN follow ON followsID=userID WHERE followerID=1
ORDER BY postDateTime DESC;

-- all posts from users followed by user1 + posts from user1
SELECT userID, content, postDateTime FROM posts
JOIN follow ON followsID=userID WHERE followerID=1
UNION
SELECT userID, content, postDateTime FROM posts WHERE userID=1;





