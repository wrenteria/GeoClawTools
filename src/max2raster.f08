!> Program to convert the output fgmax
!> to ASCII Raster (ESRI) for GIS interoperability purposes
!> The folder src contains the source code
!> The folder bin contains the executable
!> The makefile sets the compilation and the execution:
!>  - To compile: 'make'
!>  - To execute: './bin4max/max2raster
!> -----------------------------
!> Author: Willington Renteria
!> wrenteri@usc.edu
program main
  USE OMP_LIB
  implicit none
  character(100) :: filename_metadata
  character(100) :: filename_data
  integer :: num_fgmax_val, num_fgmax_grids, fgno, nx, ny, nn,n,i,j,k
  real :: tstart_max, tend_max, dt_check, min_level_check, arrival_tol, x1, y1, x2, y2,eta
  character(100) :: line
  real, allocatable ::  lon(:), lat(:), lev(:), topo(:), hh(:), tm(:), ta(:)
  character(LEN=30) :: Format

  !!!
  !!! METADATA READING
  !!!

  filename_metadata = "_output/fgmax_grids.data"
  ! Open the metadata file
  open(unit=10, file=filename_metadata, status='old')

  ! Read and ignore the header lines
  read(10, *) line
  read(10, *) line
  read(10, *) line
  read(10, *) line
  read(10, *) line

  ! Read the parameters data, some are no used in here
  ! Read all just to keep track of the line
  read(10, *) num_fgmax_val
  read(10, *) num_fgmax_grids
  read(10, *) fgno
  read(10, *) tstart_max
  read(10, *) tend_max
  read(10, *) dt_check
  read(10, *) min_level_check
  read(10, *) arrival_tol
  read(10, *) line ! Ignore interp_method
  read(10, *) line ! Ignore point_style
  read(10, *) nx, ny
  read(10, *) x1, y1
  read(10, *) x2, y2
  ! The length of the file is given by (nx * ny)
  nn = nx*ny
  ! Close the file
  close(10)

  ! Since we know the length of the file, it is time to allocate the memory
  allocate(lon(nn), lat(nn), lev(nn), topo(nn),hh(nn), tm(nn), ta(nn))

  !!!
  !!! READING THE DATA
  !!!

  filename_data = "_output/fgmax0001.txt"
  ! Open the data
  open(unit=20, file=filename_data, status='old')
  
  ! Read the data on each column
  ! Save the data into corresponding column vector 
  
  do n = 1, nn
    read(20, fmt=*) lon(n),lat(n),lev(n),topo(n),hh(n),tm(n),ta(n)
  end do
  
  close(20)

  !!!
  !!! WRITING THE ASCII/ESRI RASTER FORMAT DATAFILE
  !!!
  
  ! Open unifile to write the data on it
  open(unit=30, file='ascii_max.asc', status='replace')

  ! Writing the data with the right format
  Format="(A,F15.10)"
  write(30,"(A,I6)") "ncols ", nx
  write(30,"(A,I6)") "nrows ", ny
  write(30,Format) "xllcenter ", x1-360
  write(30,Format) "yllcenter ", y1
  write(30,Format) "cellsize ", (x2-x1)/nx
  write(30,"(A,I6)") "nodata_value ", -32768
  
  ! Data in the vector columns is writing in 1-D and 
  ! The order of rows is inverted(for ASCII/ESRI format)
  ! The loop is designed to read the last row(last nx values) 
  ! which is the first row of ASCII/ESRI format
  i = nn-nx+1
  j = nn
  do  n = 1, ny
    write(30,*) topo(i:j)+hh(i:j)
    j = i-1
    i = i-nx
  end do
  close(30)
end program main
