-- initalze database with initDB.sql script
INSERT INTO users(username, pass, email) VALUES ('Serafin','$2b$10$7Q4UVN57X.E8GuBhrxorj.LZrfafEsljIQ4e.4qTPyUio5kRFedvC','heier.serafin@gmail.com'); --Password is 'Serafin0902'
INSERT INTO users(username, pass, email) VALUES ('Finn','$2b$10$nx5EKOV1M5v3vbzFB7JSi.HUmLhfSfJHF8Cxt1EbnUmA59E1jGn3W','finn.kronjäger@haw-hamburg.de'); --Password is 'Phynn1312'
INSERT INTO users(username, pass, email) VALUES ('Alex','$2b$10$/bvJnJeDGKeNm8CsH./.t.funcWN.75KzAP7deU6OqTwbdh1.wkjC','alexander.stark@haw-hamburg.de'); --Password is  'AlexaPlease1'
INSERT INTO users(username, pass, email) VALUES ('Maria','$2b$10$3/cDEzdXGdD9tKY4QN.gIuWUC7hag8t9tOcu5O3ZxsJcgt5RSFcsi','maria.musterfrau@haw-hamburg.de'); --Password is 'password'
INSERT INTO users(username, pass, email) VALUES ('Max','$2b$10$3/cDEzdXGdD9tKY4QN.gIuWUC7hag8t9tOcu5O3ZxsJcgt5RSFcsi','max.mustermann@haw-hamburg.de'); --Password is 'passwort'

INSERT INTO posts(userid, content, postdatetime) VALUES (2, 'post 1 von Finn',(SELECT DATETIME('now', 'localtime')));
INSERT INTO posts(userid, content, postdatetime) VALUES (3, 'post 1 von Alex',(SELECT DATETIME('now', 'localtime')));
INSERT INTO posts(userid, content, postdatetime) VALUES (2, 'post 2 von Finn',(SELECT DATETIME('now', 'localtime')));
INSERT INTO posts(userid, content, postdatetime) VALUES (1, 'post 1 von Serafin',(SELECT DATETIME('now', 'localtime')));

INSERT INTO follow (followerID,followsID) VALUES (1,2); -- serafin --> finn
INSERT INTO follow (followerID,followsID) VALUES (1,3); -- serafin --> alex
INSERT INTO follow (followerID,followsID) VALUES (1,5); -- Serafin --> Max
INSERT INTO follow (followerID,followsID) VALUES (2,3); -- finn --> alex


INSERT INTO chats (chatID, userID1, userID2) VALUES ( (SELECT IFNULL(MAX(chatID), 0) + 1 FROM chats), 1, 2); -- serafin & finn
INSERT INTO chats (chatID, userID1, userID2) VALUES ( (SELECT IFNULL(MAX(chatID), 0) + 1 FROM chats), 2, 3); -- finn & alex
INSERT INTO chats (chatID, userID1, userID2) VALUES ( (SELECT IFNULL(MAX(chatID), 0) + 1 FROM chats), 1, 3); -- serafin & finn

INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=2), 1, (SELECT DATETIME('now','localtime','-3 days')), 'Nachricht 1');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=2), 1, (SELECT DATETIME('now','localtime','-2 days')), 'Nachricht 2');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=2), 1, (SELECT DATETIME('now','localtime','-1 days')), 'Nachricht 3');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=2), 1, (SELECT DATETIME('now','localtime')), 'Nachricht 4');

INSERT INTO messages (chatID, author, mDateTime, content) VALUES (1, 1, (SELECT DATETIME('now','localtime')), 'Hallo Finn, LG Serafin');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=2 AND userID2=3), 3, (SELECT DATETIME('now','localtime')), 'Hallo Alex, LG Finn');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=2), 3, (SELECT DATETIME('now','localtime')), 'Hallo zurück Serafin, LG Finn');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=2), 3, (SELECT DATETIME('now','localtime')), 'Nachricht 2 von Finn an Serafin');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=2), 1, (SELECT DATETIME('now','localtime')), 'Nachricht 2 von Serafin an Finn');

INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=3), 1, (SELECT DATETIME('now','localtime')), 'Nachricht 1 von Serafin an Alex');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=3), 1, (SELECT DATETIME('now','localtime')), 'Nachricht 2 von Serafin an Alex');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=3), 1, (SELECT DATETIME('now','localtime')), 'Nachricht 1.1 von Alex an Serafin');
INSERT INTO messages (chatID, author, mDateTime, content) VALUES ( (SELECT chatID FROM chats WHERE userID1=1 AND userID2=3), 1, (SELECT DATETIME('now','localtime')), 'Nachricht 2.1 von Alex an Serafin');

SELECT "TESTDATEN WURDEN EINGEFUEGT";