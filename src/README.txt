README: USAGE INSTRUCTIONS FOR EBV B4 IMAGE STITCHING

notes for evaluation: 
- only 2 images can be stitched. images should adhere to requirements specified in Bericht (edbv_ag_b4.pdf) section 1.4 'Voraussetzungen und Bedingungen'.
- evaluation should be based on results using the pre-defined ('shipped') configuration.

GUI VERSION
- set Matlab path to src directory
- run GUI.m and follow instructions

COMMAND LINE VERSION
- set Matlab path to src directory
- run main.m with image source paths as arguments
e.g. main('../pictures/LEFT_IMAGE.jpg', '../pictures/RIGHT_IMAGE.jpg')

for additional output prior to stitching use showKeypoints.m and showMatches.m
in main.m just uncomment lines containing showKeypoints and showMatches

for more information and function interface specification, read function headers, where expected input and output are defined.

have fun :)
