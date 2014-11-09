function [] = showKeypoints( image, keypoints )
% Author: Sebastian Kirchner
% input: image ... image (RGB double)
%        keypoints ... keypoints Vector

imcopy = im2double(image);

for i = 1:size(keypoints, 1)
    m = keypoints(i,:);
    imcopy= drawBorders(imcopy, m);
end

imshow(imcopy);


end

function [] = showMatches( image1, image2, keypoints1, keypoints2 )
% Author: Sebastian Kirchner
% input: image1 ... image1 (RGB double)
%        image2 ... image2 (RGB double)
%        keypoints1 ... keypoints image1
%        keypoints2 ... keypoints image2

imshow();


end

function [image_out] = drawBorders(image_in, point)

imcopy = image_in;

% width of the borderline
wid = 3;
% length of the borderline
half_len = 12;


imcopy(point(1)-half_len:point(1)-(half_len-wid), point(2)-half_len:point(2)+half_len, 1) = 0;
imcopy(point(1)-half_len:point(1)-(half_len-wid), point(2)-half_len:point(2)+half_len, 2) = 0;
imcopy(point(1)-half_len:point(1)-(half_len-wid), point(2)-half_len:point(2)+half_len, 3) = 1;

imcopy(point(1)+(half_len-wid):point(1)+half_len, point(2)-half_len:point(2)+half_len, 1) = 0;
imcopy(point(1)+(half_len-wid):point(1)+half_len, point(2)-half_len:point(2)+half_len, 2) = 0;
imcopy(point(1)+(half_len-wid):point(1)+half_len, point(2)-half_len:point(2)+half_len, 3) = 1;

imcopy(point(1)-half_len:point(1)+half_len, point(2)-half_len:point(2)-(half_len-wid), 1) = 0;
imcopy(point(1)-half_len:point(1)+half_len, point(2)-half_len:point(2)-(half_len-wid), 2) = 0;
imcopy(point(1)-half_len:point(1)+half_len, point(2)-half_len:point(2)-(half_len-wid), 3) = 1;

imcopy(point(1)-half_len:point(1)+half_len, point(2)+(half_len-wid):point(2)+half_len, 1) = 0;
imcopy(point(1)-half_len:point(1)+half_len, point(2)+(half_len-wid):point(2)+half_len, 2) = 0;
imcopy(point(1)-half_len:point(1)+half_len, point(2)+(half_len-wid):point(2)+half_len, 3) = 1;

image_out = imcopy;

end



