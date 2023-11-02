## Load packages
source("./packages.R")

## Load R files
lapply(list.files("./R", full.names = TRUE), source)

googlesheets4::gs4_deauth()
googledrive::drive_deauth()

sheet <- "1eglf3B_N1yv-RH-48NBzriIslqSLkh30V2kxbxlWCfE"

# Pubs to include in short CV
short_pubs <- c(
  "Accepted: 2023-09-02", # Sanders, NHB, 2023
  "WOS:000892975800001", # Lubans, IJBNPA, 2022
  "WOS:000648645400006", # Lonsdale, JAMA Peds, 2021
  "WOS:000620749700001", # Noetel, RER, 2021
  "WOS:000712220800001", # Noetel, RER, 2021
  "WOS:000627077400001", # Lee, RER, 2021
  "WOS:000667241100005", # Hartwig, BJSM, 2021
  "WOS:000660894000001", # Antczak, IJBNPA, 2021
  "WOS:000501313400002", # Sanders, IJBNPA, 2020
  "WOS:000530217600006" # Antczak, Sleep Med Rev, 2020
)

top_five <- c(
  "Accepted: 2023-09-02", # Sanders, NHB, 2023
  "WOS:000648645400006", # Lonsdale, JAMA Peds, 2021
  "WOS:000620749700001", # Noetel, RER, 2021
  "WOS:000667241100005", # Hartwig, BJSM, 2021
  "WOS:000501313400002" # Sanders, IJBNPA, 2020
)

tar_plan(
  # Bib files
  tar_target(
    peer_reviewed_file,
    "cv/bibs/Peer-reviewed.bib",
    format = "file"
  ),
  tar_target(
    book_chapters_file,
    "cv/bibs/Book Chapters.bib",
    format = "file"
  ),
  tar_target(
    conferences_file,
    "cv/bibs/Conference Presentations.bib",
    format = "file"
  ),
  tar_target(peer_reviewed, bibliography_entries(peer_reviewed_file)),
  tar_target(book_chapters, bibliography_entries(book_chapters_file)),
  tar_target(conferences, bibliography_entries(conferences_file)),
  # Profiles
  tar_target(
    gscholar_profile,
    scholar::get_profile("8KNzhS4AAAAJ"),
    cue = tar_cue(mode = "always")
  ),
  tar_age(
    incites_data,
    get_incites_data(peer_reviewed, jifs),
    age = as.difftime(7, units = "days")
  ),
  tar_target(short_cv_pubs, short_pubs),
  tar_target(topfive_cv_pubs, top_five),
  tar_target(
    peer_reviewed_citations,
    update_peer_reviewed(
      peer_reviewed, incites_data, short_cv_pubs, topfive_cv_pubs
    )
  ),
  tar_target(
    research_profile,
    make_profile(gscholar_profile, incites_data, peer_reviewed_citations)
  ),
  # Google Sheets Files
  tar_target(
    modified_date, get_date_modified(sheet),
    cue = tar_cue(mode = "always")
  ),
  tar_target(jifs, get_sheet(sheet, "JIFs", modified_date)),
  tar_target(funding, get_sheet(sheet, "Funding", modified_date)),
  tar_target(students, get_sheet(sheet, "Students", modified_date)),
  tar_target(awards, get_sheet(sheet, "Awards", modified_date)),
  tar_target(service, get_sheet(sheet, "Service", modified_date)),
  tar_target(development, get_sheet(sheet, "SelfDevelopment", modified_date)),
  tar_target(software, get_sheet(sheet, "Software", modified_date)),
  tar_target(invited_talks, get_sheet(sheet, "InvitedTalks", modified_date)),
  tar_target(cv_sections, list.files("./cv/sections", full.names = TRUE),
    format = "file"
  ),
  tar_render(cv, here::here("cv", "cv.Rmd"),
    output_file = here::here("cv", "CV - Dr Taren Sanders.pdf")
  ),
  tar_render(cv_two_page, here::here("cv", "cv_two_page.Rmd"),
    output_file = here::here("cv", "CV - Dr Taren Sanders (Short).pdf")
  ),
  tar_render(cv_five_page, here::here("cv", "cv_five_page.Rmd"),
    output_file = here::here("cv", "CV - Dr Taren Sanders (5 page).pdf")
  ),
  tar_render(
    cv_two_page_full_pubs, here::here("cv", "cv_two_page_full_pubs.Rmd"),
    output_file = here::here(
      "cv",
      "CV - Dr Taren Sanders (2 page with publications).pdf"
    )
  )
)
