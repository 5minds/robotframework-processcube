from atlas_engine_client.core.api import Client
from atlas_engine_client.core.api import StartCallbackType
from atlas_engine_client.core.api import ProcessStartRequest
class AtlasEngineClient:

    def __init__(self, engine_url):
        self._client = Client(engine_url)

    def deploy_process(self, pathname):
        self._client.process_defintion_deploy_by_pathname(pathname)

    def get_engine_info(self):
        result = self._client.info()

        return result.__dict__ # Issue

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

    def get_user_task_by_correlation(self, correlation_id):
        
        user_tasks = self._client.user_task_get(limit=1)

        if len(user_tasks) >= 1:
            user_task = user_tasks[0]
        else:
            user_task = {}

        return user_task

    def get_user_task(self, **kwargs):
        print(**kwargs)

        user_tasks = self._client.user_task_get(limit=1)

        if len(user_tasks) >= 1:
            user_task = user_tasks[0]
        else:
            user_task = {}

        return user_task
