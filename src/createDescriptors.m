function [ descriptors ] = createDescriptors( image, keypoints, orientations )
%% CREATEDESCRIPTORS creates SIFT feature descriptors
% Author: Nikolaus Leopold
% input:        image ... (interpolated?) double grayscale image
%           keypoints ... N*3 vector of keypoints
%        orientations ... N*1 vector of keypoint orientations in radians
% output: descriptors ... N*128 vector of keypoint descriptors

%% DISCUSS LATER:
% - interpolate image beforehand (Lowe) i.e. intermediate pixels ???
%%

windowSize = 4;
binCount = 8;
center = zeros(2, 1);
descriptors = zeros(size(keypoints,1), 128);

for k = 1:size(keypoints,1)
    
    kX = keypoints(k,1);
    kY = keypoints(k,2);
    
    % create histogram for all 16 sample windows around keypoint
    for i = 1:4
        for j = 1:4
            
            center(1) = kX + (i-3)*windowSize + windowSize/2;
            center(2) = kY + (j-3)*windowSize + windowSize/2;
            
            histogram = createOrientationHistogram(image, center, windowSize, binCount, orientations(k), windowSize/2);
            descriptors(k, 1+(i-1)*8+(j-1)*32 : i*8+(j-1)*32) = histogram;
            
        end
    end
    
    % normalize whole descriptor vector to unit length (euclidean norm)
    descriptors(k,:) = descriptors(k,:) / sqrt(sum(descriptors(k,:).^2));
    
    % cut off magnitudes > 0.2 to reduce effects of illumination changes
    descriptors(k,:) = min(descriptors(k,:), 0.2);
    
    % and normalize again
    descriptors(k,:) = descriptors(k,:) / sqrt(sum(descriptors(k,:).^2));
    
end



end

