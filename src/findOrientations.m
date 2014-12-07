function [ orientations ] = findOrientations( keypoints, images )
%% FINDORIENTATIONS finds keypoint orientation (most prominent gradient among neighboring pixels)
% Author: Nikolaus Leopold
% input:     keypoints ... N*3-vector of keypoints (x, y, frequency level)
%               images ... double precision intensity images (greyscale) 
%                          of all frequency/gauss levels
% output: orientations ... keypoint orientations in rad

%% DISCUSS LATER:
% - what is an appropriate windowSize and sigma?
% - split keypoint in two if other bin has over 80 % of greatest bin magnitude (Lowe)?
%%

windowSize = 5;
binCount = 36;
binSize = 2*pi/binCount; % bin size in radian
orientations = zeros(size(keypoints,1));

for k = 1:size(keypoints,1)
    
    im = images(:,:,keypoints(k,3)); % select image of keypoint frequency level
    
    % create histogram
    orientationHistogram = createOrientationHistogram(im, keypoints(k,1:2), windowSize, binCount, 0, 1);
    
    % the bin with greatest magnitude is our keypoint orientation (bin interval median)
    greatestBin = find(orientationHistogram == max(orientationHistogram), 1);
    orientations(k) = (greatestBin*binSize + (greatestBin+1)*binSize) / 2;
    
    
end
    
end

