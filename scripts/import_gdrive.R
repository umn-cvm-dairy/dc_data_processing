# download from Google Drive
# 
# 
# libaries

if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  googledrive,     # to link to your google drive
  googlesheets4,   # for importing from Google Drive
  nanoparquet ,    # light weight parquet read
  tidyverse       # data mgmt and viz
 
)


# check to make sure google drive token
if (!drive_has_token()) {
  drive_auth()  # will prompt browser login
}

# get location of files
drive_url <- googledrive::as_id("https://drive.google.com/drive/u/0/folders/11M2ugMAxh1RxPfDKJN0qoyGW0v9-aq0n")

# Use 'pattern' to match file extensions .csv OR .parquet
drive_folder <- drive_ls(
  path = drive_url,
  pattern = "\\.(csv|parquet|CSV)$" 
)

# make sure local folder exists
local_folder <- "source_data"
if (!dir.exists(local_folder)) dir.create(local_folder)

# 2. OPTIMIZATION: Iterate over the dribble object directly
# It is safer to pass the file 'drive_resource' directly to drive_download
# rather than looking it up by name again (which fails if you have duplicate names).

walk2(drive_folder$name, drive_folder$id, function(name, id) {
  
  # Full local path
  file_path <- file.path(local_folder, name)
  
  # Download the file using the ID (more robust)
  drive_download(
    file = as_id(id), 
    path = file_path,
    overwrite = TRUE
  )
})