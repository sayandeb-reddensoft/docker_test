from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return{"message": "Hello, World!"}

@app.get("/hello{name}")
def read_name(name: str):
    return {"message": f"Hello, {name}!"}

