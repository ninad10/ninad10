from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'This Python code is running on EKS !'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
