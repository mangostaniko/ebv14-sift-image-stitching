function [ stitchedImage ] = main( impath1, impath2 )
% input: impath1, impath2 ... paths to images (JPG or PNG)
% output: stitchedImage ... stitched image (JPG or PNG)

%% read and convert images
% note: in images x are columns, y are rows.
% however later we use an internal representation which is (x,y)
imA = im2double(imread('C:/Users/Sebastian/Pictures/B2klein.jpg'));
%imB = im2double(imread('../pictures/england.png'));
%% create DoG pyramids
[ octA1, octA2, octA3, octA4, dogA1, dogA2, dogA3, dogA4 ] = createDoG2(imA, false, false);
%[ octB1, octB2, octB3, octB4, dogB1, dogB2, dogB3, dogB4 ] = createDoG(imB);

%showKeypoints(10*dogB1(:,:,1), [0,0,0], [0,0,0,0]);

%% find extrema
extremaA = findExtrema( dogA1, dogA2, dogA3, dogA4 );
%extremaB = findExtrema( dogB1, dogB2, dogB3, dogB4 );
showKeypoints(imA, extremaA, [0,0,0,0]);
%% remove low contrast points & edges
leftoversA = removeLowContrast(extremaA, octA1);
%leftoversB = removeLowContrast(extremaB, octB1);
keypointsA = removeEdges(leftoversA, octA1); % TODO FIX REMOVE EDGES
%keypointsB = leftoversB; %removeEdges(leftoversB, octB1);
showKeypoints(imA, leftoversA, [0,0,0,0]);
%% find keypoint orientation
orientationsA = findOrientations( keypointsA, octA1);
orientationsB = findOrientations( keypointsB, octB1);
showKeypoints( imA, keypointsA, orientationsA);
showKeypoints( imB, keypointsB, orientationsB);

%% create descriptors
descriptorsA = createDescriptors( octA1, keypointsA, orientationsA);
descriptorsB = createDescriptors( octB1, keypointsB, orientationsB);

%% match keypoints
matches = matchKeypoints(keypointsA(:,1:2), keypointsB(:,1:2), descriptorsA, descriptorsB);
%showKeypoints( imA, matches(:, 1:2), 0);
%showKeypoints( imB, matches(:, 3:4), 0);
%showMatches( imA, imB, matches(:, 1:2), matches(:, 3:4), [0 0 0 0], [0 0 0 0]);

%% find homography (ransac)
H = findHomography(matches);

%% stitch images

end
