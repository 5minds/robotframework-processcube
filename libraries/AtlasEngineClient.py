import asyncio
from atlas_engine_client import ClientFactory
from atlas_engine_client.core.api import Client
from atlas_engine_client.core.api.helpers.process_definitions import StartCallbackType
from atlas_engine_client.core.api.helpers.process_models import ProcessStartRequest

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
        self._client = Client(self._engine_url)

    def deploy_pathname(self, pathname):
        self._client.process_defintion_deploy_by_pathname(pathname)

    def get_engine_info(self):
        result = self._client.info()

        return result.__dict__ # Issue

    def start_processmodel(self, process_model, payload={}):

        request = ProcessStartRequest(
            process_model_id=process_model, 
            initial_token=payload, 
            return_on=StartCallbackType.CallbackOnProcessInstanceFinished)

        result = self._client.process_model_start(process_model, request)

        return result.to_dict()
