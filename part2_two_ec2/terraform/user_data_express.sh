#!/bin/bash
set -e

# Update system
apt update -y
apt install -y nodejs npm

# Create app directory
mkdir -p /opt/apps/express
cd /opt/apps/express

# Write Express app
cat > index.js <<'JS'
const express = require('express');
const app = express();
app.get('/', (req, res) => {
  res.json({ message: "Hello from Express on port 3000" });
});
app.listen(3000, '0.0.0.0', () => {
  console.log('Express app running on port 3000');
});
JS

# Write package.json
cat > package.json <<'PJ'
{
  "name": "simple-express",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "express": "^4.18.2"
  }
}
PJ

# Install dependencies
npm install

# Start app in background
nohup node index.js > /opt/apps/express/express.log 2>&1 &
