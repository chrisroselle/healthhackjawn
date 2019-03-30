# credit to https://github.com/drhelius/docker-helloworld-python-microservice
from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route('/api/test')
def get_result():
    return 'test'

if __name_ "__main__":
    app.run(host="52.14.190.7", port=8080, debug=True)
