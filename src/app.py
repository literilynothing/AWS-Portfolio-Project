# Run the Flask application
from flask import Flask

app = Flask(__name__)


@app.route('/')
def home():
    return "<h1>Hello, World!</h1><p>Deployment successful!</p>"

# Makes the application available on port 80
if __name__ == '__main__':
    app.run(host = '0.0.0.0', port=80)