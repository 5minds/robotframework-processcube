import docker


class DockerHandler:

    IMAGE_NAME = '5minds/atlas_engine_fullstack_server'

    def __init__(self, auto_remove=True):
        self._client = docker.from_env()
        self._api_client = docker.APIClient()
        self._name = 'robot_framework-atlas_engine'
        self._auto_remove = auto_remove

    def start(self):
        args = {
            'detach': True, 
            'publish_all_ports': True,
            'name': self._name,
            'auto_remove': self._auto_remove,
        }

        if self.find_container():
            if self._container.status == 'exited':
                self._container.restart()
        else:
            self._container = self._client.containers.run(DockerHandler.IMAGE_NAME, **args)

        attr = self._api_client.inspect_container(self._container.id)
        key = '8000/tcp'

        self._port = attr['NetworkSettings']['Ports'][key][0]['HostPort']

    def find_container(self):
        containers = self._client.containers.list(all=True, filters={'name': self._name})

        if len(containers) > 0:
            self._container = containers[0]
            found = True
        else:
            found = False

        return found

    def shutown(self, prune=False):
        self._container.stop()

        if prune:
            self._client.containers.prune()


    def report(self):
        print(f"container id: {self._container.id}")
        print(f"container attr: {self._port}")


def main():
    handler = DockerHandler()

    handler.start()
    handler.report()
    handler.shutown()

if __name__ == '__main__':
    main()