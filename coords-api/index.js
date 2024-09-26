const express = require('express');
const connection = require('./config');

const app = express();
app.use(express.json());

// Route to get all records
app.get('/coords', (req, res) => {
  connection.query('SELECT * FROM coords_data', (error, results) => {
    if (error) throw error;
    res.json(results);
  });
});

// Route to get a single record by ID
app.get('/coords/:id', (req, res) => {
  const { id } = req.params;
  connection.query('SELECT * FROM coords_data WHERE id = ?', [id], (error, results) => {
    if (error) throw error;
    res.json(results[0]);
  });
});

// Route to create a new record
app.post('/coords', (req, res) => {
  const { notes, lat, lng } = req.body;
  const created_at = new Date();
  const updated_at = new Date();
  connection.query(
    'INSERT INTO coords_data (notes, lat, lng, created_at, updated_at) VALUES (?, ?, ?, ?, ?)',
    [notes, lat, lng, created_at, updated_at],
    (error, results) => {
      if (error) throw error;
      res.json({ id: results.insertId, ...req.body });
    }
  );
});

// Route to update an existing record
app.put('/coords/:id', (req, res) => {
  const { id } = req.params;
  const { notes, lat, lng } = req.body;
  const updated_at = new Date();
  connection.query(
    'UPDATE coords_data SET notes = ?, lat = ?, lng = ?, updated_at = ? WHERE id = ?',
    [notes, lat, lng, updated_at, id],
    (error, results) => {
      if (error) throw error;
      res.json({ message: 'Record updated successfully' });
    }
  );
});

// Route to delete a record
app.delete('/coords/:id', (req, res) => {
  const { id } = req.params;
  connection.query('DELETE FROM coords_data WHERE id = ?', [id], (error, results) => {
    if (error) throw error;
    res.json({ message: 'Record deleted successfully' });
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});



//l63lsNp4prTrrv