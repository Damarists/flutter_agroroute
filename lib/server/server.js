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
  if (!fs.existsSync(DB_FILE)) {
    fs.writeFileSync(DB_FILE, JSON.stringify({ users: [], shipments: [] }, null, 2));
  }
  return JSON.parse(fs.readFileSync(DB_FILE, 'utf8'));
}

function writeDB(data) {
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}

// Registro de usuario
app.post('/api/v1/auth/sign-up', (req, res) => {
  const { firstName, lastName, dni, birthDate, phoneNumber, email, password } = req.body;
  const db = readDB();
  if (db.users.find(u => u.email === email)) {
    return res.status(400).json({ message: 'Usuario ya existe' });
  }
  const newId = db.users.length > 0 ? db.users[db.users.length - 1].id + 1 : 1;
  db.users.push({ id: newId, firstName, lastName, dni, birthDate, phoneNumber, email, password });
  writeDB(db);
  res.status(201).json({ message: 'Usuario registrado' });
});

// Login
app.post('/api/v1/auth/sign-in', (req, res) => {
  const { email, password } = req.body;
  const db = readDB();
  const user = db.users.find(u => u.email === email && u.password === password);
  if (!user) {
    return res.status(401).json({ message: 'Credenciales inválidas' });
  }
  res.json({ message: 'Login exitoso', user });
});

// Registrar un envío (shipment) con paquetes y sensores
app.post('/api/v1/shipments', (req, res) => {
  const { trackingNumber, ownerId, destino, fecha, estado, ubicacion, paquetes } = req.body;
  if (!trackingNumber || !ownerId || !destino || !fecha || !paquetes || !Array.isArray(paquetes)) {
    return res.status(400).json({ message: 'Faltan campos requeridos' });
  }
  const db = readDB();
  db.shipments = db.shipments || [];
  const newId = db.shipments.length > 0 ? db.shipments[db.shipments.length - 1].id + 1 : 1;
  const shipment = { id: newId, trackingNumber, ownerId, destino, fecha, estado, ubicacion, paquetes };
  db.shipments.push(shipment);
  writeDB(db);
  res.status(201).json({ message: 'Envío registrado', id: newId });
});

app.get('/api/v1/users/:id', (req, res) => {
  const db = readDB();
  const user = db.users.find(u => u.id === Number(req.params.id));
  if (!user) return res.status(404).json({ message: 'Usuario no encontrado' });
  res.json(user);
});

// Obtener todos los envíos
app.get('/api/v1/shipments', (req, res) => {
  const db = readDB();
  res.json(db.shipments || []);
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));