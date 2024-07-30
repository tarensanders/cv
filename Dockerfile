FROM rocker/r-ver:4.4.1

ENV RENV_VERSION 1.0.7
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@v${RENV_VERSION}')"

# Install apt dependencies
RUN apt-get update 

RUN apt-get install -y \
  git \
  libcurl4-openssl-dev \
  libfontconfig1-dev \
  libglpk40 \
  libssl-dev \
  libxml2-dev \
  pandoc \
  pandoc-citeproc \
  python3-pip && \
  pip3 install radian

# # These are all the latex packages that GitHub Actions tries to install
# RUN tlmgr update --self && \
#   tlmgr install enumitem ragged2e iftex fancyhdr xcolor xifthen ifmtarg etoolbox setspace euenc fontspec tipa xunicode unicode-math latex-amsmath-dev fontawesome academicons sourcesanspro tcolorbox fp ms pdftexcmds pgf environ trimspaces kvoptions ltxcmds kvsetkeys auxhook bigintcalc bitset etexcmds gettitlestring hycolor hyperref intcalc kvdefinekeys letltxmacro pdfescape refcount rerunfilecheck stringenc uniquecounter zapfding infwarerr booktabs tabu varwidth colortbl geometry tikzfill && \
#   apt-get autoremove -y && \
#   apt-get clean

WORKDIR /cv
COPY renv.lock renv.lock

ENV RENV_PATHS_LIBRARY renv/library

RUN R -e "renv::restore()"