# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a core stack version
FROM jupyter/datascience-notebook:9e63909e0317

# Volumes aren't in place yet, get the stuff into the container
WORKDIR /home/jovyan/
COPY --chown=${NB_UID}:${NB_GID} . .

# Allow these build-args to be passed into the Dockerfile's context for tagging the image from environment/docker-environment-common.sh
## NOTE: You can update REPOSITORY_URL in environment/docker-environment-common.sh
ARG REPOSITORY_URL
ARG BUILD_DATE
ARG REVISION
ARG LATEST_GIT_TAG
# Tag the image. Schema based on https://github.com/opencontainers/image-spec/blob/main/annotations.md.
## NOTE: org.opencontainers.image.version will always be the latest Git release tag
LABEL \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.authors="adrury@mtholyoke.edu" \
  org.opencontainers.image.url="$REPOSITORY_URL/blob/main/environment/README.md" \
  org.opencontainers.image.documentation="$REPOSITORY_URL/wiki" \
  org.opencontainers.image.source=$REPOSITORY_URL \
  org.opencontainers.image.revision=$REVISION \
  org.opencontainers.image.vendor="Trustees of Mount Holyoke College" \
  org.opencontainers.image.license="MIT" \
  org.opencontainers.image.title="Docker Data Science Environment" \
  org.opencontainers.image.description="Standardized and reproducible data science research environment" \
  org.opencontainers.image.version=$LATEST_GIT_TAG

# Set up jupyterlab/ for UI to use, putting data/ and analysis/ at the root of the UI
WORKDIR /home/jovyan/
RUN mkdir jupyterlab
WORKDIR /home/jovyan/jupyterlab
RUN ln -s ../analysis analysis
RUN ln -s ../data data
WORKDIR /home/jovyan/environment

# Install Python packages from requirements.txt file
RUN pip install --quiet --no-cache-dir --requirement ./requirements.txt && \
  fix-permissions "${CONDA_DIR}" && \
  fix-permissions "/home/${NB_USER}"

# Install R packages
RUN ./r-packages.R

# Install JupyterLab extensions 
RUN ./install-jupyter-extensions.sh

# Put everything back so the UI doesn't get confused
WORKDIR /home/jovyan/
