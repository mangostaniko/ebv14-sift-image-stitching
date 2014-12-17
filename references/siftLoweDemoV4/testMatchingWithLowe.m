%% Test matchKeypoints.m and findHomography.m with keypoints found by Lowe

[imA,desA,locA] = sift('B1.pgm');
[imB,desB,locB] = sift('B2.pgm');

matches = matchKeypoints(locA(:,1:2),locB(:,1:2),desA,desB, imA, imB);
%showMatches(imA,imB,matches(:,1:2),matches(:,3:4));
H = findHomography(matches);
