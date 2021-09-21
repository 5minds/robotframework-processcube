# Verwendung des Robot Framework mit der 5Minds-Engine

- [Voraussetzung](#voraussetzung)
- [Verwendung](#verwendung)
  * [BPMN-Datei installieren](#bpmn-datei-installieren)
  * [Prozessmodell starten](#prozessmodell-starten)
  * [Ergebnisse von beendeten Prozessen abfragen](#ergebnisse-von-beendeten-prozessen-abfragen)
  * [Umgang mit External-Tasks](#umgang-mit-external-tasks)
  * [Umgang mit Benutzer-Task (User-Task)](#umgang-mit-benutzer-task-user-task)
  * [Umgang mit Ereignissen (Events)](#umgang-mit-ereignissen-events)
    + [Signale](#signale)
    + [Nachrichten (Messages)](#nachrichten-messages
## Voraussetzung

Um Tests auf Basis der [Robot Framework](https://robotframework.org/) für die BPMN-basierte-Workflowengine
[5Minds-Engine](https://www.5minds.de/processcube/) zu erstellen, sind folgende Voraussetzung erforderlich:
- 5Minds-Studio in der stabilen Version ist installiert
- 5Minds-Studio ist gestartet
- 5Minds-Engine ist durch das Studio auf dem Port `51000`gestartet
- Python in der Version `>=3.7.x` ist installiert und im Pfad konfiguriert
- Robot-Framework für die 5Minds-Engine ist installiert `pip install robotframework-processcube`

Für die Bearbeitung ist [VS Code](https://code.visualstudio.com/) und der [Robot Framework Language Server](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp) hilfreich.

## Verwendung

Um die *Keywords* für die Interaktion mit der 5Minds-Engine verwenden zu können, ist die 
Library ProcessCubeLibrary einzubinden und die URL für die Engine mit dem Paramter `engine_url` 
zu konfiguieren, dies ist für die stabile Version der Studio-Engine `http://localhost:56000`.

```robotframework
*** Settings ***
Library         ProcessCubeLibrary     engine_url=http://localhost:56000

```

### BPMN-Datei installieren

Zuerst ist ein BPMN-Diagram (z.B. `examples/hello_minimal.bpmn`) zu erstellen.


```robotframework
*** Settings ***
Library         ProcessCubeLibrary     engine_url=http://localhost:56000

*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn
```

### Prozessmodell starten

### Ergebnisse von beendeten Prozessen abfragen

### Umgang mit External-Tasks

### Umgang mit Benutzer-Task (User-Task)

### Umgang mit Ereignissen (Events)

#### Signale

#### Nachrichten (Messages)

