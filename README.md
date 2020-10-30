# papyri-docker

Dockerized papyri.info stack.

## Running:

From this repository's directory:

1. `docker-compose build`
2. `COMPOSE_HTTP_TIMEOUT=10000 docker-compose up -d`
3. Watch logs in a separate terminal in the same directory: `docker-compose logs -f -t`
4. If all is successful, you should be able to access the running copy once `httpd` comes up at: <http://127.0.0.1:8000>

## Gotchas:

* **Docker Compose Timeout**: the default Docker Compose HTTP timeout of 60 seconds seems to cause problems with `docker-compose up`/`docker-compose stop` for me, due to the delay in responsiveness of some services. Hence the `COMPOSE_HTTP_TIMEOUT=10000` in the command above. You can just `export` it instead, if you like.
* **Disk Space**: after bringing up a complete stack, my `docker system df` shows 40GB of images, 1GB of containers, and 26GB of volumes (**67GB total**). You may need to increase the default disk allocation if you're running e.g. Docker for Mac.
* **Network Port**: if another service is already bound to port 8000, `httpd` will fail to come up. If this happens, you can just stop the other service and run `docker-compose up -d` again.
* **Memory**: I have 16GB of RAM, 1GB of swap, and 6 VCPUs allocated to Docker. Bringing this up makes my system quite slow...
* **Initial Indexing**: if something goes wrong with the indexing process, you may need to use `docker-compose up -d --force-recreate` when re-trying.
