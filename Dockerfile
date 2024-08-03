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
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_texlive.sh

# These are all the latex packages that GitHub Actions tries to install
RUN tlmgr install academicons booktabs colortbl enumitem environ euenc fancyhdr \
  float fontawesome fontspec fp ifmtarg l3packages latex-amsmath-dev makecell multirow \
  pdflscape pgf ragged2e setspace sourcesanspro tabu tcolorbox threeparttable threeparttablex \
  tipa trimspaces ulem unicode-math varwidth wrapfig xifthen xunicode

# Install renv
ENV RENV_VERSION 1.0.7
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))" && \
  R -e "remotes::install_github('rstudio/renv@v${RENV_VERSION}')" 

# Setup renv
COPY renv.lock renv.lock
RUN R -e "renv::restore()"
# Install dev requirements that are seperate from the project
RUN R -e "renv::install(c('languageserver', 'httpgd', 'conflicted', 'dotenv', 'devtools', 'milesmcbain/fnmate','milesmcbain/tflow'))"

# Setup the custom tex file for the CV to allow for cover letters
COPY cv/awesome-cv.tex /usr/local/lib/R/site-library/vitae/rmarkdown/templates/awesomecv/resources/awesome-cv.tex