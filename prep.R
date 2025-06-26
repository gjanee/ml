library(tidyverse)

# Data preprocessing:
#
# instruction-stats-raw.csv => our-workshops-preliminary.csv
#
# Goal: select workshops for general audiences, mostly RDS and DREAM
# Lab workshops, for which scheduling and instruction modality were
# decisions on our part.  Therefore, excluded are drop-ins and other
# sessions that were for a particular class, where the time was
# dictated by the class or faculty member and the audience was given
# and required to attend (e.g., RCR trainings).
#
# Workshops to be excluded are identified primarily by having a
# non-null `Faculty or Instructor` field.  This test is not perfect:
# due to data entry errors, for some workshops the librarian's name
# was entered as the faculty member, causing them to be excluded by
# the preceding logic, but this doesn't significantly affect the
# identification of relevant RDS and DREAM Lab workshops.
#
# Workshops are further filtered to include only those where `Course
# department` is "Carpentry Workshop" or "OTHER (e.g. non-course
# integrated instruction)".  Doing so excludes a few workshops that
# could conceivably be included in this analysis such as Zotero
# workshops offered by Research & Engagement.  Still included (perhaps
# undesirably so) are workshops that are part of a larger event such
# as Love Data Week, where the scheduling was not a free decision.
#
# N.B.: The raw data appears to list workshops multiple times, one row
# per instructor, hence the need to collapse using `distinct`.

our_departments <- c(
  "Carpentry Workshop",
  "OTHER (e.g. non-course integrated instruction)"
)

df <- read_csv(
    "instruction-stats-raw.csv",
    na=c("", "n/a", "N/A")
  ) %>%
  filter(is.na(`Faculty or Instructor`)) %>%
  filter(`Course department` %in% our_departments) %>%
  select(
    title=`Course number`,
    num_students=`Number of students`,
    modality=`Instruction Modality`,
    date=`Date of instruction session`,
    scheduling=`Instruction Type`
  ) %>%
  drop_na(title) %>%
  distinct()

# Regularize the date

df$date <- mdy(df$date)

# Workshops pre-2019 are outliers, remove them

df <- df %>% filter(date >= as.Date("2019-01-01"))

# Add in day of week.  For single sessions, this value will remain.
# For workshops with multiple sessions, it's a starting point for
# subsequent manual update.

df$days_of_week <- wday(df$date, label=TRUE)

# Recode schedule type.  Single sessions (SS) will remain.  Multiple
# sessions are coded as MSSW (multiple sessions, same week) for now;
# subsequent manual update will distinguish between MSSW and MSMW
# (multiple sessions, multiple weeks).  Unknown schedule types are
# coded as SS for now.

df$scheduling <- fct_recode(
    df$scheduling,
    SS="Single session",
    MSSW="Multiple sessions"
  ) %>%
  fct_na_value_to_level("SS")

# Normalized week-in-quarter computation.  The academic quarter data
# and logic are adapted from the Waitz Shiny application.  Here, a
# workshop that took place outside a quarter, i.e. during a break, is
# treated as belonging to the previous quarter, hence quarter week
# numbers may be greater than 11.

quarters <- read_csv("quarters.csv") %>% arrange(desc(start))

locate_week_in_quarter <- function(date) {
  q <- filter(quarters, start <= date) %>% head(1)
  stopifnot("date out of range"= nrow(q) == 1)
  week_num <- as.integer(date - q$start_prev_sunday) %/% 7 + 1
  if (!is.na(q$thanksgiving_week_num)) {
    stopifnot(
      "Thanksgiving week not handled"= week_num != q$thanksgiving_week_num
    )
    if (week_num > q$thanksgiving_week_num) {
      week_num <- week_num-1
    }
  }
  week_num
}

df$week_in_quarter <- sapply(df$date, locate_week_in_quarter)

# Add time of day column for future manual entry

df$time_of_day <- NA

# Reorder columns, sort rows for predictability, and output

df <- select(
    df,
    title, date, num_students, modality, scheduling, week_in_quarter,
    days_of_week, time_of_day
  ) %>%
  arrange(desc(date))

write_csv(df, "our-workshops-preliminary.csv", na="", eol="\r\n")
