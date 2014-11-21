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
margin = 35;
%size(imcopy, 2) * 0.04;
lineWid = 2;
%(size(imcopy, 1)*.001);

figure;
hold on;
imshow(imcopy);
for i = 1:size(keypoints, 1)
    m = keypoints(i,:);
    
    % calculates X and Y for the line points to draw the degree in the
    % circle
    % formula for x_end: x_start + r * cos(a)
    % formula for y_end: y_start - r * sin(a); - because we are not in a
    % true coordinate system, but using matrix indices
    if size(keypoints, 1) == max(size(gradients))
        deg_X = [keypoints(i,1), keypoints(i,1)+margin*cos(gradients(i))];
        deg_Y = [keypoints(i,2), keypoints(i,2)-margin*sin(gradients(i))];
        
        line(deg_X, deg_Y, 'Color', [1, 0, 0], 'LineWidth', lineWid);
    end
    
    rectangle('Curvature', [1 1], 'Position', [(m(1)-margin) (m(2)-margin) (2*margin) (2*margin)], 'EdgeColor', [0,0,1], 'LineWidth', lineWid);
end
hold off

end