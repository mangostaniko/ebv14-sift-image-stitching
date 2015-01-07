function [ stitchedImage ] = main( impath1, impath2, useMRS, showK, showM)
% input: impath1, impath2 ... paths to images (JPG or PNG)
%        useMRS ... boolean, use Multi-Resolution-Splines?
%        showK ... boolean, show all found keypoints?
%        showM ... boolean, show all found matches?
% output: stitchedImage ... stitched image (JPG or PNG)

%% read and convert images
% note: in images x are columns, y are rows.
% however later we use an internal representation which is (x,y)
disp('READ IMAGES')
global guiHandle;
set(guiHandle.text19, 'String','[ 5%] READING IMAGES...');
drawnow; % forces the GUI to redraw
imA = im2double(imread(impath1));
imB = im2double(imread(impath2));


%% create DoG pyramids
disp('DEFINE SCALE SPACE (DIFFERENCE OF GAUSSIANS)')
set(guiHandle.text19, 'String','[10%] DEFINING SCALE SPACE (DIFFERENCE OF GAUSSIANS)...');
drawnow; % forces the GUI to redraw

[ octA1, octA2, octA3, octA4, dogA1, dogA2, dogA3, dogA4 ] = createDoG(imA);
[ octB1, octB2, octB3, octB4, dogB1, dogB2, dogB3, dogB4 ] = createDoG(imB);


%% find extrema
disp('FIND SCALE SPACE EXTREMA')
set(guiHandle.text19, 'String','[15%] FIND SCALE SPACE EXTREMA...');
drawnow; % forces the GUI to redraw
extremaA = findExtrema( dogA1, dogA2, dogA3, dogA4 );
extremaB = findExtrema( dogB1, dogB2, dogB3, dogB4 );


%% remove low contrast points & edges
disp('REMOVE LOW CONTRAST KEYPOINTS AND EDGES')
set(guiHandle.text19, 'String','[25%] REMOVING LOW CONTRAST KEYPOINTS AND EDGES...');
drawnow; % forces the GUI to redraw

leftoversA = removeLowContrast(extremaA, octA1);
leftoversB = removeLowContrast(extremaB, octB1);
keypointsA = leftoversA; removeEdges(leftoversA, octA1);
keypointsB = leftoversB; removeEdges(leftoversB, octB1);

drawnow();


%% find keypoint orientation
disp('FIND KEYPOINT ORIENTATIONS')
set(guiHandle.text19, 'String','[30%] FINDING KEYPOINT ORIENTATIONS...');
drawnow; % forces the GUI to redraw

orientationsA = findOrientations( keypointsA, octA1 );
orientationsB = findOrientations( keypointsB, octB1 );

if showK
    showKeypoints( imA, keypointsA, orientationsA);
    showKeypoints( imB, keypointsB, orientationsB);
end


%% create descriptors
disp('DEFINE KEYPOINT SIFT DESCRIPTORS')
set(guiHandle.text19, 'String','[45%] DEFINING KEYPOINT SIFT DESCRIPTORS...');
drawnow; % forces the GUI to redraw

descriptorsA = createDescriptors( octA1, keypointsA, orientationsA);
descriptorsB = createDescriptors( octB1, keypointsB, orientationsB);


%% match keypoints
disp('MATCH KEYPOINTS')
set(guiHandle.text19, 'String','[50%] MATCHING KEYPOINTS...');
drawnow; % forces the GUI to redraw

matches = matchKeypoints(keypointsA(:,1:2), keypointsB(:,1:2), descriptorsA, descriptorsB);

if showM
    showMatches( imA, imB, matches(:, 1:2), matches(:, 3:4));
end


%% find homography (ransac)
disp('FIND HOMOGRAPHY FOR STITCHING')
set(guiHandle.text19, 'String','[55%] SEARCHING FOR HOMOGRAPHY USED FOR STITCHING...');
drawnow; % forces the GUI to redraw

HBtoA = findHomography([matches(:,3:4),matches(:,1:2)]);
HAtoB = findHomography(matches);


%% stitch images
disp('STITCH IMAGES')
set(guiHandle.text19, 'String','[95%] STITCHING IMAGES...');
drawnow; % forces the GUI to redraw

stitchImages( imA, imB, HBtoA,HAtoB,useMRS);

set(guiHandle.text19, 'String','[100%] DONE.');
drawnow; % forces the GUI to redraw
end
