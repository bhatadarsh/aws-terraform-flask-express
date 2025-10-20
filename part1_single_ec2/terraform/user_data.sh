#!/bin/bash
set -e

# update and install
yum update -y
amazon-linux-extras install -y python3 nodejs nginx

# install pip packages
python3 -m pip install --upgrade pip
python3 -m pip install flask

# create app directory
mkdir -p /opt/apps/flask
mkdir -p /opt/apps/express

# write a minimal Flask app
cat > /opt/apps/flask/app.py <<'PY'
from flask import Flask, jsonify
app = Flask(__name__)
@app.route('/')
def hello():
    return jsonify({"message": "Hello from Flask on port 5000"})
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PY

# write requirements (optional)
cat > /opt/apps/flask/requirements.txt <<'R'
flask
R

# write express app
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

# start Flask and Express in background using nohup
nohup python3 /opt/apps/flask/app.py > /var/log/flask.log 2>&1 &
cd /opt/apps/express
npm install
nohup node index.js > /var/log/express.log 2>&1 &
