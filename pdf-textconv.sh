#!/usr/bin/env bash
# git textconv driver for PDFs: print a PDF's text to stdout so `git diff` shows
# content changes instead of "Binary files differ". Git invokes this with the
# path to the blob as $1.
#
# Wired up via the "*.pdf diff=pdf" rule in .gitattributes plus the
# diff.pdf.textconv config set by the devcontainer postCreateCommand. Requires
# pdftotext (poppler-utils), which is installed in the Dockerfile.
exec pdftotext -layout "$1" -
