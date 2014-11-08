function [ orientations ] = findOrientation( keypoints, im )
%% finds keypoint orientation (most prominent gradient among neighboring pixels)
% Author: Nikolaus Leopold
% input:     keypoints ... N*2-vector of keypoints
%                   im ... blurred double precision intensity image (b/w)
% output: orientations ... keypoint orientation in rad

%% POINTS FOR DISCUSSION:
% - check gradient on octave / frequency on which keypoint was found?
% - color image or b/w?
% - use radian or bin number for output orientation?
% - split keypoint in two if other bin has over 80 % of greatest bin magnitude?
%
%%

neighborhoodSize = 5;
binCount = 36;
orientations = zeros(size(keypoints,1));

for k = 1:size(keypoints,1)
    
    orientationHistogram = zeros(binCount); % magnitudes binned by orientation
    binSize = 2*pi/binCount; %bin size in radian
    
    % iterate over pixels in keypoint neighborhood
    startX = keypoints(k,1) - floor(neighborhoodSize/2);
    startY = keypoints(k,2) - floor(neighborhoodSize/2);
    for i = 0:neighborhoodSize
        for j = 0:neighborhoodSize
            
            x = startX + i;
            y = startY + j;
            
            % find gradient magnitude and orientation of current neighbor
            gradMagnitude = sqrt((im(x+1,y) - im(x-1,y))^2 + (im(x,y+1) - im(x,y-1))^2);
            gradOrientation = atan((im(x,y+1) - im(x,y-1)) / (im(x+1,y) - im(x-1,y)));
            
            % add magnitude to histogram bin of corresponding orientation
            binIndex = floor(gradOrientation / binSize);
            orientationHistogram(binIndex) = orientationHistogram(binIndex) + gradMagnitude;
        end
    end
    
    % the bin with greatest magnitude is our keypoint orientation (bin interval median)
    greatestBin = find(orientationHistogram == max(orientationHistogram), 1);
    orientations(k) = (greatestBin*binSize + (greatestBin+1)*binSize) / 2;
            
    % TODO: split keypoint in two if another bin has over 80 % of
    % the greatest bin magnitude ???
    
end
    
end

