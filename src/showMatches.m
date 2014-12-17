function [] = showMatches( image1, image2, keypoints1, keypoints2, gradients1, gradients2 )
% Author: Sebastian Kirchner
% input: image1 ... image1 (RGB double)
%        image2 ... image2 (RGB double)
%        keypoints1 ... keypoints image2
%        keypoints2 ... keypoints image2
% 
% This method takes the keypoints of image1 and image2, plots
% both images in one figure, highlights the keypoints and connects the
% corresponding keypoints. 
% For this the keypoints of the second image need to be adapted, to achieve
% that, the width of the first picture is added to the x-coordinates of the
% keypoints in the second image. 

imcopy1 = im2double(image1);
imcopy2 = im2double(image2);

% the length of the border (double the value 'half_len' in drawBorders()) 
radius = size(imcopy1, 2) * 0.02;
lineWid = (size(imcopy1, 1)*.003);

% Combine the 2 images into one image
jointImg = [imcopy1, imcopy2];

% Add the width of the 1st image to the x-coordinates of keypoints of 
% 2nd image
keypoints2 = [keypoints2(:,1)+size(imcopy1, 2) keypoints2(:,2)];

% Extract x and y Coordinates from keypoints1 and keypoints2 respectively
% and add them two corresponding vector (for plotting the line between 
% the keypoints)
kpXcoords = [keypoints1(:,1)+radius keypoints2(:,1)-radius];
kpYcoords = [keypoints1(:,2) keypoints2(:,2)];

figure;
% plot the joint Image
imshow(jointImg);
hold on;
for i = 1:size(keypoints1, 1)
    % m, n represent the corrected keypoints (keypoints2 x-coordinates + width of image1)
    key1 = keypoints1(i,:);
    key2 = keypoints2(i,:);
    
    % calculates X and Y for the line points to draw the angle of the gradients
    deg_X1 = [key1(1), key1(1)+radius*cos(gradients1(i))];
    deg_Y1 = [key1(2), key1(2)-radius*sin(gradients1(i))];

    deg_X2 = [key2(1), key2(1)+radius*cos(gradients1(i))];
    deg_Y2 = [key2(2), key2(2)-radius*sin(gradients1(i))];
    
    % plot the lines for the angle of the gradients
    line(deg_X1, deg_Y1, 'Color', [1, 0, 0], 'LineWidth', lineWid);
    line(deg_X2, deg_Y2, 'Color', [1, 0, 0], 'LineWidth', lineWid);

    
    % plot the borders around each keypoint

    rectangle('Curvature', [1 1], 'Position', [(key1(2)-margin) (key1(1)-margin) (2*margin) (2*margin)], 'EdgeColor', [0,0,1], 'LineWidth', lineWid);
    rectangle('Curvature', [1 1], 'Position', [(key2(2)-margin) (key2(1)-margin) (2*margin) (2*margin)], 'EdgeColor', [0,0,1], 'LineWidth', lineWid);
    
    % plot the lines connecting the corresponding keypoints in Image1 and
    % Image2
    plot(kpXcoords(i,:), kpYcoords(i,:), 'Color', [1, 0, 0], 'LineWidth', 1.5);
end

% splits image1 and image2
plot([size(jointImg, 1) size(jointImg, 1)], [0, size(jointImg, 2)], 'Color', [0, 0, 0], 'LineWidth', 3);
hold off;

end