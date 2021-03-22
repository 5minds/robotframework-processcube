import asyncio
from atlas_engine_client import ClientFactory

from robot.api import logger


def sync_wait(self, future):
    future = asyncio.tasks.ensure_future(future, loop=self)
    while not future.done() and not future.cancelled():
        self._run_once()
        if self._stopping:
            break
    return future.result()

class AtlasEngineClient:

    def get_engine_info(self):
        engine_url = "http://localhost:56200"

        factroy = ClientFactory()
        client = factroy.create_app_info_client(engine_url)

        result = client.get_info()

        return result