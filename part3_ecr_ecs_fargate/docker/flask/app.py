from flask import Flask, jsonify
app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"status": "ok", "message": "Flask root path healthy"}), 200

@app.route("/api/")
def hello_api():
    return jsonify({"message": "Hello from Flask on port 5000"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
