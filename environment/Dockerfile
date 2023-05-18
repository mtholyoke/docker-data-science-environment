# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a core stack version
FROM jupyter/datascience-notebook:9e63909e0317

# Volumes aren't in place yet 
WORKDIR /home/jovyan/
COPY --chown=${NB_UID}:${NB_GID} . .

# Set up jupyterlab/ for UI to use
RUN mkdir jupyterlab
WORKDIR /home/jovyan/jupyterlab
RUN ln -s ../analysis analysis
RUN ln -s ../data data

# Install Python packages from requirements.txt file
WORKDIR /home/jovyan/environment
RUN pip install --quiet --no-cache-dir --requirement ./requirements.txt && \
  fix-permissions "${CONDA_DIR}" && \
  fix-permissions "/home/${NB_USER}"

# Install R packages
RUN ./r-packages.R

# Install JupyterLab extensions 
RUN ./install-jupyter-extensions.sh


WORKDIR /home/jovyan/
