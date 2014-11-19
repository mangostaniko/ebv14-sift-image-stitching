EBV GRUPPE B4 — IMAGE STITCHING

ARBEITSAUFTEILUNG ca. bis Zwischenabgabe
Bildpyramiden: Ernad
Min/Max in DoG + LowContrast removal: Patrick
Remove Edge Keypoints: Sebastian
Orientierung+Descriptor: Nikolaus
Matching: Hanna


HELPFUL LINKS

note about RANSAC:
such Transformationsmatrix die ein möglichst gutes Mapping aller Keypoints des ersten Bilds zu denen des anderen (beide schon gefunden) darstellt. Nimmt zufällig 4 Keypoints Paare, erstellt Matrix und schaut, ob die gemappten innerhalb eines Toleranzbereichs zu den 'wirklichen' Positionen im zweiten Bild liegen.

overview:
http://www.aishack.in/tutorials/sift-scale-invariant-feature-transform-introduction/ SIFT
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
