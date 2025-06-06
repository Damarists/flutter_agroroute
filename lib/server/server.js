const express = require('express');
const fs = require('fs');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

const path = require('path');
const DB_FILE = path.join(__dirname, 'db.json');

function readDB() {
  return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
}

function writeDB(data) {
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}

// Register
app.post('/register', (req, res) => {
  const { email, password, firstName, lastName, phone, empresa, terms } = req.body;
  const db = readDB();
  if (db.users.find(u => u.email === email)) {
    return res.status(400).json({ message: 'Usuario ya existe' });
  }
  // Generar id autoincremental
  const newId = db.users.length > 0 ? db.users[db.users.length - 1].id + 1 : 1;
  db.users.push({ id: newId, email, password, firstName, lastName, phone, empresa, terms });
  writeDB(db);
  res.json({ message: 'Usuario registrado' });
});

// Login
app.post('/login', (req, res) => {
  const { email, password } = req.body;
  const db = readDB();
  const user = db.users.find(u => u.email === email && u.password === password);
  if (!user) {
    return res.status(401).json({ message: 'Credenciales inválidas' });
  }
  res.json({ message: 'Login exitoso', user });
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));