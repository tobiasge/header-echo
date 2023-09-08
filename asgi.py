import socket

from fastapi import FastAPI, Request,HTTPException

app = FastAPI()

@app.get("/errors/{response_code}/{message}")
@app.put("/errors/{response_code}/{message}")
@app.post("/errors/{response_code}/{message}}")
@app.delete("/errors/{response_code}/{message}")
async def index(request: Request, response_code: str, message: str):

    raise HTTPException(status_code=int(response_code), detail=message)


@app.get("/{full_path:path}")
@app.put("/{full_path:path}")
@app.post("/{full_path:path}")
@app.delete("/{full_path:path}")
async def index(request: Request, full_path: str):
    return {
        "full_path": f"/{full_path}",
        "method": request.method,
        "params": request.query_params,
        "headers": request.headers,
        "body": await request.body(),
        "server": socket.gethostname(),
    }
