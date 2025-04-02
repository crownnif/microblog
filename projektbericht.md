# Microblog
###### Projektbericht

[toc]

___



```mermaid
---
title: Microblog database
---
erDiagram

USERS {
integer id
varchar username
varchar password
varchar name
varchar email
}

FOLLOWS {
integer followerID
integer followsID
}


POSTS {
integer userID
text content
date postDateAndTime
}

CHATS {
integer chatID
integer userID1
integer userID2
}

MESSAGES {
integer messageID
integer chatID
integer author
integer mDateTime
text content
}

FOLLOWS ||--|{ USERS : uses
POSTS ||--|{ USERS : uses 
CHATS ||--|{ USERS : uses
MESSAGES ||--|{ USERS : uses
MESSAGES ||--|{ CHATS : uses 
```



___



## Finn Notizen

- 31.5. Fähigkeit, Posts zu schreiben (2 hrs)
- 2.6. Mehrere Bugfixes (1 hr)
- 2.6. first CSS (30 min)
- 4.6. weitere CSS gestaltung (3 hrs)





Besprechung 09.06:

- follow abfragen sql fertig machen
- Datenbank für chats anpassen
- Serafin: Diagramm Webstruktur
- Finn: APRG Projektbericht 1v
- Alex: Navigation final, und bissel polish evtl (Popup) 