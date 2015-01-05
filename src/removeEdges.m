function [ keypoints ] = removeEdges( extrema, im )
% Author: Sebastian Kirchner
% input: extrema ... N*2-vector of N extrema points
% input: im ... double image (grayscale) of keypoint scale
% output: keypoints ... extrema without edges (Harris-Corner Detector)


tempkeys = zeros(size(extrema));

% amount of good keypoints (= corners)
count = 0;

% get corners for every scaling level of the image
for j=1:max(extrema(:,3))
    % get corners using Harris
    temp   = corner(im(:,:,j), 'Harris');
    
    % add a leeway of +1 Pixel in every direction 
    temp_8 = add8Neighbors(temp); 
    
    % corner returns X Y coordinates, but we need Y X coordinates,
    % ==> switch them
    corners(j).X = temp(:,1);
    corners(j).Y = temp(:,2);
    
    corners(j).X8 = temp_8(:,1);
    corners(j).Y8 = temp_8(:,2);

end

% loop through all keypoints
for i=1:size(extrema,1)
    
    corn = [corners(extrema(i,3)).Y corners(extrema(i,3)).X];
    corn_8 = [corners(extrema(i,3)).Y8 corners(extrema(i,3)).X8];
    
    % if the keypoint is in the keypoints of the found corners, add to
    % temporary keypoints 
    if (ismember(extrema(i,1:2), corn))
        count = count + 1;
        tempkeys(count,:) = extrema(i,:);
        
    % if the keypoint is in the 8 neighborhood add it to temporary
    % keypoints
    elseif ismember(extrema(i,1:2), corn_8)
        count = count + 1;
        tempkeys(count,:) = extrema(i,:);
    end
end

% read out the remaining keypoints into keypoints
for i=1:count
    keypoints(i,:) = tempkeys(i,:);
end
end


%% SIMPLE FUNCTION TO ADD 8 NEIGHBORS TO ALL PREVIOUSLY FOUND CORNERS
function [ corners8 ] = add8Neighbors( corners )

corners8 = zeros(8*size(corners, 1), size(corners, 2));

for i=1:size(corners,1)
    for j=1:8:size(corners8,1)
        corners8(j,:)   =  [corners(i,1)-1, corners(i,2)-1];
        corners8(j+1,:) =  [corners(i,1)-1, corners(i,2)  ];
        corners8(j+2,:) =  [corners(i,1)-1, corners(i,2)+1];
        corners8(j+3,:) =  [corners(i,1)  , corners(i,2)-1];
        corners8(j+4,:) =  [corners(i,1)  , corners(i,2)+1];
        corners8(j+5,:) =  [corners(i,1)+1, corners(i,2)-1];
        corners8(j+6,:) =  [corners(i,1)+1, corners(i,2)  ];
        corners8(j+7,:) =  [corners(i,1)+1, corners(i,2)+1];
    end
    
end

end
