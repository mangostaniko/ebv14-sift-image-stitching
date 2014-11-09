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

function [] = drawBorders(image_in, point)
% Author: Sebastian Kirchner
% input: image_in ... image (RGB double)
%        point ... single Keypoint
% 
% This function is used by showKeypoints.m and showMatches.M
% 

imcopy = image_in;

% image properties
width = size(imcopy, 1);

% border properties
wid = .005 * width;
half_len = size(imcopy, 2) * 0.02;
color = [0, 1, 1];

% point coordinates
x = point(1);
y = point(2);

line([x-half_len, x+half_len], [y-half_len, y-half_len], 'Color', color, 'LineWidth', wid); % north horizontal line
line([x+half_len, x+half_len], [y-half_len, y+half_len], 'Color', color, 'LineWidth', wid); % east vertical line
line([x-half_len, x+half_len], [y+half_len, y+half_len], 'Color', color, 'LineWidth', wid); % south horizontal line
line([x-half_len, x-half_len], [y-half_len, y+half_len], 'Color', color, 'LineWidth', wid); % west vertical line

end


%%%%% TURNS OUT NOT NEEDED :D

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



