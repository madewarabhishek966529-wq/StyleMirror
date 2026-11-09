import sys
import asyncio
sys.path.insert(0, 'backend')
from app.main import app
import httpx
from httpx import ASGITransport

async def main():
    transport = ASGITransport(app=app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
        print("F: sending GET /health")
        r = await client.get("/health")
        print("G: status:", r.status_code, r.json())
        r2 = await client.get("/v1/styles")
        print("H: styles status:", r2.status_code, "count:", len(r2.json()))

if __name__ == "__main__":
    asyncio.run(main())
