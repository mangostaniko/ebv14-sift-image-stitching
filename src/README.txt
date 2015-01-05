README: USAGE INSTRUCTIONS FOR EBV B4 IMAGE STITCHING

notes for evaluation: 
- only 2 images can be stitched. images should adhere to requirements specified in Bericht (edbv_ag_b4.pdf) section 1.4 'Voraussetzungen und Bedingungen'.
- evaluation should be based on results using the pre-defined ('shipped') configuration.

GUI VERSION
- set Matlab path to src directory
- run GUI.m and follow instructions

COMMAND LINE VERSION
- set Matlab path to src directory
- open main.m and modify image source paths as necessary:
imA = im2double(imread('../pictures/image1.jpg'));
imB = im2double(imread('../pictures/image2.jpg'));
- run main.m

for additional output prior to stitching use showKeypoints.m and showMatches.m
in main.m just uncomment lines containing showKeypoints and showMatches

for more information and function interface specification, read function headers, where expected input and output are defined.

have fun :)
