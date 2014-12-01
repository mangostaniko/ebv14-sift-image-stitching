function [ stitchedImage ] = main( impath1, impath2 )
% input: impath1, impath2 ... paths to images (JPG or PNG)
% output: stitchedImage ... stitched image (JPG or PNG)
close all; % DONT FORGET TO REMOVE THIS

%% read and convert images 
imA = im2double(imread('../pictures/B1.jpg'));
imB = im2double(imread('../pictures/B2.jpg'));
%% create DoG pyramids
[ octA1, octA2, octA3, octA4, dogA1, dogA2, dogA3, dogA4 ] = createDoG(imA);
[ octB1, octB2, octB3, octB4, dogB1, dogB2, dogB3, dogB4 ] = createDoG(imB);


%% find extrema
extremaA = findExtrema( dogA1, dogA2, dogA3, dogA4 );
extremaB = findExtrema( dogB1, dogB2, dogB3, dogB4 );

%showKeypoints( imB, extremaB, [0; 0; 0; 0]);


%% remove low contrast points & edges 
leftoversA = removeLowContrast(extremaA, octA1);
leftoversB = removeLowContrast(extremaB, octB1);
%showKeypoints( imB, leftovers, [0; 0; 0; 0]);
keypointsA = leftoversA; %removeEdges(leftoversA, octA1);
keypointsB = leftoversB; %removeEdges(leftoversB, octB1);
showKeypoints( imA, keypointsA, [0; 0; 0; 0]);
showKeypoints( imB, keypointsB, [0; 0; 0; 0]);

%% find keypoint orientation
orientationsA = findOrientations( keypointsA, octA1);
orientationsB = findOrientations( keypointsB, octB1);
showKeypoints( imA, keypointsA, orientationsA);
showKeypoints( imB, keypointsB, orientationsB);

%% create descriptors
createDescriptors();

%% match keypoints
matchKeypoints();

%% find homography (ransac)
findHomography();

%% stitch images

end
