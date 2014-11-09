function [ descriptors ] = createDescriptors( image, keypoints, orientations )
%% CREATEDESCRIPTORS creates SIFT feature descriptors
% Author: Nikolaus Leopold
% input:        image ... (interpolated?) image (RGB? double)
%           keypoints ... N*2 vector of keypoint positions
%        orientations ... N*1 vector of keypoint orientations in radians
% output: descriptors ... N*128 vector of keypoint descriptors

%% POINTS FOR DISCUSSION:
% - use image frequency on which keypoint was found (Lowe et al)?
% - color image or b/w?
% - interpolate image beforehand (Lowe) !!
% - what happens on image edges (maybe just use one half of information)?
% - how should descriptor be indexed/accessible?
% - is the used normalization method ok?
%%

windowSize = 4;
binCount = 8;
center = zeros(2);
descriptors = zeros(size(keypoints,1), 16);

for k = 1:size(keypoints,1)
    
    kX = keypoints(k,1);
    kY = keypoints(k,2);
    
    % create histogram for all 16 sample windows around keypoint
    for i = -2:1
        for j = -2:1
            
            center(1) = kX + i*windowSize + windowSize/2;
            center(2) = kY + j*windowSize + windowSize/2;
            
            descriptors(k, i+j*4) = createOrientationHistogram(image, center, windowSize, binCount, orientations(k), windowSize/2);
            
        end
    end
    
    % normalize whole descriptor vector to unit length (euclidean norm)
    descriptors(k,:) / sqrt(sum(descriptors(k,:).^2));
    
    % cut off magnitudes > 0.2 to reduce effects of illumination changes
    descriptors(k,:) = min(descriptors(k,:), 0.2);
    
    % and normalize again
    descriptors(k,:) / sqrt(sum(descriptors(k,:).^2));
    
end



end

