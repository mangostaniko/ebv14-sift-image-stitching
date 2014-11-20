function [ keypoints ] = removeEdges( extrema, im )
% Author: Sebastian Kirchner
% input: extrema ... N*2-vector of N extrema points
% input: im ... double image (grayscale) of keypoint scale
% output: keypoints ... extrema without edges (Harris-Corner Detector)


tempkeys = zeros(size(extrema));
count = 1;
corners = zeros(size(im), max(extrema(:,3)));

% get corners for every scaling level of the image
for j=1:max(extrema(:,3))
    corners(:,:,j) = corner(im(:,:,j), Harris);
end

% loop through all keypoints
for i=1:size(extrema,1)
    
    % if the keypoint is in the keypoints of the found corners, add to
    % temporary keypoints
    if ismember(extrema(i,2), corners(:,:,extrema(i,3)));
        tempkeys(count,:) = extrema(i,:);
        count = count + 1;
    end
end

keypoints = zeros(size(tempkeys));

% read out the remaining keypoints into keypoints
for i=1:count
    keypoints(i,:) = tempkeys(i,:);
end
end

