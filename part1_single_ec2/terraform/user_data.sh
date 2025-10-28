#!/bin/bash
set -e

# Update & install
apt update -y
apt install -y python3 python3-venv python3-pip nodejs npm

# App directories
mkdir -p /opt/apps/flask
mkdir -p /opt/apps/express

# Kill old Flask if exists
fuser -k 5000/tcp || true

# Flask venv
python3 -m venv /opt/apps/flask/venv
/opt/apps/flask/venv/bin/pip install --upgrade pip
/opt/apps/flask/venv/bin/pip install flask

# Flask app
cat > /opt/apps/flask/app.py <<'PY'
from flask import Flask, jsonify
app = Flask(__name__)
@app.route('/')
def hello():
    return jsonify({"message": "Hello from Flask on port 5000"})
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PY

# Express app
cat > /opt/apps/express/index.js <<'JS'
const express = require('express');
const app = express();
app.get('/', (req, res) => { res.json({message: "Hello from Express on port 3000"}); });
app.listen(3000, '0.0.0.0');
JS

cat > /opt/apps/express/package.json <<'PJ'
{
  "name": "simple-express",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "express": "^4.18.2"
  }
}
PJ

# Start Flask & Express in background
nohup /opt/apps/flask/venv/bin/python /opt/apps/flask/app.py > /opt/apps/flask/flask.log 2>&1 &
cd /opt/apps/express
npm install
nohup node index.js > /opt/apps/express/express.log 2>&1 &
