# SEAMIS sea-level database
[![DOI](https://zenodo.org/badge/151711626.svg)](https://zenodo.org/badge/latestdoi/151711626)

This repository contains the Holocene database for SE Asia, Maldives, India and Sri Lanka and GIA models (ICE5G), and scripts to plot data and models.

**If you find problems with the data or if you want to see a particular dataset included, please open an issue within GitHub**

If you use this work, please consider citing these two papers:
> Mann T, Bender M, Lorscheid T, et al (2019) Holocene sea levels in Southeast Asia, Maldives, India and Sri Lanka: The SEAMIS database. Quat Sci Rev 219:112–125. doi: 10.1016/j.quascirev.2019.07.007</br>

> Mann T, Bender M, Lorscheid T, et al (2019) Relative sea-level data from the SEAMIS database compared to ICE-5G model predictions of glacial isostatic adjustment. Data Br 27:104600. doi: 10.1016/j.dib.2019.104600


## Database
The folder ..\SEAMIS_database contains the different database versions. 
Version 1.02 corresponds to the published version, and is also available at this DOI: http://dx.doi.org/10.17632/mr247yy42x.1

The database was compiled using the standardized format of the HOLSEA project, described in Khan et al., 2017 (Quaternary Science Reviews) and available here: www.holsea.org.

## Scripts
The folder ..\Sea_level_plots contains the file "SEALEVELPLOTS.m" that can be used to plot GIA model outputs and RSL observations in RSL *vs* Time graphs. The graphs include symbols for sea level index points, marine and terrestrial limiting points.

The folder \Sea level plots\Models contains the file "PLOT_Maps.m" that can be used to plot GIA maps for the study area. More models and plotting functions are available here: http://doi.org/10.5281/zenodo.4079342

The scripts are written in MATLAB 2016b.
The PLOT_Maps scripts needs the Matlab Mapping Toolbox. 
The SEALEVELPLOTS scripts works with MATLAB 2016b, MATLAB 2015b has a problem with the errorbar function

## Acknowledgments
This work was supported through grant SEASCHANGE (RO-5245/1-1) from the Deutsche Forschungsgemeinschaft (DFG) as part of the Special Priority Program (SPP)-1889 “Regional Sea Level Change and Society”

