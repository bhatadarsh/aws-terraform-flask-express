#!/bin/bash
sudo apt update -y
sudo apt install -y python3 python3-venv python3-pip
mkdir -p /opt/apps/flask
cd /opt/apps/flask
python3 -m venv venv
source venv/bin/activate
pip install flask
cat <<EOF > app.py
from flask import Flask
app = Flask(__name__)
@app.route('/')
def home():
    return "Hello from Flask on port 5000!"
app.run(host='0.0.0.0', port=5000)
EOF
nohup /opt/apps/flask/venv/bin/python /opt/apps/flask/app.py > /var/log/flask.log 2>&1 &
