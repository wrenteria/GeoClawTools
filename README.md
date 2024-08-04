# GeoClawTools
This project aims to develop some tools for pre/post-processing the GeoClaw model.
The current tools are:
1. **max2raster**: A Fortran code to convert the fgmax to ASCII/RASTER format for GIS purposes.\
To compile: >> make -f makefile.max\
To execute: >> ./bin4max/max2raster

2. **fgmax2raster**: A Python code to convert the fgmax to ASCII/RASTER format for GIS purposes.\
To execute: >> python fgmax2raster.py
