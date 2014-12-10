function [ descriptors ] = createDescriptors( image, keypoints, orientations )
%% CREATEDESCRIPTORS creates SIFT feature descriptors
% Author: Nikolaus Leopold
% input:        image ... double grayscale image
%                         NOTE: internal representation where x are rows
%                         and y are columns! (x, y)
%           keypoints ... N*3 vector of keypoints (x, y, frequency level)
%        orientations ... N*1 vector of keypoint orientations in radians
% output: descriptors ... N*128 vector of N keypoint descriptors
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
    
    % only use keypoint if whole sample area (16 windows) lies within image bounds
    min = floor(windowSize*4/2);
    maxX = size(image,1) - floor(windowSize*4/2); % image has internal representation (x,y)
    maxY = size(image,2) - floor(windowSize*4/2);
    if (kX <= min || kY <= min || kX >= maxX || kY >= maxY)
        continue;
    end
    
    % create histogram for all 16 sample windows around keypoint
    for i = 1:4
        for j = 1:4
            
            % get center of current sample window
            center(1) = kX + (-3+i)*windowSize + windowSize/2; 
            center(2) = kY + (-3+j)*windowSize + windowSize/2;
            
            histogram = createOrientationHistogram(image, center, windowSize, binCount, orientations(k), windowSize/2);
            descriptors(k, 1+(i-1)*8+(j-1)*32 : i*8+(j-1)*32) = histogram; % histogram has 8 bins
            
        end
    end
    
    % normalize whole descriptor vector to unit length (euclidean norm)
    descriptors(k,:) = descriptors(k,:) / sqrt(sum(descriptors(k,:).^2));
    
    % cut off magnitudes > 0.2 to reduce effects of illumination changes
    descriptors(k,(descriptors(k,:)>0.2)) = 0.2;
    
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
%                       NOTE: internal representation where x are rows
%                       and y are columns! (x, y)
%            center ... 2*1 center position vector (x, y)
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

        x = startX + i;
        y = startY + j;

        % find gradient magnitude and orientation of current neighbor
        gradMagnitude = sqrt((im(x,y+1) - im(x,y-1))^2 + (im(x+1,y) - im(x-1,y))^2);
        gradOrientation = atan2((im(x,y+1) - im(x,y-1)), (im(x+1,y) - im(x-1,y))); % atan2 result is in [-pi, pi]
        gradOrientation(gradOrientation <= 0) = gradOrientation(gradOrientation <= 0) + 2*pi; % map interval to [0, 2pi]
        gradOrientation = gradOrientation - baseOrientation; % both are in [0, 2pi]
        gradOrientation(gradOrientation <= 0) = gradOrientation(gradOrientation <= 0) + 2*pi; % map again
            
        % add magnitude to histogram bin of corresponding orientation
        % magnitudes are gaussian weighted around center
        binIndex = ceil(gradOrientation / binSize); % is in [1, 8]
        weightedMagnitude = gradMagnitude * gaussKernel(j,i);
        histogram(binIndex) = histogram(binIndex) + weightedMagnitude;
    end
end


end


