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
for i = 0:windowSize-1
    for j = 0:windowSize-1

        x = startX + i;
        y = startY + j;
        if (x <= 0 || y <= 0 || x >= size(im,2) || y >= size(im,1))
            continue;
        end

        % find gradient magnitude and orientation of current neighbor
        gradMagnitude = sqrt((im(x+1,y) - im(x-1,y))^2 + (im(x,y+1) - im(x,y-1))^2);
        gradOrientation = atan((im(x,y+1) - im(x,y-1)) / (im(x+1,y) - im(x-1,y))) - baseOrientation;

        % add magnitude to histogram bin of corresponding orientation
        % magnitudes are gaussian weighted around center
        binIndex = floor(gradOrientation / binSize);
        weightedMagnitude = gradMagnitude * gaussKernel(j,i);
        histogram(binIndex) = histogram(binIndex) + weightedMagnitude;
    end
end


end

