#!/usr/bin/python3
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Devops is egreat"

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)