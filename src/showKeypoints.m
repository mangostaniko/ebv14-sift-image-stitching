function [] = showKeypoints( image, keypoints, varargin )
% Author: Sebastian Kirchner
% input:        image ... image (RGB double)
%           keypoints ... keypoints Vector with k (x y) pairs
%        orientations ... keypoint gradient orientations in radian [0, 2pi]
%
% Draws a circle around keypoints to highlight them and shows the keypoint orientation.

% convert image to double
imcopy = im2double(image);

%% HIGHLIGHTING BORDERS PROPERTY
radius = 8;
lineWid = 1;
color = [0, 0.8, 1];
if nargin < 3
    orientations = 0;
end

%% DRAW IN FIGURE ON THE IMAGE
figure;
hold on;
imshow(imcopy);
for i = 1:size(keypoints, 1)
    k = keypoints(i,:);
    
    % draw orientation as line from center
    % formula for x: x_start + r * cos(a)
    % formula for y: y_start - r * sin(a); '-' because we are not in a
    % true coordinate system, but using matrix indices
    if orientations ~= 0
        if size(keypoints, 1) == max(size(orientations))
            X = [keypoints(i,2), keypoints(i,2) + radius*cos(orientations(i))];
            Y = [keypoints(i,1), keypoints(i,1) - radius*sin(orientations(i))];
            
            % X and Y contain start and end positions of x and y components
            line(X, Y, 'Color', color, 'LineWidth', lineWid);
        end
    end
    
    % draw circle to highlight keypoints
    rectangle('Curvature', [1 1], 'Position', [(k(2)-radius) (k(1)-radius) (2*radius) (2*radius)], 'EdgeColor', color, 'LineWidth', lineWid);
end

hold off

end