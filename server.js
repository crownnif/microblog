// Server-Konfiguration

//Initialisierung Express.js
const express = require("express");
const app = express();
app.use(express.urlencoded({ extended: true }));

//Initialisierung cookie-parser
const cookieParser = require("cookie-parser");
app.use(cookieParser());

//Initialisierung Body-Parser
const bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: true }));

//Initialisierung von EJS
app.engine(".ejs", require("ejs").__express);
app.set("view engine", "ejs");

//Initialisierung express-session
const session = require("express-session");
app.use(
  session({
    secret: "example",
    saveUninitialized: false,
    resave: false,
  })
);

//Initialisierung bcrypt
const bcrypt = require("bcrypt");

//Initialisierung der Datenbank
const DATABASE = "database.db";
let db = require("better-sqlite3")(DATABASE);

//Initialisierung Sweet-Alert (Pop-Up)
const Swal = require("sweetalert2");

//freigabe ordner
app.use(express.static(__dirname + "/public/images"));
app.use(express.static(__dirname + "/css"));
app.use(express.static(__dirname + "/fonts"));

//Server Starten
app.listen(3000, function () {
  console.log("listining on Port 3000");
});

//GET-Requests
app.get("/", (req, res) => {
  res.redirect("/start");
});

app.get("/start", (req, res) => {
  loggingIN = parseInt(req.cookies["loggingIN"]);
  loggingOUT = parseInt(req.cookies["loggingOUT"]);
  registered = parseInt(req.cookies["registered"]);
  res.cookie("loggingIN", 1);
  res.cookie("loggingOUT", 1);
  res.cookie("registered", 1);

  showPosts(req, res);
});

app.get("/login", function (req, res) {
  const nameerrors = [];
  const passerrors = [];
  res.render("login", { nameerrors, passerrors });
});

app.get("/register", function (req, res) {
  const nameerrors = [];
  const passerrors = [];
  res.render("register", { nameerrors, passerrors });
});

app.get("/newPost", (req, res) => {
  username = req.session["sessionValue"];
  res.render("newPost", { username });
});

app.get("/signOff", (req, res) => {
  req.session.destroy();
  res.cookie("loggingOUT", 0);
  res.redirect("start");
});

app.get("/profile", (req, res) => {
  const sessionValue = req.session["sessionValue"];
  const stmt = db
    .prepare("SELECT username,email FROM users WHERE userID = ?")
    .get(sessionValue);
  const rows = getPostsByUser(sessionValue);
  res.render("profile", { rows, sessionValue, stmt });
});

app.get("/userList", (req, res) => {
  const allUser = db.prepare("SELECT userID, username from users").all();
  const follows = db
    .prepare(
      `SELECT followsID FROM follow WHERE followerID=${req.session.sessionValue}`
    )
    .all();
  console.log(allUser);
  console.log(follows);
  res.render("userList", { allUser, follows });
});

app.get("/chat", (req, res) => {
  app.render("chat", { chat, messages, profile });
});

//POST-Requests
//

//Login-Versuch: Verarbeitet die Login-Daten und validiert den Benutzer
app.post("/loginAttempt", function (req, res) {
  const param_user = req.body.user;
  const param_password = req.body.password;
  let nameerrors = [];
  let passerrors = [];

  const userindatabase = db
    .prepare("SELECT * FROM users WHERE username = ?")
    .get(param_user);

  if (userindatabase == undefined) {
    nameerrors.push("Nutzername nicht bekannt");
  } else if (bcrypt.compareSync(param_password, userindatabase.pass)) {
    req.session["sessionValue"] = userindatabase.userID;
    req.session["username"] = param_user;
    res.cookie("loggingIN", 0);
    res.redirect("start"); // Redirect statt Render, um den Kontrollfluss zu vereinheitlichen

    return;
  } else {
    passerrors.push("Passwort falsch");
  }

  res.render("login", { nameerrors, passerrors });
});

// Benutzer folgen: Fügt einen Eintrag in die Follow-Tabelle hinzu
app.post("/followUser", (req, res) => {
  const myUserID = req.session.sessionValue;
  const param_userID = req.body.userID;
  const stmt = db.prepare(
    "INSERT INTO follow (followerID, followsID) VALUES (?,?)"
  );
  const info = stmt.run(myUserID, param_userID); // einfügen der Daten in DB
  res.redirect("/userList");
});

// Benutzer entfolgen: Löscht einen Eintrag aus der Follow-Tabelle
app.post("/unfollowUser", (req, res) => {
  const myUserID = req.session.sessionValue;
  const param_userID = req.body.userID;
  const stmt = db.prepare(
    "DELETE FROM follow WHERE followerID=? AND followsID=?"
  );
  const info = stmt.run(myUserID, param_userID);
  res.redirect("userList");
});

// Neue Benutzerregistrierung: Verarbeitet die Registrierungsdaten und fügt den Benutzer zur Datenbank hinzu
app.post("/newUser", function (req, res) {
  const param_user = req.body.user;
  const param_password = req.body.password;
  const param_passwordRepeated = req.body.passwordRepeated;
  const param_email = req.body.email;
  const SALT_ROUNDS = 5;

  const passerrors = testPassword(param_password, param_passwordRepeated);
  const nameerrors = [];

  if (/\s/.test(param_email)) {
    nameerrors.push("email enthält Leerzeichen");
  }

  if (/\s/.test(param_user)) {
    nameerrors.push(
      "Nutzername enthält Leerzeichen, das ist nicht zugelassen."
    );
  }

  //Prüft, ob Nutzer existiert
  //Dient hier um eine doppelte Registrierung auzuschließen
  const userindatabase = db
    .prepare("SELECT * FROM users WHERE username = ?")
    .get(param_user);

  if (userindatabase != undefined) {
    // undefined => no user with that username in data
    nameerrors.push(`Nutzername ''${param_user}'' existiert bereits `);
  }

  //Fehlerbehandlung
  if (nameerrors.length + passerrors.length > 0) {

    res.render("register", { nameerrors, passerrors });
  } else {
    //keine Fehler aufgetreten
    //User-Passwort-Kombi wird verschlüsselt in die Datenbank aufgenommen, der Nutzer wird auf die Welcome-Page weitergeleitet
    bcrypt.hash(param_password, SALT_ROUNDS, (err, hash) => {
      const info = db
        .prepare("INSERT INTO users (username, pass, email) VALUES (?,?,?)")
        .run(param_user, hash, param_email);
    });
    res.cookie("registered", 0);
    res.redirect("start");
  }
});

// Neuen Post hinzufügen: Fügt einen neuen Post zur Datenbank hinzu
app.post("/addPost", (req, res) => {
  const sessionValue = req.session["sessionValue"];
  addPost(sessionValue, req.body.content);
  res.redirect("/start");
});

//
// Hilfsfunktionen -------------
//

// Funktion zum Anzeigen von Posts
function showPosts(req, res) {
  const sessionValue = req.session["sessionValue"];
  //same as /start
  const stmt = db.prepare(
    "SELECT username, content, postDateTime FROM posts JOIN users ON posts.userID=users.userID ORDER BY postdatetime DESC;"
  );
  const rows = stmt.all();

  let chats = [];
  let profiles = [];
  if (sessionValue != null) {
    chats = getChatsByUser(sessionValue);
    profiles = getProfiles(
      chats.map((chat) => {
        return chat.userID2;
      })
    );
  }

  res.render("start", { rows, sessionValue, chats, profiles, __dirname });
}

//Data Functions

function getPostsByUser(userID) {
  const stmt = db.prepare(
    "SELECT username, content, postDateTime FROM posts JOIN users ON posts.userID=users.userID WHERE users.userID = ? ORDER BY postdatetime DESC;"
  );
  return stmt.all(userID);
}

function getChatsByUser(userID) {
  const stmt = db.prepare(
    "SELECT chatID, userID1, userID2 FROM chats WHERE userID1 = ? OR userID2 = ?;"
  );
  const chats = stmt.all(userID, userID);

  return chats.map((obj) => {
    //userID1 is always current user
    if (obj.userID2 == userID) {
      obj.userID2 = obj.userID1;
      obj.userID1 = userID;
    }
    return obj;
  });
}

function getProfiles(userIDs) {
  const stmt = db.prepare("SELECT username, userID FROM users;");
  const profiles = stmt.all();

  return profiles.filter((profile) => {
    return userIDs.includes(profile.userID);
  });
}

function getChatMessages(chatID) { }

//hilfsfunktion fuer Uebersichtlichkeits
function testPassword(pass, passrepeated) {
  param_password = pass;
  param_passwordRepeated = passrepeated;
  const errors = [];
  if (/\s/.test(param_password)) {
    errors.push("Passwort enthält Leerzeichen, das ist nicht zugelassen.");
  }
  if (!/\d/.test(param_password)) {
    errors.push("Passwort enthält keine Zahl.");
  }
  if (param_password.length < 8) {
    errors.push("Passwort ist zu kurz (mind. 8 Stellen)");
  }
  if (param_password != param_passwordRepeated) {
    errors.push("Passwörter stimmen nicht überein");
  }
  return errors;
}

function addPost(sessionValue, content) {
  const stmt = db.prepare(
    "INSERT INTO posts (userID, content, postDateTime) VALUES (?, ?, ?);"
  );
  stmt.run(sessionValue, content, Date.now()); //Date is in milliseconds for now
}
