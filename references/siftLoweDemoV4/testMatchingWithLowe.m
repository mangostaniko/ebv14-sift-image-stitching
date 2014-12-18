%% Test matchKeypoints.m and findHomography.m with keypoints found by Lowe

% Get SIFT keypoint locations and descriptors
[imA,desA,locA] = sift('B1.pgm');
[imB,desB,locB] = sift('B2.pgm');
[m1,n1] = size(imA);
[m2,n2] = size(imB);

% Match keypoints and find homography
matches = matchKeypoints(locA(:,1:2),locB(:,1:2),desA,desB, imA, imB);
%showMatches(imA,imB,matches(:,1:2),matches(:,3:4));

% Transform imB (map into imA-coordinate system)
H = findHomography([matches(:,3:4),matches(:,1:2)]);
[xB, yB] = meshgrid(1:m2, 1:n2);
coordsB = [xB(:) yB(:)]';
coordsBtoA = H * [coordsB; ones(1, m2*n2)];
coordsBtoA = coordsBtoA(1:2,:)';


% Create image of size max(m1,m2)x n1+n2
stitchedImg = zeros(max(m1,m2),n1+n2);

% Insert imA
stitchedImg(1:m1,1:n1) = im2double(imA);
%imshow(stitchedImg);

% Insert imB
for i = 1:size(coordsBtoA,1)
    stitchedImg(round(coordsBtoA(i,1)),round(coordsBtoA(i,2))) = im2double(imB(coordsB(1,i),coordsB(2,i)));
end
imshow(stitchedImg);