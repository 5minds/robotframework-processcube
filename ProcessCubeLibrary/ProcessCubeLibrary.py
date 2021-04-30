from ctypes import ArgumentError
import time
from typing import Dict, Any

from atlas_engine_client.core.api import Client
from atlas_engine_client.core.api import FetchAndLockRequestPayload
from atlas_engine_client.core.api import FinishExternalTaskRequestPayload
from atlas_engine_client.core.api import FlowNodeInstancesQuery
from atlas_engine_client.core.api import FlowNodeInstanceResponse
from atlas_engine_client.core.api import MessageTriggerRequest
from atlas_engine_client.core.api import ProcessStartRequest
from atlas_engine_client.core.api import StartCallbackType
from atlas_engine_client.core.api import UserTaskQuery

from robot.api import logger

from .docker_handler import DockerHandler

class ProcessCubeLibrary:

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, **kwargs):
        self._engine_url = kwargs.get('engine_url', None)
        self._self_hosted_engine = kwargs.get('self_hosted_engine', None)
        self._docker_options = kwargs.get('docker_options', {})

        self._max_retries = kwargs.get('max_retries', 5)
        self._backoff_factor = kwargs.get('backoff_factor', 2)
        self._delay = kwargs.get('delay', 0.1)
        self._worker_id = kwargs.get('worker_id', "robot_framework")

        self._client = self._create_client()

    def _create_client(self):
        client = None

        if self._engine_url:
            client = Client(self._engine_url)
        elif self._self_hosted_engine == 'docker':
            logger.console(f"Starting engine within a docker container ...")
            self._docker_handler = DockerHandler(**self._docker_options)
            self._docker_handler.start()
            logger.console(f"Starting engine within a docker container ... done")
            
            engine_url = self._docker_handler.get_engine_url()

            client = Client(engine_url)
        else:
            raise ArgumentError("No 'engine_url' or 'self_hosted_engine' parameter provided.")

        return client

    def engine_shutdown(self):
        if self._docker_handler:
            self._docker_handler.shutown()

    def deploy_processmodel(self, pathname):
        self._client.process_defintion_deploy_by_pathname(pathname)

    def get_engine_info(self):
        info = self._client.info()

        return info

    def start_process_and_wait(self, process_model, payload={}):
        request = ProcessStartRequest(
            process_model_id = process_model,
            initial_token = payload,
            return_on = StartCallbackType.CallbackOnProcessInstanceFinished
        )

        result = self._client.process_model_start(process_model, request)

        return result

    def start_processmodel(self, process_model, payload={}):

        request = ProcessStartRequest(
            process_model_id = process_model,
            initial_token = payload,
            return_on = StartCallbackType.CallbackOnProcessInstanceCreated
        )

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

    def finish_user_task(self, user_task_instance_id: str, payload: Dict[str, Any]):
        self._client.user_task_finish(user_task_instance_id, payload)


    def get_external_task(self, topic: str, options: dict={}):

        request = FetchAndLockRequestPayload(
            worker_id = self._worker_id,
            topic_name = topic,
            max_tasks = 1
        )

        logger.info(f"get task with {request}")

        current_retry = 0
        current_delay = self._delay

        while True:
            external_tasks = self._client.external_task_fetch_and_lock(request)

            logger.info(external_tasks)

            if len(external_tasks) == 1:
                external_task = external_tasks[0]
            else:
                external_task = {}

            if external_task:
                break
            else:
                time.sleep(current_delay)
                current_retry = current_retry + 1
                current_delay = current_delay * self._backoff_factor
                if current_retry > self._max_retries:
                    break
                logger.info(
                    f"Retry count: {current_retry}; delay: {current_delay}")

        return external_task

    def finish_external_task(self, external_task_id: str, result: Dict[str, any]):
        request = FinishExternalTaskRequestPayload(
            worker_id = self._worker_id,
            result = result
        )

        logger.info(f"finish task with {request}")

        self._client.external_task_finish(external_task_id, request)

    def send_message(self, message_name: str, payload: Dict[str, Any]={}, **options):

        delay = options.get('delay', None)

        if delay:
            logger.info(f"Send message {message_name} with seconds {delay} delay.")
            time.sleep(float(delay))

        request = MessageTriggerRequest(
            payload=payload
        )

        self._client.events_trigger_message(message_name, request)

    def send_signal(self, signal_name, **options):
        
        delay = options.get("delay", None)

        if delay:
            logger.info(f"Send signal {signal_name} with {delay} seconds delay.")
            time.sleep(float(delay))

        self._client.events_trigger_signal(signal_name)


    def get_processinstance(self, **kwargs) -> FlowNodeInstanceResponse:

        query_dict = {
            'state': 'finished',
            'limit': 1,
            'flow_node_type': 'bpmn:EndEvent',
        }

        query_dict.update(**kwargs)

        current_retry = 0
        current_delay = self._delay

        while True:

            query = FlowNodeInstancesQuery(**query_dict)

            flow_node_instances = self._client.flow_node_instance_get(query)

            if len(flow_node_instances) == 1:
                flow_node_instance = flow_node_instances[0]
            else:
                flow_node_instance = {}

            if flow_node_instance:
                break
            else:
                time.sleep(current_delay)
                current_retry = current_retry + 1
                current_delay = current_delay * self._backoff_factor
                if current_retry > self._max_retries:
                    break
                logger.info(
                    f"Retry count: {current_retry}; delay: {current_delay}")

        return flow_node_instance

    def get_processinstance_result(self, **kwargs) -> Dict[str, Any]:
        result = self.get_processinstance(**kwargs)

        if result:
            payload = result.tokens[0]['payload']
        else:
            payload = {}

        return payload
