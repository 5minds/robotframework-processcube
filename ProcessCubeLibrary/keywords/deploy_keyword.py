
class DeployKeyword:

    def __init__(self, client, **kwargs):
        self._client = client

    def deploy_processmodel(self, pathname, exit_on_fail: bool = True, overwrite_existing: bool = True):
        self._client.process_defintion_deploy_by_pathname(pathname, exit_on_fail, overwrite_existing)
