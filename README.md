# papyri-docker

Dockerized papyri.info stack.

## Running

From this repository's directory:

1. `docker-compose build`
2. `COMPOSE_HTTP_TIMEOUT=10000 docker-compose up -d`
3. Watch logs in a separate terminal in the same directory: `docker-compose logs -f -t`
4. If all is successful, you should be able to access the running copy once `httpd` comes up at: <http://127.0.0.1:8000>

## Gotchas

* **Docker Compose Timeout**: the default Docker Compose HTTP timeout of 60 seconds seems to cause problems with `docker-compose up`/`docker-compose stop` for me, due to the delay in responsiveness of some services. Hence the `COMPOSE_HTTP_TIMEOUT=10000` in the command above. You can just `export` it instead, if you like.
* **Disk Space**: after bringing up a complete stack, my `docker system df` shows 40GB of images, 1GB of containers, and 26GB of volumes (**67GB total**). You may need to increase the default disk allocation if you're running e.g. Docker for Mac.
* **Network Port**: if another service is already bound to port 8000, `httpd` will fail to come up. If this happens, you can just stop the other service and run `docker-compose up -d` again.
* **Memory**: I have 16GB of RAM, 1GB of swap, and 6 VCPUs allocated to Docker. Bringing this up makes my system quite slow...
* **Initial Indexing**: if something goes wrong with the indexing process, you may need to use `docker-compose up -d --force-recreate` when re-trying.

## Structure

* `httpd`: Apache 2.2 server, proxies the Navigator, Editor, XSugar, and Fuseki
  * `indexer`: container that runs the indexing process using the below services
    * `navigator`: the main ["Papyrological Navigator"](https://github.com/papyri/navigator) server
    * `fuseki`: Apache Jena Fuseki 1.x SPARQL Server (aka "Numbers Server")
    * `tomcat-pn`: Tomcat server runing "dispatch" and "sync" servlets
    * `solr`: Tomcat server running Apache Solr for search
  * `tomcat-sosol`: Tomcat server serving up WAR file for [Editor (aka "SoSOL")](http://github.com/sosol/sosol), WAR built by `sosol`
    * `sosol`: container that runs Editor tests and builds the WAR file for `tomcat-sosol`
    * `xsugar`: container that runs [XSugar](https://github.com/papyri/xsugar), an XML transformer used by `tomcat-sosol`
  * `mysql`: MySQL 5.6 server, shared by `sosol`, `tomcat-sosol`, and `tomcat-pn`
  * `repo_clone`: shared Git checkout of the large main [`idp.data`](https://github.com/papyri/idp.data) repository, shared by `navigator`, `fuseki`, `tomcat-pn`, `tomcat-sosol`, `sosol`, & `httpd`

The papyri.info "Top Level Data Flow" diagram may help with understanding:

![Top Level Data Flow diagram for papyri.info](http://papyri.github.io/documentation/system_level/images/TopLevelDataFlow-new.jpg)

## Service Startup Order

Service startup order is important, and the current `docker-compose.yml` uses several strategies to control it:

1. [`wait-for-it.sh`](https://github.com/vishnubob/wait-for-it) used to wait for network service availability; `indexer` uses it to wait for `solr` startup, `sosol` uses it to wait for `mysql` startup
2. lockfiles on shared volumes are used to enforce processes that only need to run once only running once; these lockfiles are also sometimes used as a wait signal for containers that need the process to finish before they can run (these busy-wait until the lockfile exists)
3. `links` and `depends_on` clauses in `docker-compose` 2.2 syntax

Note that this last strategy will only really *enforce* ordering with `docker-compose` v2 syntax.

## Servers vs. Processes

You may note that we have some containers which run as continuous *servers*, and others which are containerized *processes* for building artifacts needed by those servers. Categorizing them may be useful:

**Servers:**
* `http`
* `fuseki`
* `solr`
* `tomcat-sosol`
* `tomcat-pn`
* `mysql`
* `xsugar`

**Processes:**
* `repo_clone`
* `sosol`
* `navigator`
* `indexer`
