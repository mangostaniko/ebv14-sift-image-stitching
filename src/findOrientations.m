function [ orientations ] = findOrientations( keypoints, images )
%% FINDORIENTATIONS finds keypoint orientation (most prominent gradient among neighboring pixels)
% Author: Nikolaus Leopold
% input:     keypoints ... N*3-vector of keypoints (x, y, frequency level)
%               images ... double precision intensity images (greyscale) 
%                          of all frequency/gauss levels
% output: orientations ... keypoint orientations in rad

%% DISCUSS LATER:
% - what is an appropriate windowSize and sigma?
% - select image by frequency or octave level of keypoint?
% - split keypoint in two if other bin has over 80 % of greatest bin magnitude (Lowe)?
%%

im = images(:,:,keypoints(3)); % select image of keypoint frequency level
windowSize = 5;
binCount = 36;
orientations = zeros(size(keypoints,1));

for k = 1:size(keypoints,1)
    
    % create histogram
    orientationHistogram = createOrientationHistogram(im, keypoints(k), windowSize, binCount, 0, 1)
    
    % the bin with greatest magnitude is our keypoint orientation (bin interval median)
    greatestBin = find(orientationHistogram == max(orientationHistogram), 1);
    orientations(k) = (greatestBin*binSize + (greatestBin+1)*binSize) / 2;
    
    
end
    
end

