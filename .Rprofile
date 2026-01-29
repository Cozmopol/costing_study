source("renv/activate.R")

# This function runs automatically when the R session is closed
.Last <- function() {
  if (interactive()) {
    cat("\n--- Terminating Session: Auto-snapshotting renv ---\n")
    # prompt = FALSE ensures it doesn't wait for your 'y/n' input while you're trying to leave
    renv::snapshot(prompt = FALSE)
  }
}
