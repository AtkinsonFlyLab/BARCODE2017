# BARCODE2017
Repository for scripts used in Park et al. 2017 BARCODE paper.

This repository contains the scripts used for the Park et al. 2017 paper. 

-------------------------------------------------------------------------------
'Observational_BARCODE_perl.pl' was used to analyze image data during the BARCODE preference assay. 
To use this script you must have installed ImageMagick. 
Images from the preference assay should be in '.jpg' file format and numerically ordered (ex. 000.jpg, 001.jpg, etc.) 
'Observational_BARCODE_perl.pl' should be in the same directory as the '.jpg' image files. 

This script uses an image subtraction from the first image '000.jpg'. This image should not contain any flies and should be visually similar to the rest of the images in the series. If there are any slight differences this will create false positive values. If the first image is not similar create a new image from image files later in the series by editing the image so the flies are not in the wells. Rename this image '000.jpg' so that it is first in the series. 

1) Open '000.jpg' in GIMP. 
2) Click R for rectangle tool. 
3) Make sure the Tool Options toolbox is open.
4) Draw a rectangle the size of one food well and position it so that it matches the food well. 
5) Select the "Fixed" box and enter the Size of the box.
6) Record the "Position" values (A,B) into the perl scripts; [ $Xoffset_hash{0}=A;$Yoffset_hash{0}=B; ]
7) Repeat this for the rest of the food wells. 
8) Make sure that [ my $number_of_cells_per_image=24; ] matches the number of food wells you recorded.
9) Make sure that [ my $dimensions="70x70"; ] are the right size of the box. These should be the same for each well AxB.
10) To run the script enter [perl  Observational_BARCODE_perl.pl  * .jpg]. into the terminal. The * is used as a wild-card for the image files and will run numerically. 
11) When the script is finished running a 'results.txt' file will appear and contains the number of pixels per well per image/food well.
12) To find number of pixels per fly go back to the images and take the average of ~10 instances of one fly on a food patch from different wells and use the numbers generated in the results.txt file as pixels per fly. This will be your divisor to determine number of flies in a well over time. 


--------------------------------------------------------------------------------

The 'Manifold_DAM_Test.R' was used to analyze the tolerance data.
To use this script you must have installed packages ggplot2, gridExtra, grid, gtable, and cowplot in R.

Data from the DAM manifold should be in 'DataFileName.txt' format and placed in the same directory as the 'Manifold_DAM_Test.R' script.
To run script enter [Rscript Manifold_DAM_Test.r DataFileName.txt] into terminal. 
Outputs go into the same directory. 

