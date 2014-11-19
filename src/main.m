function [ stitchedImage ] = main( impath1, impath2 )
% input: impath1, impath2 ... paths to images (JPG or PNG)
% output: stitchedImage ... stitched image (JPG or PNG)

%% read and convert images 
imA = im2double(imread('../pictures/B1.jpg'));
imB = im2double(imread('../pictures/B2.jpg'));

%% create DoG pyramids
[ octA1, octA2, octA3, octA4, dogA1, dogA2, dogA3, dogA4 ] = createDoG(imA);
[ octB1, octB2, octB3, octB4, dogB1, dogB2, dogB3, dogB4 ] = createDoG(imB);
%imshow(octA1(:,:,1))
%imshow(dogA1(:,:,1))

% NO ERRORS UNTIL HERE

%% find extrema
% TODO FINDS IMAGE EDGES ?
extremaA = findExtrema( dogA1, dogA2, dogA3, dogA4 );
extremaB = findExtrema( dogB1, dogB2, dogB3, dogB4 );

showKeypoints( imB, extremaB, [0; 0; 0; 0]);


%% remove low contrast points & edges 
removeLowContrast();
removeEdges();

%% find keypoint orientation
findOrientations();

%% create descriptors
createDescriptors();

%% match keypoints
matchKeypoints();

%% find homography (ransac)
findHomography();

%% stitch images

end
