# docker-data-science-environment
This repository offers a starting framework for a standardized and reproducible data science research environment. The [template repository](https://github.com/mtholyoke/docker-data-science-environment) was developed by [Abby Drury](https://lits.mtholyoke.edu/about-lits/staff/abby-drury) in the [Academic Technologies department in LITS](https://lits.mtholyoke.edu/about-lits/departments/technology-infrastructure-systems-support/academic-technologies) in consultation with [Ben Gebre-Medhin](https://www.mtholyoke.edu/directory/faculty-staff/benjamin-gebre-medhin) from the Department of Sociology and Anthropology and [Sarah Oelker](https://lits.mtholyoke.edu/about-lits/staff/sarah-oelker) in the [Educational Technology department in LITS](https://lits.mtholyoke.edu/about-lits/departments/research-instructional-support/educational-technology). 

Additional information can be found in the [parent project wiki](https://github.com/mtholyoke/docker-data-science-environment/wiki). 

## Environment Customization and Statup
See [`environment/README.md`](environment/README.md)

## Project structure

### `analysis/`

Notebooks and analysis to be shared between docker container and local machine. 

### `data/`

Data to be shared between docker container and local machine. 

### `environment/`

Docker related files and package lists for Python and R as well as JupyterLab plug-ins.

### `jupyterlab/`

This is the root directory for the JupyterLab UI. By default, it will include the `analysis/` and `data/` directories via a symlink. This keeps the JupyterLab UI clean – `environment/` and other top-level files will not appear in the left rail.
