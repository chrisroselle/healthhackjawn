# credit to https://github.com/drhelius/docker-helloworld-python-microservice
from flask import Flask
from flask import request
import os
import socket

app = Flask(__name__)

@app.route('/api/test', methods=['POST'])
def get_result():
    content = request.get_json()
    print(content)
    return 'test'

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080, debug=True)
