FROM rocker/r-ver:4.4.1

# Install apt dependencies
RUN apt-get update && apt-get install -y \
  ca-certificates \
  cmake \
  fftw3 \  
  git \
  libcurl4-openssl-dev \
  libfontconfig1-dev \
  libglpk40 \
  libssl-dev \
  librsvg2-2 \
  librsvg2-dev \
  libsodium-dev \
  libsecret-1-dev \
  libpoppler-cpp-dev \
  libxml2-dev \
  libxt6 \
  libzmq3-dev \
  perl \
  texinfo \
  wget \
  xclip \
  python3-pip && \
  pip3 install radian

WORKDIR /cv

# Install tex
ENV CTAN_REPO="https://mirror.cse.unsw.edu.au/pub/CTAN/systems/texlive/tlnet"
ENV PATH="$PATH:/usr/local/texlive/bin/linux"
COPY install_tex.sh /cv/
RUN chmod +x /cv/install_tex.sh && \
  /cv/install_tex.sh

# Install renv
ENV RENV_VERSION 1.0.7
ENV RENV_PATHS_LIBRARY renv/library
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))" && \
  R -e "remotes::install_github('rstudio/renv@v${RENV_VERSION}')" 

# Setup renv
COPY renv.lock renv.lock
RUN R -e "renv::restore()"