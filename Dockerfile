# Thin CV image built on top of the shared base image.
# r-base already provides R 4.5.x, pandoc and radian; here we add the system
# libraries the project packages need, the pinned renv library, TeX Live, and
# the custom CV template. Built and pushed to ghcr.io by .github/workflows/build-image.yaml.
FROM ghcr.io/tarensanders/r-base:latest

ARG GITHUB_PAT

USER root

# System libraries required by the project's R packages. r-base relies on the
# devcontainer r-packages feature for these, so we install them explicitly here.
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  ca-certificates \
  cmake \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libfontconfig1-dev \
  libsodium-dev \
  libsecret-1-dev \
  libpoppler-cpp-dev \
  librsvg2-2 \
  librsvg2-dev \
  libglpk40 \
  libxt6 \
  perl \
  && rm -rf /var/lib/apt/lists/*

# Restore the exact pinned library from renv.lock into the system library so
# plain library() calls resolve at runtime (CI runs targets without activating renv).
# P3M binaries (R 4.5.x matches the lockfile) make this fast; kableExtra is a
# GitHub source and needs GITHUB_PAT.
COPY renv.lock /tmp/renv.lock
RUN R -e "if (!requireNamespace('renv', quietly = TRUE)) install.packages('renv')" \
  && R -e "Sys.setenv(GITHUB_PAT = '${GITHUB_PAT}'); \
  renv::restore(lockfile = '/tmp/renv.lock', library = '/usr/local/lib/R/site-library', prompt = FALSE)"

# TeX Live via TinyTeX (the tinytex R package was just restored above), installed
# system-wide so it is on PATH for any runtime user, plus the LaTeX packages the
# awesome-cv template needs.
ENV PATH="/opt/TinyTeX/bin/x86_64-linux:${PATH}"
RUN R -e "tinytex::install_tinytex(dir = '/opt/TinyTeX', force = TRUE)" \
  && tlmgr path add \
  && tlmgr install \
  academicons booktabs colortbl enumitem environ euenc fancyhdr \
  float fontawesome fontspec fp ifmtarg l3packages latex-amsmath-dev makecell multirow \
  pdflscape pgf ragged2e setspace sourcesans xltabular tcolorbox threeparttable \
  threeparttablex tipa trimspaces ulem unicode-math varwidth wrapfig xifthen xunicode \
  && tlmgr path add

# Custom template that adds cover-letter support to vitae's awesomecv.
COPY cv/awesome-cv.tex /usr/local/lib/R/site-library/vitae/rmarkdown/templates/awesomecv/resources/awesome-cv.tex
