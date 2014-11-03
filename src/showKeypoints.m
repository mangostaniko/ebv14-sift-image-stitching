function [] = showpoint( image, keypoints )
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
width = 3;
length = 24;

imcopy(point(1)-12:point(1)-10, point(2)-12:point(2)+12, 1) = 0;
imcopy(point(1)-12:point(1)-10, point(2)-12:point(2)+12, 2) = 0;
imcopy(point(1)-12:point(1)-10, point(2)-12:point(2)+12, 3) = 1;

imcopy(point(1)+10:point(1)+12, point(2)-12:point(2)+12, 1) = 0;
imcopy(point(1)+10:point(1)+12, point(2)-12:point(2)+12, 2) = 0;
imcopy(point(1)+10:point(1)+12, point(2)-12:point(2)+12, 3) = 1;

imcopy(point(1)-12:point(1)+12, point(2)-12:point(2)-10, 1) = 0;
imcopy(point(1)-12:point(1)+12, point(2)-12:point(2)-10, 2) = 0;
imcopy(point(1)-12:point(1)+12, point(2)-12:point(2)-10, 3) = 1;

imcopy(point(1)-12:point(1)+12, point(2)+10:point(2)+12, 1) = 0;
imcopy(point(1)-12:point(1)+12, point(2)+10:point(2)+12, 2) = 0;
imcopy(point(1)-12:point(1)+12, point(2)+10:point(2)+12, 3) = 1;

image_out = imcopy;

end



