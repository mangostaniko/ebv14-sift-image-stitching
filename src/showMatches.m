function [] = showMatches( image1, image2, keypoints1, keypoints2 )
% Author: Sebastian Kirchner
% input: image1 ... image1 (RGB double)
%        image2 ... image2 (RGB double)
%        keypoints1 ... keypoints image2 k*(x,y)
%        keypoints2 ... keypoints image2 k*(x,y) 
% note: here, x is image row, y is image column!
% 
% This method takes the keypoints of image1 and image2, plots
% both images in one figure, highlights the keypoints and connects the
% corresponding keypoints. 
% For this the keypoints of the second image need to be adapted, to achieve
% that, the width of the first picture is added to the x-coordinates of the
% keypoints in the second image. 

% convert both images to double
imcopy1 = im2double(image1);
imcopy2 = im2double(image2);

%% HIGHLIGHT BORDER PROPERTIES
radius = size(imcopy1, 2) * 0.01;
lineWid = (size(imcopy1, 1)*.003);
keypointcolor = [0, 0.8, 1];
linecolor = [1, 1, 1];

%% MAKE SURE to enable drawing the pictures even if height differs
im1_rows = size(imcopy1, 1);
im1_cols = size(imcopy1, 2);
im2_rows = size(imcopy2, 1);
im2_cols = size(imcopy2, 2);

% set the larger value to height
if im1_rows > im2_rows
    rows = im1_rows;
else
    rows = im2_rows;
end

%% COMBINE the 2 images into one image using the height of the larger one
jointImg = zeros(rows, im1_cols+im2_cols);

% read in the images
for i=1:3
    jointImg(1:im1_rows, 1:im1_cols, i) = imcopy1(:,:,i);
    jointImg(1:im2_rows, im1_cols+1:end, i) = imcopy2(:,:,i);
end

%% Add the width of the 1st image to the x-coordinates of keypoints of 
% 2nd image
keypoints2 = [keypoints2(:,1) keypoints2(:,2)+size(imcopy1, 2)];

% Extract x and y Coordinates from keypoints1 and keypoints2 respectively
% and add them two corresponding vector (for plotting the line between 
% the keypoints)
kpXcoords = [keypoints1(:,2)+radius keypoints2(:,2)-radius];
kpYcoords = [keypoints1(:,1) keypoints2(:,1)];

%% START plotting 
figure;
imshow(jointImg);
hold on;

% line seperating image1 and image2
plot([size(image1, 2) size(image1, 2)], [0, size(image2, 1)], 'Color', [0, 0, 0], 'LineWidth', 1);

for i = 1:size(keypoints1, 1)
    % m, n represent the corrected keypoints (keypoints2 x-coordinates + width of image1)
    key1 = keypoints1(i,:);
    key2 = keypoints2(i,:);

    % plot the borders around each keypoint and make sure there are
    % keypoints to avoid errors
    if (~(sum(key1) == 0 || sum(key2) == 0))
        rectangle('Curvature', [1 1], 'Position', [(key1(2)-radius) (key1(1)-radius) (2*radius) (2*radius)], 'EdgeColor', keypointcolor, 'LineWidth', lineWid);
        rectangle('Curvature', [1 1], 'Position', [(key2(2)-radius) (key2(1)-radius) (2*radius) (2*radius)], 'EdgeColor', keypointcolor, 'LineWidth', lineWid);

        % plot the lines connecting the corresponding keypoints in Image1 and
        % Image2
        plot(kpXcoords(i,:), kpYcoords(i,:), 'Color', linecolor, 'LineWidth', 1.5);
    end
end

hold off;

end