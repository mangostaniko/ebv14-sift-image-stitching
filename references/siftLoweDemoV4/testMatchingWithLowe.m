%% Test matchKeypoints.m and findHomography.m with keypoints found by Lowe

[imA,desA,locA] = sift('B1.pgm');
[imB,desB,locB] = sift('B2.pgm');

matches = matchKeypoints(locA(:,1:2),locB(:,3:4),desA,desB)
showMatches(imA,imB,matches(:,1:2),matches(:,3:4));