# Model Card For Workshop Attendance

Modeling UCSB Library general workshop attendance as a function of
modality and scheduling.

This model card follows the [Hugging Face model card
template](https://huggingface.co/docs/hub/model-cards).

## Model Details

### Model Description

This is a model for predicting the attendance level of a workshop
based on the workshop's modality (in-person, online, hybrid) and its
scheduling characteristics such as single session vs. multiple
sessions, week in quarter, day of week, etc.  The output variable,
attendance level, bins the predicted number of students (i.e.,
attendees) in groups of 20: 1-20 students, 21-40 students, etc.

- **Developed By:** Greg Janée
- **Model Type:** Supervised classification, random forest
- **License:** [CC-BY](https://creativecommons.org/licenses/by/4.0/)

### Model Sources

The data included, `our-workshops.csv`, on which the model was
trained, lists general (i.e., non-course-affiliated) Library
workshops, primarily
[RDS](https://www.library.ucsb.edu/research-data-services) and [DREAM
Lab](https://www.library.ucsb.edu/dreamlab) workshops, dating back to
2019, for which scheduling and instruction modality were decisions on
the Library's part and not dictated by externalities.  The information
for a workshop includes modality (in-person vs. online), number of
students/attendees, and scheduling characteristics (single session
vs. multiple sessions, week within quarter, day(s) within week, and
time of day).  See `data-description.txt` for a fuller description of
the dataset.

The primary source for this data was the [instruction stats
page](https://docs.google.com/spreadsheets/d/1b_8dwZnUa6mtI8ZJBSqchMQ4GvgUGDsGrYEiYloAefs/edit)
maintained by Teaching & Learning.  This was processed by `prep.R` and
then hand-edited (and hand-corrected in a few places) to add
additional column values by referring back to old Google Calendar
events and the DREAM Lab's log of [past
workshops](https://carpentry.library.ucsb.edu/past-workshops/).

- **Repository:** https://github.com/gjanee/ml

## Uses

### Direct Use

Run this model to predict the attendance level given a proposed
schedule for a workshop.

### Out-of-Scope Use

Given its narrow training, this model is unlikely to be relevant to
any other institution, or indeed even to any other group outside the
UCSB Library.

## Bias, Risks, and Limitations

### Risks

The data is public record as it reflects workshops that were publicly
advertised and publicly attended.  Furthermore, the data was obtained
from a publicly-accessible URL.  Nevertheless, instructor names and
work emails might be viewed as private details.  In any case, they are
irrelevant to this model's purpose and could be removed.

### Limitations

- The range of workshop characteristics is very wide relative to the
  number of workshops, that is, for any "type" of workshop one might
  identify, there are only one or a handful of workshops of that type.
  As a consequence, it is difficult to make any generalizations, which
  probably accounts for why this model is a failure.

- Put another way, the number of independent variables (5) is large in
  relation to the number of data points (113).

- The model ignores workshops' topical subjects and how the workshops
  were advertised, both of which may (and likely did) influence
  attendance.

- The data dates back to 2019.  The effects of the COVID lockdown
  (e.g., workshops during that period were required to be online) are
  ignored.

### Recommendations

This model should not be relied upon for anything.

## How to Get Started with the Model

Run `decision-tree.qmd`.  Instructions on how to run the model on new
data are given in that notebook.

## Training Details

### Training Data

The model was trained on the entire dataset.

### Training Procedure

Random forest.

#### Preprocessing

As described above, the data was preprocessed and then hand-edited and
hand-corrected in a few places.  The raw number of students was binned
into ranges of 20, or quartiles.

#### Training Hyperparameters

Untouched.

## Evaluation

### Testing Data, Factors & Metrics

#### Testing Data

The model was trained on the entire dataset and the overall error was
estimated from the out-of-bag error rates.

#### Metrics

Performance here is accuracy of classification.

### Results

The accuracy is 60%.

#### Summary

The model sucks.

## Environmental Impact

- **Hardware Type:** local laptop
- **Hours Used:** 0.3s to render notebook
- **Cloud Provider:** N/A
- **Compute Region:** N/A
- **Carbon Emitted:** .0000058 kg CO2e (estimated using [Machine
  Learning Impact Calculator](https://mlco2.github.io/impact))

## Technical Specifications

### Compute Infrastructure

#### Software

- R 4.4.1
- tidyverse 2.0.0
- rpart 4.1.23
- rpart.plot 3.1.2
- randomForest 4.7-1.2

## Glossary

- modality
  - In person
  - Online
  - Hybrid

- scheduling
  - SS
    - Single session
  - MSSW
    - Multiple sessions within same week
  - MSMW
    - Multiple sessions over multiple weeks

- week in quarter
  - Normalized week in quarter of first workshop date, computed using
    logic borrowed from the Waitz Shiny application.
    - Quarter weeks start on Sunday.  Thus, regardless of which day of
      the week the first day of a quarter falls on, it is in week 1,
      and the following Monday is in week 2.
    - Quarters are adjusted to have the same length.  (All quarters
      have the same number of teaching days, but due to holidays, Fall
      quarters have 4 extra days and are 1 week longer than Winter and
      Spring quarters.)  For Fall quarters, we exclude the week
      containing Thanksgiving.  In this way all quarters have exactly
      11 weeks, and weeks 10 and 11 are always dead week and finals
      week, respectively.
  - For our purposes here, a workshop that took place outside a
    quarter, i.e. during a break, is treated as belonging to the
    previous quarter, hence quarter week numbers may be greater than 11.

- time of day
  - All day
  - Morning
    - Starting in the morning, possibly lasting through lunch
  - Lunchtime
    - Starting at noon, lasting just the lunch hour
  - Afternoon
    - Starting at lunch or later and lasting into the afternoon
  - Evening
    - Starting at 5pm or later

## Model Card Contact

Greg Janée (<gjanee@ucsb.edu>)
