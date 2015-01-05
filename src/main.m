function [ stitchedImage ] = main( impath1, impath2 )
% input: impath1, impath2 ... paths to images (JPG or PNG)
% output: stitchedImage ... stitched image (JPG or PNG)

%% read and convert images
% note: in images x are columns, y are rows.
% however later we use an internal representation which is (x,y)
disp('READ IMAGES')
imA = im2double(imread('../pictures/bild1.jpg'));
imB = im2double(imread('../pictures/bild2.jpg'));
%% create DoG pyramids
disp('DEFINE SCALE SPACE (DIFFERENCE OF GAUSSIANS)')
[ octA1, octA2, octA3, octA4, dogA1, dogA2, dogA3, dogA4, sigmas ] = createDoG2(imA, false, false);
[ octB1, octB2, octB3, octB4, dogB1, dogB2, dogB3, dogB4 ] = createDoG2(imB, false, false);

%% find extrema
disp('FIND SCALE SPACE EXTREMA')
extremaA = findExtrema( dogA1, dogA2, dogA3, dogA4 );
extremaB = findExtrema( dogB1, dogB2, dogB3, dogB4 );
% showKeypoints(imB, extremaB, [0,0,0,0]);

%% remove low contrast points & edges
disp('REMOVE LOW CONTRAST KEYPOINTS AND EDGES')
leftoversA = removeLowContrast(extremaA, octA1);
leftoversB = removeLowContrast(extremaB, octB1);
keypointsA = removeEdges(leftoversA, octA1); % TODO FIX REMOVE EDGES
keypointsB = removeEdges(leftoversB, octB1);

%% find keypoint orientation
disp('FIND KEYPOINT ORIENTATIONS')
% note: with a little fix findOrientations seems to work better than findOrientations2
% (something is wrong with findOrientations2)
orientationsA = findOrientations( keypointsA, octA1 );
orientationsB = findOrientations( keypointsB, octB1 );
% orientationsA = findOrientations2( keypointsA, {octA1, octA2, octA3, octA4}, sigmas );
% orientationsB = findOrientations2( keypointsB, {octB1, octB2, octB3, octB4}, sigmas );
%showKeypoints( imA, keypointsA, orientationsA);
%showKeypoints( imB, keypointsB, orientationsB);

%% create descriptors
disp('DEFINE KEYPOINT SIFT DESCRIPTORS')
descriptorsA = createDescriptors( octA1, keypointsA, orientationsA);
descriptorsB = createDescriptors( octB1, keypointsB, orientationsB);

%% match keypoints
disp('MATCH KEYPOINTS')
matches = matchKeypoints(keypointsA(:,1:2), keypointsB(:,1:2), descriptorsA, descriptorsB);
%showKeypoints( imA, matches(:, 1:2), 0);
%showKeypoints( imB, matches(:, 3:4), 0);
%showMatches( imA, imB, matches(:, 1:2), matches(:, 3:4));

%% find homography (ransac)
disp('FIND HOMOGRAPHY FOR STITCHING')
HBtoA = findHomography([matches(:,3:4),matches(:,1:2)]);
HAtoB = findHomography(matches);

%% stitch images
disp('STITCH IMAGES')
%stitchImages2( imA, imB, HBtoA );
stitchImages3( imA, imB, HBtoA,HAtoB,true);


end
