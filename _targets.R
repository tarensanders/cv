## Load packages
source("./packages.R")

## Load R files
lapply(list.files("./R", full.names = TRUE), source)

googlesheets4::gs4_deauth()
googledrive::drive_deauth()

data_sheet <- "1eglf3B_N1yv-RH-48NBzriIslqSLkh30V2kxbxlWCfE"

tar_plan(
  # Local files
  tar_target(
    peer_reviewed_file,
    "cv/Peer-reviewed.bib",
    format = "file"
  ),
  tar_target(
    book_chapters_file,
    "cv/Book Chapters.bib",
    format = "file"
  ),
  tar_target(
    conferences_file,
    "cv/Conference Presentations.bib",
    format = "file"
  ),
  # tar_target(,
  # peer_reviewed_file,
  # "cv/My Library.bib",
  # format = "file"),
  # Processing
  tar_target(
    modified_date,
    get_date_modified(data_sheet),
    cue = tar_cue(mode = "always")
  ),
  tar_target(peer_reviewed, bibliography_entries(peer_reviewed_file)),
  tar_target(book_chapters, bibliography_entries(book_chapters_file)),
  tar_target(conferences, bibliography_entries(conferences_file)),
  tar_target(
    gscholar_profile,
    scholar::get_profile("8KNzhS4AAAAJ"),
    cue = tarchetypes::tar_cue_age(
      name = gscholar_profile, age = as.difftime(7, units = "days")
    )
  ),
  tar_target(incites_data, get_incites_data(peer_reviewed),
    cue = tarchetypes::tar_cue_age(
      name = incites_data, age = as.difftime(7, units = "days")
    )
  ),
  tar_target(
    peer_reviewed_citations,
    update_peer_reviewed(peer_reviewed, incites_data)
  ),
  tar_target(
    research_profile,
    make_profile(gscholar_profile, incites_data, peer_reviewed_citations)
  ),
  tar_target(funding, get_sheet(data_sheet, "Funding", modified_date)),
  tar_target(students, get_sheet(data_sheet, "Students", modified_date)),
  tar_target(awards, get_sheet(data_sheet, "Awards", modified_date)),
  tar_target(service, get_sheet(data_sheet, "Service", modified_date)),
  tar_target(
    development,
    get_sheet(data_sheet, "SelfDevelopment", modified_date)
  ),
  tar_target(
    software,
    get_sheet(data_sheet, "Software", modified_date)
  ),
  tar_target(
    invited_talks,
    get_sheet(data_sheet, "InvitedTalks", modified_date)
  ),
  tar_render(cv, "./cv/cv.Rmd")
)