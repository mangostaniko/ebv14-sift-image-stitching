function [ keypoints ] = removeEdges( extrema, im )
% Author: Sebastian Kirchner
% input: extrema ... N*2-vector of N extrema points
% input: im ... double image (grayscale) of keypoint scale
% output: keypoints ... extrema without edges (Harris-Corner Detector)

tempkeys = zeros(size(extrema));
count = 0;

% get corners for every scaling level of the image
for j=1:max(extrema(:,3))
    temp   = corner(im(:,:,j), 'Harris');

%     temp_8 = add8Neighbours(temp); 
    
    % corner returns X Y coordinates, but we need Y X coordinates,
    % ==> switch them
%     corners_8(:,:,j) = zeros(size(temp_8));
%     corners_8(:,2,j) = temp(:,1);
%     corners_8(:,1,j) = temp(:,2);
    corners(j).X = temp(:,1);
    corners(j).Y = temp(:,2);
%     corners(:,:,j) = zeros(dimension);
%     corners(:,2,j) = temp(:,1);
%     corners(:,1,j) = temp(:,2);
end

% loop through all keypoints
for i=1:size(extrema,1)
    
    % if the keypoint is in the keypoints of the found corners, a dd to
    % temporary keypoints
    corn = [corners(extrema(i,3)).Y corners(extrema(i,3)).X];
    if ismember(extrema(i,1:2), corn) % || ismember(extrema(i,1:2), corners_8(:,:,extrema(i,3))));
        count = count + 1;
        tempkeys(count,:) = extrema(i,:);
    end
end

%keypoints = zeros(size(tempkeys));

% read out the remaining keypoints into keypoints
for i=1:count
    keypoints(i,:) = tempkeys(i,:);
end
end




function [ corners8 ] = add8Neighbours( corners )

corners8 = zeros(8*size(corners, 1), size(corners, 2));

for i=1:size(corners,1)
    for j=1:8:size(corners8,1)
        corners8(j,:)   =  [corners(i,1)-1, corners(i,2)-1];
        corners8(j+1,:) =  [corners(i,1)-1, corners(i,2)  ];
        corners8(j+2,:) =  [corners(i,1)-1, corners(i,2)+1];
        corners8(j+3,:) =  [corners(i,1)  , corners(i,2)-1];
        corners8(j+4,:) =  [corners(i,1)  , corners(i,2)+1];
        corners8(j+5,:) =  [corners(i,1)+1, corners(i,2)-1];
        corners8(j+6,:) =  [corners(i,1)+1, corners(i,2) 1];
        corners8(j+7,:) =  [corners(i,1)+1, corners(i,2)+1];
    end
    
end

end
