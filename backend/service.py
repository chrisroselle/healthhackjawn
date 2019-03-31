# credit to https://github.com/drhelius/docker-helloworld-python-microservice
from flask import Flask
from flask import request
import os
import socket
import json
import base64

app = Flask(__name__)

def b64_to_jpg(b64_string):
    with open("test.jpg", "wb") as fh:
        fh.write(base64.decodebytes(b64_string.replace('data:image/jpeg;base64,','').encode("ascii")))
 

@app.route('/api/result', methods=['POST'])
def get_result():
    content = request.get_json()
    b64_to_jpg(content["b64_image"])
    return '{"emoji": "definitely poop"}'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
