function [ keypoints ] = removeEdges( extrema, im )
% Author: Sebastian Kirchner
% input: extrema ... N*2-vector of N extrema points
% input: im ... double image (grayscale) of keypoint scale
% output: keypoints ... extrema without edges (Harris-Corner Detector)

tempkeys = zeros(size(extrema));
count = 0;

% get corners for every scaling level of the image
for j=1:max(extrema(:,3))
    temp = corner(im(:,:,j), 'Harris');
    
    % corner returns X Y coordinates, but we need Y X coordinates, 
    % ==> switch them
    corners(:,:,j) = zeros(size(temp));
    corners(:,2,j) = temp(:,1);
    corners(:,1,j) = temp(:,2);
end

% loop through all keypoints
for i=1:size(extrema,1)
    
    % if the keypoint is in the keypoints of the found corners, add to
    % temporary keypoints
    if ismember(extrema(i,1:2), corners(:,:,extrema(i,3)));
        count = count + 1;
        tempkeys(count,:) = extrema(i,:);
        
    end
end

keypoints = zeros(size(tempkeys));

% read out the remaining keypoints into keypoints
for i=1:count
    keypoints(i,:) = tempkeys(i,:);
end
end

