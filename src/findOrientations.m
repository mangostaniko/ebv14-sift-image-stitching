function [ orientations ] = findOrientations( keypoints, im )
%% FINDORIENTATIONS finds keypoint orientation (most prominent gradient among neighboring pixels)
% Author: Nikolaus Leopold
% input:     keypoints ... N*2-vector of keypoints
%                   im ... blurred double precision intensity image (b/w)
% output: orientations ... keypoint orientation in rad

%% POINTS FOR DISCUSSION:
% - use image frequency on which keypoint was found (Lowe et al) !!
% - gaussian weight for orientation collection region (Lowe)? implemented: yes
% - color image or b/w?
% - use radian or bin number for output orientation? assumed: radian
% - split keypoint in two if other bin has over 80 % of greatest bin magnitude (Lowe)?
% - what is an appropriate windowSize and sigma?
%
%%

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

