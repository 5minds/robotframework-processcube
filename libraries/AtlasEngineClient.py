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

    def __init__(self, engine_url):
        self._engine_url = engine_url

    def get_engine_info(self):
        factroy = ClientFactory()
        client = factroy.create_app_info_client(self._engine_url)

        result = client.get_info()

        return result

    def start_processmodel(self, process_model):
        factroy = ClientFactory()
        client = factroy.create_process_definition_client(self._engine_url)

        result = client.start_process_instance_and_await_end_event(process_model)

        return result
