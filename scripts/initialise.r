# Initialise the R environment for the project
renv::init(bare = TRUE)

# Install required packages
# Additional packages in the renv.lock
renv::install(c("tidyverse", "readr", "rlang", "jsonlite", "languageserver")) 

# Snapshot the current state of the project library
renv::snapshot()

# For you to load the environment later, use:
# renv::restore()