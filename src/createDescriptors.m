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

% interpolate image (according to Lowe we use intermediate pixels)
image = imfilter(image, fspecial('average', 2));

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

function [ histogram ] = createOrientationHistogram( im, center, windowSize, binCount, baseOrientation, sigma)
%% CREATEORIENTATIONHISTOGRAM creates gradient orientation histogram of sample window around center point
%   collects gradient magnitudes in sample window around center point and
%   adds to bins of corresponding gradient orientation, applying gaussian
%   distributed weights to the magnitudes
% Author: Nikolaus Leopold
% input:         im ... double grayscale image of keypoint frequency level
%            center ... 2*1 center position vector
%        windowSize ... size of sampling window sides
%          binCount ... number of bins (orientation intervals) for classification
%   baseOrientation ... orientations are measured relative to this (radians)
%             sigma ... sigma for gaussian weighting of magnitudes
% output: histogram ... binCount*1 vector of summed magnitudes per orientation bin
%%

histogram = zeros(binCount, 1); % magnitudes binned by orientation
binSize = 2*pi/binCount; % bin size in radian
gaussKernel = fspecial('gaussian', windowSize, sigma);

% collect magnitudes in sample window and bin by orientation
startX = center(1) - floor(windowSize/2);
startY = center(2) - floor(windowSize/2);
for i = 1:windowSize
    for j = 1:windowSize

        x = startX + i - 1;
        y = startY + j - 1;
        if (x <= 1 || y <= 1 || x >= size(im,2)-1 || y >= size(im,1)-1)
            continue;
        end

        % find gradient magnitude and orientation of current neighbor
        gradMagnitude = sqrt((im(x+1,y) - im(x-1,y))^2 + (im(x,y+1) - im(x,y-1))^2);
        gradOrientation = atan2((im(x,y+1) - im(x,y-1)), (im(x+1,y) - im(x-1,y)));
        gradOrientation(gradOrientation < 0) = gradOrientation(gradOrientation < 0) + 2*pi; % map interval to [0, 2pi]
        gradOrientation = gradOrientation - baseOrientation;
        gradOrientation(gradOrientation < 0) = gradOrientation(gradOrientation < 0) + 2*pi; % map again
            
        % add magnitude to histogram bin of corresponding orientation
        % magnitudes are gaussian weighted around center
        binIndex = floor(gradOrientation / binSize) + 1;
        weightedMagnitude = gradMagnitude * gaussKernel(j,i);
        histogram(binIndex) = histogram(binIndex) + weightedMagnitude;
    end
end


end


