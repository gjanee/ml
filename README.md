# Machine learning demonstration project

The data herein, `our-workshops.csv`, lists general (i.e.,
non-course-affiliated) Library workshops, primarily
[RDS](https://www.library.ucsb.edu/research-data-services) and [DREAM
Lab](https://www.library.ucsb.edu/dreamlab) workshops, dating back to
2019, for which scheduling and instruction modality were decisions on
our part and not dictated by externalities.  The information for a
workshop includes modality (in-person vs. online), number of
students/attendees, and scheduling characteristics (single session
vs. multiple sessions, week within quarter, day(s) within week, and
time of day).  See `data-description.txt` for a fuller description of
the dataset.

The goal is to experiment with models against this data, to determine
which factors most significantly affect (or at least, are correlated
with) higher attendance.

The primary source for the data was the [instruction stats
page](https://docs.google.com/spreadsheets/d/1b_8dwZnUa6mtI8ZJBSqchMQ4GvgUGDsGrYEiYloAefs/edit)
maintained by Teaching & Learning.  This was processed by `prep.R` and
then hand-edited (and hand-corrected in a few places) to add
additional column values by referring back to old Google Calendar
events and the DREAM Lab's log of [historical
workshops](https://carpentry.library.ucsb.edu/past-workshops/).

`decision-tree.qmd` presents a decision tree analysis of the data.
