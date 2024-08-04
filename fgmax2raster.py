from clawpack.geoclaw import fgmax_tools,geoplot
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
"""
Script to convert Fixed grid monitoring (fgmax) into ASCII Raster
Source: https://www.clawpack.org/fgmax.html
This script must be used for:
     fg.point_style = 2  
     rundata.fgmax_data.num_fgmax_val = 1
Also, can be applied to num_fgmax_val = 2 or 5; refer to the source --> speed and momentum  
Author:
    Willington Renteria <wrenteri@usc.edu> 
"""

# To control the colormap 
clines_eta = [0.01] + list(np.linspace(0.05,1.0,5)) + [1.5,2.0,10.0]
colors = geoplot.discrete_cmap_1(clines_eta)

path_='./_output/'
fig, ax = plt.subplots(subplot_kw = dict(projection=ccrs.PlateCarree()))

fgd='fgmax_grids.data' # grid
fg = fgmax_tools.FGmaxGrid()
fg.read_fgmax_grids_data(fgno=1,data_file=path_+fgd)
fg.read_output(outdir=path_) # Basically read: 'fgmax0001.txt' 

# B = bathy, h= flow depth, eta= h + B
eta = np.where(fg.B>0, fg.h, fg.h+fg.B)   # h = eta - B ;surface elevation in ocean
pcm = plt.contourf(fg.X,fg.Y,eta,clines_eta,colors=colors) # eta

# fg.X , fg.Y , eta are grids with coordinates a data
print(fg.X.shape, fg.Y.shape, eta.shape)

plt.contour(fg.X,fg.Y,fg.B,[0.],colors='k')  # coastline
plt.colorbar(pcm,orientation='horizontal')
plt.title('Maximum amplitude')
plt.show()

# Write the Geoclaw grid data into ASCII Raster
#
fout=open("MaxEta.asc",'w') # Filename for the output
x_len = eta.shape[0]
y_len = eta.shape[1]
dx = (fg.x2 - fg.x1) / x_len

fout.write("ncols   %i\n"%(x_len))
fout.write("nrows   %i\n"%(y_len))
fout.write("xllcorner   %3.1f\n"%(fg.x1-360)) # check convention
fout.write("yllcorner   %3.1f\n"%(fg.y1))
fout.write("cellsize    %3.4f\n"%(dx))
fout.write("NODATA_value    %i\n"%(999999))

for j in range(y_len):
    for i in range(x_len):
        fout.write("%3.2f   "%(eta[i,-j]))
    fout.write("\n")
fout.close()
