# Verwendung des Robot Framework mit der 5Minds-Engine

- [Voraussetzung](#voraussetzung)
- [Verwendung](#verwendung)
  * [BPMN-Datei in 5Minds-Engine laden](#bpmn-datei-in-5minds-engine-laden)
  * [Prozessmodell starten](#prozessmodell-starten)
  * [Ergebnisse von beendeten Prozessen abfragen](#ergebnisse-von-beendeten-prozessen-abfragen)
  * [Verarbeiten von Aktivitäten](#verarbeiten-von-aktivitaten)
    + [Umgang mit External-Tasks](#umgang-mit-external-tasks)
    + [Umgang mit Benutzer-Tasks (User-Tasks)](#umgang-mit-benutzer-tasks-user-tasks)
    + [Umgang mit manuellen Tasks (Manual-Tasks)](#umgang-mit-manuellen-tasks-manual-tasks)
    + [Umgang mit untypisierten Tasks (Empty-Tasks)](#umgang-mit-untypisierten-tasks-empty-tasks)
  * [Umgang mit Ereignissen (Events)](#umgang-mit-ereignissen-events)
    + [Signale](#signale)
    + [Nachrichten (Messages)](#nachrichten-messages)
    
## Voraussetzung

Um Tests auf Basis der [Robot Framework](https://robotframework.org/) für die BPMN-basierte-Workflowengine
[5Minds-Engine](https://www.5minds.de/processcube/) zu erstellen, sind folgende Voraussetzung erforderlich:
- 5Minds-Studio in der stabilen Version ist installiert
- 5Minds-Studio ist gestartet
- 5Minds-Engine ist durch das Studio auf dem Port `56000`gestartet

Alternative kann Docker für die 5Minds-Engine verwendet werden, dann sind folgende Vorausetzungen notwendig:
- Docker-Desktop ist installiert und gestartet
- Zugang zum Internet für den Download des Image [5minds/atlas_engine_fullstack_server](https://hub.docker.com/r/5minds/atlas_engine_fullstack_server)

Für die Ausführung von Tests ist dann noch folgende Voraussetzung notwendig:
- Python in der Version `>=3.7.x` ist installiert und im Pfad konfiguriert
- Robot-Framework für die 5Minds-Engine ist installiert `pip install robotframework-processcube`

Für die Bearbeitung ist [VS Code](https://code.visualstudio.com/) und der [Robot Framework Language Server](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp) hilfreich.

## Verwendung

Um die *Keywords* für die Interaktion mit der 5Minds-Engine verwenden zu können, ist die 
Library ProcessCubeLibrary einzubinden.
Für die Verwendung mit dem 5Minds-Studio (ohne Docker) ist die URL für die Engine mit
dem Paramter `engine_url` zu konfiguieren, dies ist für die stabile Version der
Studio-Engine `http://localhost:56000`.

Mit dem 5Minds-Studio ist folgende Verwendung zu verwenden.
```robotframework
*** Settings ***
Library         ProcessCubeLibrary     engine_url=http://localhost:56000

```

Für die weiteren Beispiele wird Docker verwendet und dann ist folgende Einstellung zu ändern:
```robotframework
*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
```

Die Engine im Docker-Container wird standardmäßig mit dem Port `55000` gestartet. Die URL zum
Einbinden ins Studio ist also `http://localhost:55000`.

### BPMN-Datei in 5Minds-Engine laden

Zuerst ist ein BPMN-Diagram (z.B. [`processes/hello_minimal.bpmn`](processes/hello_minimal.bpmn) zu erstellen.

Mit dem Keyword `Deploy Processmodel` und der Angabe des Dateipfades wird das BPMN-Diagram in die 5Minds-Engine geladen.

```robotframework
*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}

*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn
```

### Prozessmodell starten

Wie unter [BPMN-Datei in 5Minds-Engine laden](#bpmn-datei-in-5minds-engine-laden) beschrieben, muss die BPMN-Datei
vorhanden sein.

Mit dem Keyword `Start Processmodel` und der Angabe der Process ID `hello_minimal` wird eine Prozessinstanz gestartet.

```robotframework
*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False

*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library    Process

*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn

Start process model
    Start Processmodel     hello_minimal
```

### Ergebnisse von beendeten Prozessen abfragen

Nachdem der Prozess gestartet wurde, kann mit dem Keyword `Get Processinstance Result` das Ergebnis
der Prozessinstanz abgefragt werden.

```robotframework
*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections


*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_minimal.bpmn

Start process model
    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world
    ${PROCESS_INSTANCE}=     Start Processmodel    hello_minimal    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Get the process instance
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}
    Log                      ${RESULT}
```

### Verarbeiten von Aktivitäten

#### Umgang mit untypisierten Tasks (Empty-Tasks)

Um bei der Entwicklung von Aktivitäten mit noch untypisierten Tasks 
zu beginnen, stehen die Keywords `Get Empty Task By` fürs Laden und 
`Finish Empty Task` zum Abschließen zur Verfügung.

Für diesen Test wird eine andere BPMN-Datei verwendet `hello_empty_task.bpmn`.

```robotframework
*** Variables ***
&{DOCKER_OPTIONS}            auto_remove=False
${CORRELATION}               -1


*** Settings ***
Library         ProcessCubeLibrary     self_hosted_engine=docker    docker_options=${DOCKER_OPTIONS}
Library         Collections


*** Tasks ***
Successfully deploy
    Deploy Processmodel    processes/hello_empty_task.bpmn

Start process model
    &{PAYLOAD}=              Create Dictionary     foo=bar    hello=world
    ${PROCESS_INSTANCE}=     Start Processmodel    hello_empty_task    ${PAYLOAD}
    Set Suite Variable       ${CORRELATION}        ${PROCESS_INSTANCE.correlation_id}
    Log                      ${CORRELATION}

Handle empty task by correlation_id
    Log                      ${CORRELATION}
    ${EMPTY_TASK}            Get Empty Task By                     correlation_id=${CORRELATION}
    Log                      ${EMPTY_TASK.empty_task_instance_id}
    Finish Empty Task        ${EMPTY_TASK.empty_task_instance_id}


Get the process instance
    ${RESULT}                Get Processinstance Result            correlation_id=${CORRELATION}
    Log                      ${RESULT}
```

#### Umgang mit manuellen Tasks (Manual-Tasks)

Als Basis für den Umgang mit manuellen Task wird die BPMN-Datei 
`hello_manual_task.bpmn` benötigt.

Für das Laden vom manuellen Taak dient das Keyword `Get Manual Task By` und 
für das Beenden `Finish Manual Task`.

```robotframework

```

#### Umgang mit Benutzer-Tasks (User-Tasks)

#### Umgang mit External-Tasks

### Umgang mit Ereignissen (Events)

#### Signale

#### Nachrichten (Messages)

