from fastapi import FastAPI, Request

app = FastAPI()


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
    }
