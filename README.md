<div align="center">

<a href="https://github.com/tarensanders">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=22&duration=3500&pause=900&color=2C5282&center=true&vCenter=true&width=620&lines=Reproducible+academic+CV+%2B+website;Built+weekly+from+.bib%2C+Sheets%2C+and+Scholar;Quarto+site+%2B+four+PDF+variants" alt="typing banner" />
</a>

[![Build](https://github.com/tarensanders/cv/actions/workflows/targets.yaml/badge.svg)](https://github.com/tarensanders/cv/actions/workflows/targets.yaml)
[![Site](https://img.shields.io/badge/site-tarensanders.github.io%2Fcv-2C5282)](https://tarensanders.github.io/cv/)
[![ORCID](https://img.shields.io/badge/ORCID-0000--0002--4504--6008-A6CE39?logo=orcid&logoColor=white)](https://orcid.org/0000-0002-4504-6008)
[![Scholar](https://img.shields.io/badge/Scholar-Profile-4285F4?logo=googlescholar&logoColor=white)](https://scholar.google.com/citations?user=8KNzhS4AAAAJ)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

</div>

This repository builds my academic CV and personal website from a single
data pipeline. Once a week (and on every push) a GitHub Action runs the R
[`targets`](https://docs.ropensci.org/targets/) pipeline, regenerates the
PDFs, refreshes the website's data sidecars, and deploys the rendered
site.

## What lives here

| Output | Where |
| --- | --- |
| Live website | <https://tarensanders.github.io/cv/> |
| Full CV (PDF) | [cv/CV - Assoc Prof Taren Sanders.pdf](cv/CV%20-%20Assoc%20Prof%20Taren%20Sanders.pdf) |
| 5-page CV | [cv/CV - Assoc Prof Taren Sanders (5 page).pdf](cv/CV%20-%20Assoc%20Prof%20Taren%20Sanders%20%285%20page%29.pdf) |
| 2-page CV | [cv/CV - Assoc Prof Taren Sanders (2 page).pdf](cv/CV%20-%20Assoc%20Prof%20Taren%20Sanders%20%282%20page%29.pdf) |
| 2-page CV + selected publications | [cv/CV - Assoc Prof Taren Sanders (2 page with publications).pdf](cv/CV%20-%20Assoc%20Prof%20Taren%20Sanders%20%282%20page%20with%20publications%29.pdf) |

## Data flow

```
BibTeX (cv/bibs/*.bib)  ─┐
Google Sheets ───────────┼─► _targets.R ─► _data/*.json ─► Quarto site ─► gh-pages
Google Scholar cache ────┘                └─► cv/*.pdf (vitae + LaTeX)
```

- **Publications** live in `cv/bibs/` as BibTeX. Citation counts and
  journal impact factors are merged in by the pipeline — neither is
  scraped at site-build time.
- **Sheets** (funding, students, awards, service, talks, teaching,
  software, JIFs) live in a Google Sheet read read-only by the pipeline.
- **Profile metrics** (h-index, i10, total citations) come from the
  Google Scholar cache in `data/`.

The Quarto pages read sidecar JSON written by the pipeline into `_data/`,
so the website never re-parses raw sources.

## Build it yourself

```bash
# render everything (CVs + website data + site)
R -e 'targets::tar_make()'

# preview the site locally
quarto preview
```

Inspect the dependency graph:

```bash
R -e 'targets::tar_visnetwork()'
```

## Layout

```
.
├── _targets.R              # pipeline definition
├── _quarto.yml             # website config
├── index.qmd               # home page
├── publications.qmd        # listing from _data/publications.json
├── projects.qmd            # listing from _data/software.json
├── cv.qmd                  # downloads page
├── blog/                   # Quarto blog
├── assets/                 # SCSS, EJS listing template, images
├── _data/                  # JSON emitted by the pipeline (committed)
├── R/                      # pipeline functions
├── cv/                     # CV Rmd sources, bibs, fonts, output PDFs
└── data/                   # cached Scholar data
```

## Acknowledgements

Pipeline scaffolding adapted from the
[`targets` GitHub Actions example](https://github.com/wlandau/targets-minimal-gha).
CV layout uses [`vitae`](https://github.com/mitchelloharawild/vitae) on top
of the Awesome CV LaTeX template. The website is built with
[Quarto](https://quarto.org).
