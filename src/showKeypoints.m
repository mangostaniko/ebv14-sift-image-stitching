function [] = showKeypoints( image, keypoints, gradients )
% Author: Sebastian Kirchner
% input: image ... image (RGB double)
%        keypoints ... keypoints Vector with (x y) pairs
%
% Draws a circle around the keypoints to highlight them.
%
%

imcopy = im2double(image);

% border properties
radius = 20;
%size(imcopy, 2) * 0.04;
lineWid = 2;
%(size(imcopy, 1)*.001);

figure;
hold on;
imshow(imcopy);
for i = 1:size(keypoints, 1)
    k = keypoints(i,:);
    
    % draw orientation as line from center
    % formula for x: x_start + r * cos(a)
    % formula for y: y_start - r * sin(a); '-' because we are not in a
    % true coordinate system, but using matrix indices
    if size(keypoints, 1) == max(size(gradients))
        X = [keypoints(i,2), keypoints(i,2) + radius*cos(gradients(i))];
        Y = [keypoints(i,1), keypoints(i,1) - radius*sin(gradients(i))];
        
        % X and Y contain start and end positions of x and y components
        line(X, Y, 'Color', [1, 0, 0], 'LineWidth', lineWid);
    end
    
    % draw circle
    rectangle('Curvature', [1 1], 'Position', [(k(2)-radius) (k(1)-radius) (2*radius) (2*radius)], 'EdgeColor', [1,0,0], 'LineWidth', lineWid);
end

hold off

end