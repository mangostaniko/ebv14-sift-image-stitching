function [ stitchedImage ] = mainCMD( impath1, impath2, showK, showM, useMRS )
% input: impath1, impath2 ... paths to images (JPG or PNG)
%        showK            ... boolean, true if you want to show the keypoints
%        showM            ... boolean, true if you want to show matching keypoints
%        useMRS           ... boolean, true if you want to you use multires. splining
% output: stitchedImage ... stitched image (JPG or PNG)

%% read and convert images
% note: in images x are columns, y are rows.
% however later we use an internal representation which is (x,y)
disp('READ IMAGES')
imA = im2double(imread(impath1));
imB = im2double(imread(impath2));


%% create DoG pyramids
disp('DEFINE SCALE SPACE (DIFFERENCE OF GAUSSIANS)')
[ octA1, octA2, octA3, octA4, dogA1, dogA2, dogA3, dogA4 ] = createDoG(imA);
[ octB1, octB2, octB3, octB4, dogB1, dogB2, dogB3, dogB4 ] = createDoG(imB);


%% find extrema
disp('FIND SCALE SPACE EXTREMA')
extremaA = findExtrema( dogA1, dogA2, dogA3, dogA4 );
extremaB = findExtrema( dogB1, dogB2, dogB3, dogB4 );


%% remove low contrast points & edges
disp('REMOVE LOW CONTRAST KEYPOINTS AND EDGES')
leftoversA = removeLowContrast(extremaA, octA1);
leftoversB = removeLowContrast(extremaB, octB1);

% removeEdges is not used because it might lead to incorrect matching of
% keypoints
keypointsA = leftoversA; %removeEdges(leftoversA, octA1);
keypointsB = leftoversB; %removeEdges(leftoversB, octB1);


%% find keypoint orientation
disp('FIND KEYPOINT ORIENTATIONS')
orientationsA = findOrientations( keypointsA, octA1 );
orientationsB = findOrientations( keypointsB, octB1 );

if (showK)
    showKeypoints( imA, keypointsA, orientationsA);
    showKeypoints( imB, keypointsB, orientationsB);
end


%% create descriptors
disp('DEFINE KEYPOINT SIFT DESCRIPTORS')
descriptorsA = createDescriptors( octA1, keypointsA, orientationsA);
descriptorsB = createDescriptors( octB1, keypointsB, orientationsB);


%% match keypoints
disp('MATCH KEYPOINTS')
matches = matchKeypoints(keypointsA(:,1:2), keypointsB(:,1:2), descriptorsA, descriptorsB);

if (showM)
    showMatches( imA, imB, matches(:, 1:2), matches(:, 3:4));
end

if size(matches,1)==0
    disp('NO MATCHES FOUND')
    return
end


%% find homography (ransac)
disp('FIND HOMOGRAPHY FOR STITCHING')
HBtoA = findHomography([matches(:,3:4),matches(:,1:2)]);
HAtoB = findHomography(matches);


%% stitch images
disp('STITCH IMAGES')
stitchedImage = stitchImages( imA, imB, HBtoA,HAtoB,useMRS);
end