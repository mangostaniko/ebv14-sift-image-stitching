function [] = showKeypoints( image, keypoints )
% Author: Sebastian Kirchner
% input: image ... image (RGB double)
%        keypoints ... keypoints Vector with (x y) pairs
%
% Draws a circle around the keypoints to highlight them.
%
%

imcopy = im2double(image);

% border properties 
margin = size(imcopy, 2) * 0.04;
lineWid = (size(imcopy, 1)*.005);

figure;
hold on;
imshow(imcopy);
for i = 1:size(keypoints, 1)
    m = keypoints(i,:);
   rectangle('Curvature', [1 1], 'Position', [(m(1)-margin) (m(2)-margin) (2*margin) (2*margin)], 'EdgeColor', [0,0,1], 'LineWidth', lineWid);
end
hold off

end