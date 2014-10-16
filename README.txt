EBV GRUPPE B4 — IMAGE STITCHING

aus der Methodenliste:
10 Gaussfilter
25 Bildpyramiden
25 SIFT

TODO
- Konzept bis 19.10.
- Git einlernen (Kap. 1–3 http://git-scm.com/book/en/Getting-Started)

VEREINFACHUNGEN (zu Beginn)
- zu Beginn nur 2 Bilder, bereits richtig 'nebeneinandergelegt'
- möglichst gleichmäßge belichtung
- möglichst geringe verzerrung

KONZEPT //TODO
Image Registration
- Bildpyramiden-Aufbau
- Keypoint-Detection + Matching (SIFT)
- Homographic Transformation (RANSAC)
Image Calibration
- Verzerrung und andere Defekte ausgleichen [optional]
Image Blending
- Projektion an richtige Position
- Weiche Farbverläufe [optional]


ZUSAMMENARBEIT
github.com/mangostaniko/ebvb4/
Telegram chat
Talky.io video chat

REFERENZEN

overview:
http://tobw.net/index.php?cat_id=2&project=Panorama+Stitching+Demo+in+Matlab
https://courses.engr.illinois.edu/cs498dwh/fa2010/lectures/Lecture%2017%20-%20Photo%20Stitching.pdf
http://cvrr.ucsd.edu/ece285/presentations/WI13/Alfredo_Presentation1.pdf
http://karantza.org/projects/KarantzaReport.pdf
http://courses.cs.washington.edu/courses/cse455/07wi/notes/stitching.pdf
https://code.google.com/p/imagestitcher/

detailed publications:
http://www.cs.ubc.ca/~lowe/papers/ijcv04.pdf (SIFT)
http://www.cs.bath.ac.uk/brown/papers/ijcv2007.pdf (Image Stitching using SIFT)
http://www.cs.bath.ac.uk/brown/papers/iccv2003.pdf (Recognizing Panoramas)
http://www.cs.bath.ac.uk/brown/autostitch/autostitch.html (bib ref for the former two)
http://cseweb.ucsd.edu/classes/wi07/cse252a/homography_estimation/homography_estimation.pdf

matlab:
http://www.csse.uwa.edu.au/~pk/research/matlabfns/
http://www.cheat-sheets.org/saved-copy/matlab_quickref.pdf
