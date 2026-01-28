# Costing Study
## Author: Nyiro C. Mwagwabi

The purpose of this repo is to have a flow for the analysis.

The basic structure of your directory should be like this:
```
.
├── README.md
├── data
│   └── IHCoRPatientCostingT_DATA_2026-01-28_2054.csv
├── renv
│   ├── activate.R
│   ├── library
│   ├── settings.json
│   └── staging
├── renv.lock
└── scripts
    ├── explore.r
    └── initialise.r
```

4 directories, 2 files

To restore the R environment used, run:
```{R}
renv::restore()
```
