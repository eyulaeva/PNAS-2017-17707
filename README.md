# README #
* This directory contains derived data and associated scripts.
* A majority of data used is freely available online
## Location of the Data used in the paper
* NCEP/NCAR Reanalysis Data: https://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/?Set-Language=en
* ERA-Interim: https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era-interim
* NOAA/NSIDC Climate Data Record of Passive Microwave Sea Ice Concentration: https://nsidc.org/data/g02202 
## Derived timeseries
* September ice area anomalies: DATA/ice_area_Sep_1980_2016.d
* Pacific Sector Open water area anomalies: DATA/ow_1949_2017_anom_P1c.d
## Scripts
* Matlab script calculating September Arctic sea ice area: CODE/ice_arctic_1980_2016.m
* Fortran script calculating rgression and significance (t-test); CODE/reg_sig_slp.f90   
