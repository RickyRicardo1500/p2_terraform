from flask import Flask
import os
import redis

app = Flask(__name__)

@app.get("/")
def home():
    return {
        "message": "Backend is running!",
        "redis_status": check_redis()
    }

def check_redis():
    redis_host = os.environ.get("REDIS_HOST", "redis")
    try:
        r = redis.Redis(host=redis_host, port=6379)
        r.ping()
        return "connected"
    except Exception as e:
        return f"not connected: {e}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
