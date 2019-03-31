# credit to https://github.com/drhelius/docker-helloworld-python-microservice
from flask import Flask
from flask import request
import os
import socket
import json
import base64
import hashlib
import time
import numpy

app = Flask(__name__)

diagnoses = {
    '0': 'MEL',
    '1': 'MEL',
    '2': 'NV',
    '3': 'NV',
    '4': 'BCC',
    '5': 'BCC',
    '6': 'AKIEC',
    '7': 'AKIEC',
    '8': 'BKL',
    '9': 'BKL',
    'a': 'DF',
    'b': 'DF',
    'c': 'DF',
    'd': 'VASC',
    'e': 'VASC',
    'f': 'VASC'
}

diagnoses_detail = {
    'MEL': 'Melanoma',
    'NV': 'Melanocytic Nevus',
    'BCC': 'Basal Cell Carcinoma',
    'AKIEC': 'Actinic Keratosis',
    'BKL': 'Benign Keratosis',
    'DF': 'Dermatofibroma',
    'VASC': 'Vascular Lesion',
    'IN': 'Inconclusive'
}

def b64_to_jpg(b64_string):
    with open("img/" + str(time.time()).replace('.','') + ".jpg", "wb") as fh:
        fh.write(base64.decodebytes(b64_string.replace('data:image/jpeg;base64,','').encode("ascii")))

@app.route('/api/result', methods=['POST'])
def get_result():
    content = request.get_json()
    # model did not finish training in time, so mock the response
    hashstring = hashlib.md5(content["b64_image"].encode("ascii"))
    diag = diagnoses[hashstring.hexdigest()[-1:]]
    detail = diagnoses_detail[diag]
    confidence = numpy.random.randint(50,100)
    b64_to_jpg(content["b64_image"])
    print('diagnosis  = ' + diag)
    print('detail     = ' + detail)
    print('confidence = ' + str(confidence))
    return '{\
"diagnosis_code": "' + diag + '",\
"diagnosis_detail": "' + detail + '",\
"confidence": "' + str(confidence) + '"\
}' 

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
