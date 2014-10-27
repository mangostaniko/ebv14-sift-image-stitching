function [ stitchedImage ] = main( impath1, impath2 )
% input: impath1, impath2 ... paths to images (JPG or PNG)
% output: stitchedImage ... stitched image (JPG or PNG)

%% read and convert images 
im1 = im2double(imread(impath1));
im2 = im2double(imread(impath2));

%% create DoG pyramids
createDoG();

%% find extrema
findExtrema();

%% remove low contrast points & edges 
removeLowContrast();
removeEdges();

%% find keypoint orientation
findOrientation();

%% define descriptor
defDescriptor();

%% match keypoints
matchKeypoints();

%% find homography (ransac)
findHomography();

%% stitch images

end
