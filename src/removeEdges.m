function [ keypoints ] = removecorners( extrema, im )
% Author: Sebastian Kirchner
% input: extrema ... N*2-vector of N extrema points
% input: im ... double image (grayscale) of keypoint scale
% output: keypoints ... extrema without edges (Harris-Corner Detector)

corners = corner(im, Harris);
tempkeys = zeros(size(extrema));
count = 1;
for i=1:size(extrema,1)
    if ismember(extrema(i,:), corners);
        tempkeys(count,:) = extrema(i,:);
        count = count + 1;
    end
end

for i=1:count
    keypoints(i,:) = tempkeys(i,:);
end




end

