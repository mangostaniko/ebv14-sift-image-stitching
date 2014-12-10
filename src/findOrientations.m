function [ orientations ] = findOrientations( keypoints, images )
%% FINDORIENTATIONS finds keypoint orientation (most prominent gradient among neighboring pixels)
% Author: Nikolaus Leopold
% input:     keypoints ... N*3-vector of keypoints (x, y, frequency level)
%               images ... double precision intensity images (greyscale) 
%                          of all frequency/gauss levels
%                          NOTE: internal representation where x are rows
%                          and y are columns! (x, y, frequency)
% output: orientations ... keypoint orientations in rad

%% DISCUSS LATER:
% - what is an appropriate windowSize and sigma?
% - split keypoint in two if other bin has over 80 % of greatest bin magnitude (Lowe)?
%%

windowSize = 9;
binCount = 36;
binSize = 2*pi/binCount; % bin size in radian
orientations = zeros(size(keypoints,1));

for k = 1:size(keypoints,1)
    
    % NOTE: internal image representation (octA) where x are rows and y are columns! (x, y, frequency)
    image = images(:,:,keypoints(k,3)); % select image of keypoint frequency level
    
    kX = keypoints(k,1);
    kY = keypoints(k,2);
    
    % only use keypoint if whole window around keypoint lies within image bounds
    min = floor(windowSize/2);
    maxX = size(image,1) - floor(windowSize/2);
    maxY = size(image,2) - floor(windowSize/2);
    if (kX <= min || kY <= min || kX >= maxX || kY >= maxY)
        continue;
    end
    orientationHistogram = createOrientationHistogram(image, keypoints(k,1:2), windowSize, binCount, 5);
    
    % the bin with greatest magnitude is our keypoint orientation (bin interval median)
    greatestBin = find(orientationHistogram == max(orientationHistogram), 1);
    orientations(k) = ((greatestBin-1)*binSize + (greatestBin)*binSize)/2;
    
    
end
    
end

function [ histogram ] = createOrientationHistogram( im, center, windowSize, binCount, sigma)
%% creates gradient orientation histogram of sample window around center point
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
            
        % add magnitude to histogram bin of corresponding orientation
        % magnitudes are gaussian weighted around center
        binIndex = ceil(gradOrientation / binSize); % is in [1, 36]
        weightedMagnitude = gradMagnitude * gaussKernel(j,i);
        histogram(binIndex) = histogram(binIndex) + weightedMagnitude;
    end
end


end

