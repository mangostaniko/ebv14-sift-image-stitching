function [] = showKeypoints( image, keypoints )
% Author: Sebastian Kirchner
% input: image ... image (RGB double)
%        keypoints ... keypoints Vector

imcopy = im2double(image);

figure;
hold on;
imshow(imcopy);
for i = 1:size(keypoints, 1)
    m = keypoints(i,:);
    drawBorders(imcopy, m);
end
hold off

end

function [] = showMatches( image1, image2, keypoints1, keypoints2 )
% Author: Sebastian Kirchner
% input: image1 ... image1 (RGB double)
%        image2 ... image2 (RGB double)
%        keypoints1 ... keypoints image1
%        keypoints2 ... keypoints image2
% 
imcopy1 = im2double(image1);
imcopy2 = im2double(image2);
% 
% %figure;
% hold on;
% imagesc([imcopy1 imcopy2]);
% for i = 1:size(keypoints1, 1)
%     m = keypoints1(i,:);
%     drawBorders(imcopy1, m);
%     
%     n = keypoints2(i,:);
%     drawBorders(imcopy2,n);
% end
% 
% hold off;
width = size(imcopy1, 2);

kpXcoords = [keypoints1(:,1) keypoints2(:,1)+width];
kpYcoords = [keypoints1(:,2) keypoints2(:,2)];
jointImg = [imcopy1, imcopy2];

figure;
hold on;
imshow(jointImg);
plot(kpXcoords, kpYcoords, 'r', 4);
hold off;

end

function [] = drawBorders(image_in, point)

imcopy = image_in;
% image properties
width = size(imcopy, 1);
height = size(imcopy, 2);

% border properties
wid = .003 * width;
half_len = 0.02 * height;
color = [1, 1, 0];

% point coordinates
x = point(1);
y = point(2);

line([x-half_len, x+half_len], [y-half_len, y-half_len], 'Color', color, 'LineWidth', wid); % north horizontal line
line([x+half_len, x+half_len], [y-half_len, y+half_len], 'Color', color, 'LineWidth', wid); % east vertical line
line([x-half_len, x+half_len], [y+half_len, y+half_len], 'Color', color, 'LineWidth', wid); % south horizontal line
line([x-half_len, x-half_len], [y-half_len, y+half_len], 'Color', color, 'LineWidth', wid); % west vertical line

end


%%%%% TURNED OUT NOT NEEDED :D

% clipping if interest points too close to image
% % too close to left border of image
% if (x-half_len < 0)
%
%     % too close to upper border of image
%     if (y - half_len < 0)
%         line([0, x+half_len], [y+half_len, y+half_len], 'Color', color, 'LineWidth', wid); % south horizontal line
%         line([x+half_len, x+half_len], [0, y+half_len], 'Color', color, 'LineWidth', wid); % east vertical line
%
%     % too close to lower border of image
%     elseif (y + half_len > height)
%         line([0, x+half_len], [y-half_len, y-half_len], 'Color', color, 'LineWidth', wid); % north horizontal line
%         line([x+half_len, x+half_len], [y-half_len, height], 'Color', color, 'LineWidth', wid); % east vertical line
%     end
%
% elseif (x+half_len > width)
%
%     % too close to upper border of image
%     if (y - half_len < 0)
%         line([x-half_len, width], [y+half_len, y+half_len], 'Color', color, 'LineWidth', wid); % south horizontal line
%         line([x-half_len, x-half_len], [0, y+half_len], 'Color', color, 'LineWidth', wid); % west vertical line
%
%     % too close to lower border of image
%     elseif (y + half_len > height)
%         line([x-half_len, width], [y-half_len, y-half_len], 'Color', color, 'LineWidth', wid); % north horizontal line
%         line([x-half_len, x-half_len], [y-half_len, height], 'Color', color, 'LineWidth', wid); % west vertical line
%     end
% end



