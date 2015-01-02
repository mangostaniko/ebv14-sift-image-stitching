%% Test matchKeypoints.m and findHomography.m with keypoints found by Lowe

% Get SIFT keypoint locations and descriptors
[imA,desA,locA] = sift('bild1.pgm');
[imB,desB,locB] = sift('bild2.pgm');
[m1,n1] = size(imA);
[m2,n2] = size(imB);

% Match keypoints and find homography
matches = matchKeypoints(locA(:,1:2),locB(:,1:2),desA,desB, imA, imB);
%showMatches(imA,imB,matches(:,1:2),matches(:,3:4));

%% Transform B to A

% Transform imB (map into imA-coordinate system)
H = findHomography([matches(:,3:4),matches(:,1:2)]);
HAtoB = findHomography(matches);
[xB, yB] = meshgrid(1:m2, 1:n2);
coordsB = [xB(:) yB(:)]';
coordsBtoA = H * [coordsB; ones(1, m2*n2)];
coordsBtoA = coordsBtoA(1:2,:)';
xBtoA = reshape(round(coordsBtoA(:,1)),n2,m2)';
yBtoA = reshape(round(coordsBtoA(:,2)),n2,m2)';

% Avoid out of bound indices ?????? TODO: ALTERNATIVE METHOD??????????
xBtoA(xBtoA>m1) = m1;
xBtoA(xBtoA<1) = 1;
yBtoA(yBtoA>n1+n2) = n1+n2;
yBtoA(yBtoA<1) = 1;

% Create image of size max(m1,m2)x n1+n2
stitchedImg = zeros(max(m1,m2),n1+n2);

% Insert imA
stitchedImg(1:m1,1:n1) = im2double(imA);
%imshow(stitchedImg);

% Insert imB - option 1
% for i = 1:size(coordsBtoA,1)
%     stitchedImg(round(coordsBtoA(i,1)),round(coordsBtoA(i,2))) = im2double(imB(coordsB(1,i),coordsB(2,i)));
% end

% Insert imB - option 2
indB = sub2ind([m2, n2],xB',yB');
%imshow(im2double(imB(indB)));
indBtoA = sub2ind([max(m1,m2),n1+n2],xBtoA,yBtoA);
stitchedImg(indBtoA) = im2double(imB(indB));
imshow(stitchedImg);

%% Transform A to B

% Calculate seem coords and offset
seem = round(H*[1;1;1]);
xSeem = seem(2);
offset = n1 - xSeem;

% Create image with adjusted size ??????? TODO: INCLUDE VARYING NUMBER OF ROWS???????
stitchedImgInv = zeros(m1,xSeem + n2 -1);

% Calculate corresponding coordinates in imB
[xA, yA] = meshgrid(1:m1, xSeem:xSeem+n2-1);
coordsA =  [xA(:) yA(:)]';
coordsAtoB = HAtoB * [coordsA; ones(1, m1*n2)];
coordsAtoB = coordsAtoB(1:2,:)';
xAtoB = reshape(round(coordsAtoB(:,1)),n2,m2)';
yAtoB = reshape(round(coordsAtoB(:,2)),n2,m2)';


% Catch out of bound indices
xAtoB(xAtoB>m2) = m2;
xAtoB(xAtoB<1) = 1;
yAtoB(yAtoB>n2) = n2;
yAtoB(yAtoB<1) = 1;

% Write imA into stitched image
stitchedImgInv(1:m1,1:n1) = im2double(imA);

% Insert imB - option 2
indA = sub2ind([m1, xSeem+n2-1],xA',yA');
indAtoB = sub2ind([m2, n2],xAtoB,yAtoB);
stitchedImgInv(indA) = im2double(imB(indAtoB));

% Show images and stitched image
figure('Name','Image #1','NumberTitle','off')
imshow(im2double(imA));
figure('Name','Image #2','NumberTitle','off')
imshow(im2double(imB));
figure('Name','Stitched Image','NumberTitle','off')
imshow(stitchedImgInv);
