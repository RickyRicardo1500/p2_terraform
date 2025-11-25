from flask import Flask
app = Flask(__name__)

@app.get("/")
def index():
    return {"message": "Backend running!"}

app.run(host="0.0.0.0", port=5000)
