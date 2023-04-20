# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a core stack version
FROM jupyter/datascience-notebook:9e63909e0317

# Volumes aren't in place yet, get the stuff into the container
WORKDIR /home/jovyan/
COPY --chown=${NB_UID}:${NB_GID} . .

# Tag the image
ARG BUILD_DATE
ARG VCS_REF
#
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="mtholyoke/docker-for-data-science" \
  org.label-schema.description="Standardized and reproducible data science research environment" \
  org.label-schema.url="https://github.com/mtholyoke/docker-data-science-environment/wiki" \
  org.label-schema.vcs-url="https://github.com/mtholyoke/docker-data-science-environment" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vendor="Mount Holyoke College" \
  org.label-schema.version="1.1.0" \
  org.label-schema.schema-version="1.0.0-rc.1"
# org.label-schema.usage="" \


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
