import time

from atlas_engine_client.core.api import Client
from atlas_engine_client.core.api import StartCallbackType
from atlas_engine_client.core.api import ProcessStartRequest
from atlas_engine_client.core.api import UserTaskQuery

from robot.api import logger


class AtlasEngineClient:

    def __init__(self, engine_url, **kwargs):
        self._client = Client(engine_url)

        self._max_retries = kwargs.get('max_retries', 5)
        self._backoff_factor = kwargs.get('backoff_factor', 2)
        self._delay = kwargs.get('delay', 0.1)

    def deploy_process(self, pathname):
        self._client.process_defintion_deploy_by_pathname(pathname)

    def get_engine_info(self):
        result = self._client.info()

        return result.__dict__  # Issue

    def start_process_and_wait(self, process_model, payload={}):
        request = ProcessStartRequest(
            process_model_id=process_model,
            initial_token=payload,
            return_on=StartCallbackType.CallbackOnProcessInstanceFinished)

        result = self._client.process_model_start(process_model, request)

        return result

    def start_process(self, process_model, payload={}):

        request = ProcessStartRequest(
            process_model_id=process_model,
            initial_token=payload,
            return_on=StartCallbackType.CallbackOnProcessInstanceCreated)

        result = self._client.process_model_start(process_model, request)

        return result

    def get_user_task_by(self, **kwargs):

        logger.debug(kwargs)

        query = UserTaskQuery(**kwargs)

        logger.info(query)

        current_retry = 0
        current_delay = self._delay

        while True:
            user_tasks = self._client.user_task_get(query)

            logger.info(user_tasks)

            if len(user_tasks) >= 1:
                user_task = user_tasks[0]
            else:
                user_task = {}

            if user_task:
                break
            else:
                time.sleep(current_delay)
                current_retry = current_retry + 1
                current_delay = current_delay * self._backoff_factor
                if current_retry > self._max_retries:
                    break
                logger.info(
                    f"Retry count: {current_retry}; delay: {current_delay}")

        return user_task
