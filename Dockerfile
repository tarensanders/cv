FROM rocker/verse:4.3.0

# These are all the latex packages that GitHub Actions tries to install
RUN tlmgr update --self && \
  tlmgr install enumitem ragged2e iftex fancyhdr xcolor xifthen ifmtarg etoolbox setspace euenc fontspec tipa xunicode unicode-math latex-amsmath-dev fontawesome academicons sourcesanspro tcolorbox fp ms pdftexcmds pgf environ trimspaces kvoptions ltxcmds kvsetkeys auxhook bigintcalc bitset etexcmds gettitlestring hycolor hyperref intcalc kvdefinekeys letltxmacro pdfescape refcount rerunfilecheck stringenc uniquecounter zapfding infwarerr booktabs tabu varwidth colortbl && \
  apt-get autoremove -y && \
  apt-get clean