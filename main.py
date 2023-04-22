# Import what we need from flask
from flask import Flask

# Create a Flask app inside `app`
app = Flask(__name__)

# Assign a function to be called when the path `/` is requested
@app.route('/')
def index():
    #return 'Hello, this is my pretty application!'
    return render_template("index.html", title="Index")

@app.route('/final')
def final():
    return 'Whooooo this is the end of the Back-end Course!'
