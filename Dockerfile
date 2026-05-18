FROM rocker/r-ver:4.4.2

ARG GITHUB_PAT

# Install radian dependencies
RUN apt-get update -qq && apt-get install -y \
  git \
  pipx \
  python3-dev \
  wget && \
  pipx ensurepath && \
  pipx install radian

# Install apt dependencies
RUN apt-get install -y \
  ca-certificates \
  cmake \
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
  xclip

WORKDIR /cv

# Install tex
ENV CTAN_REPO="https://mirror.aarnet.edu.au/pub/CTAN/systems/texlive/tlnet"
ENV PATH="$PATH:/usr/local/texlive/bin/linux"
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_texlive.sh

# Install Quarto (used by the website build via tarchetypes::tar_quarto)
ENV QUARTO_VERSION="1.5.57"
RUN /rocker_scripts/install_quarto.sh

# These are all the latex packages that GitHub Actions tries to install
# Note: sourcesanspro was withdrawn from CTAN; awesome-cv loads Source Sans
# Pro via fontspec from system fonts, so the shim package is no longer needed.
RUN tlmgr install academicons booktabs colortbl enumitem environ euenc fancyhdr \
  float fontawesome fontspec fp ifmtarg l3packages latex-amsmath-dev makecell multirow \
  pdflscape pgf ragged2e setspace tabu tcolorbox threeparttable threeparttablex \
  tipa trimspaces ulem unicode-math varwidth wrapfig xifthen xunicode

# Install renv
ENV RENV_VERSION="1.0.7"
RUN R -e "install.packages('remotes')" && \
  R -e "remotes::install_github('rstudio/renv@v${RENV_VERSION}')" 

# Setup renv
COPY renv.lock renv.lock
RUN R -e "Sys.setenv(GITHUB_PAT = '${GITHUB_PAT}'); \
  renv::restore()"

# Install the quarto R package (used by the website build).
# Kept separate from the dev-requirements line below so it doesn't depend on
# GITHUB_PAT — quarto is on CRAN, not GitHub.
RUN R -e "renv::install('quarto')"

# Install dev requirements that are seperate from the project
RUN R -e "Sys.setenv(GITHUB_PAT = '${GITHUB_PAT}'); \
  renv::install(c('languageserver', 'httpgd', 'conflicted', 'dotenv', 'devtools', 'milesmcbain/fnmate','milesmcbain/tflow'))"

# Setup the custom tex file for the CV to allow for cover letters
COPY cv/awesome-cv.tex /usr/local/lib/R/site-library/vitae/rmarkdown/templates/awesomecv/resources/awesome-cv.tex
