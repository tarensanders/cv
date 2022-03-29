# Get the base image from rocker
FROM rocker/verse:4.1.3

# Add lockfile
COPY renv.lock ./

# Install renv & restore packages
ENV RENV_VERSION 0.15.4
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
RUN R -e 'renv::activate();renv::restore(prompt=FALSE)'