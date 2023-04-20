# Building, starting, and stopping a container

Assumptions:
- Docker is running
- You have a terminal session
- Your current working directory is set to the main project directory.

Containers must be built if:
- you are using the environment for the first time
- you have made changes to any of the [DS environment files](#ds-environment-files) listed below

Otherwise, you may proceed to [Starting a stopped container](#Starting-a-stopped-container)


## Building a container

At the command line:
```bash
docker compose -f environment/compose.yml build
docker compose -f environment/compose.yml up -d
```

When you bring up JupyterLab, you may see this warning. That's okay, you can ignore it.
```bash
WARN[0000] Found orphan containers ([<some_container_name>]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up. 
```


## Starting a stopped container

To start the JupyterLab Docker container, at the command line:
```bash
docker compose -f environment/compose.yml start
```

### Accessing JupyterLab

When it's done spinning up, the container will be accessible via any webbrowser on the host machine at `http://localhost:PORT_NUMBER/` (eg. http://localhost:10000).


## Stopping a container

To stop the JupyterLab Docker container, at the command line:
```bash
docker compose -f environment/compose.yml stop
```


# Structure

## Docker elements

### `Dockerfile`

This file defines the basic configuration for the Docker part of the environment. The container it uses is based on pinned version of the [`jupyter/datascience-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook) image, and it finishes by installing the configured packages.


### `compose.yml` 

This file uses the `Dockerfile` for most configuration, but additionally configures the container ports and maps the project directories on your host machine to `/home/jovyan` in the container.


## DS environment files


### `requirements.txt`

Additional Python packages to be installed when the container is built.


### `r-packages.R`

Additional R packages to be installed when the container is built.


### `jupyter-extensions.csv`

Additional JupyterLab extensions to be installed when the container is built. 


## Supporting files

### `install-jupyter-extensions.sh`

This script installs the JupyterLab extensions, and is run by the `Dockerfile`.


### `jupyter_server_config.py`

This is where you can make changes to the Jupyter server configuration. By default, it sets the JupyterLab UI to launch in the `jupyterlab` folder of the main project and removes server authentication since this project is only meant to be run on a researcher's computer and not in a shared or production environment.


