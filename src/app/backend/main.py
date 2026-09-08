from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from pathlib import Path
from starlette.routing import Route

from lightbulb import lightbulb, Color
from mcp_server import mcp

# Build the MCP Starlette app (lazily creates the session manager)
mcp_app = mcp.streamable_http_app()


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with mcp.session_manager.run():
        yield


app = FastAPI(title="Foundry Agents 150 - Lightbulb", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["mcp-session-id"],
)

# Add MCP route directly (avoids Mount's trailing-slash redirect)
mcp_route = mcp_app.routes[0]
app.router.routes.insert(0, Route("/mcp", endpoint=mcp_route.endpoint))


class ColorRequest(BaseModel):
    color: str


@app.get("/api/lightbulb")
async def get_lightbulb():
    return lightbulb.to_dict()


@app.post("/api/lightbulb/toggle")
async def toggle_lightbulb():
    lightbulb.toggle()
    return lightbulb.to_dict()


@app.post("/api/lightbulb/color")
async def set_lightbulb_color(request: ColorRequest):
    try:
        color = Color(request.color.lower())
    except ValueError:
        valid = [c.value for c in Color]
        return {"error": f"Invalid color. Valid colors: {valid}"}
    lightbulb.set_color(color)
    return lightbulb.to_dict()


# Serve React static files if the build exists
static_dir = Path(__file__).parent / "static"
if static_dir.exists():
    app.mount("/assets", StaticFiles(directory=static_dir / "assets"), name="assets")

    @app.get("/{full_path:path}")
    async def serve_frontend(full_path: str):
        file_path = static_dir / full_path
        if file_path.exists() and file_path.is_file():
            return FileResponse(file_path)
        return FileResponse(static_dir / "index.html")
