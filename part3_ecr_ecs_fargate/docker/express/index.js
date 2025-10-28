const express = require('express');
const app = express();

app.get('/', (req, res) => res.json({ message: "Hello from Express on port 3000" }));

app.listen(3000, '0.0.0.0', () => {
  console.log('Express running on port 3000');
});
