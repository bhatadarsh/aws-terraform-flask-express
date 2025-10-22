#!/bin/bash
# Update system
sudo yum update -y

# Install Python 3 and pip
sudo yum install -y python3 python3-pip

# Install Node.js 18 (from NodeSource)
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Create app directories
sudo mkdir -p /opt/apps/flask /opt/apps/express
sudo chmod -R 777 /opt/apps

# Flask app
cat <<EOF > /opt/apps/flask/app.py
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return "Hello from Flask on AWS EC2!"
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Express app
cat <<EOF > /opt/apps/express/index.js
const express = require('express');
const app = express();
const port = 3000;
app.get('/', (req, res) => res.send('Hello from Express on AWS EC2!'));
app.listen(port, '0.0.0.0', () => console.log(\`Express running on port \${port}\`));
EOF

# Start Flask and Express apps
nohup python3 /opt/apps/flask/app.py > /var/log/flask.log 2>&1 &
nohup node /opt/apps/express/index.js > /var/log/express.log 2>&1 &
