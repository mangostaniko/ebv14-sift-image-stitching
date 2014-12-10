function [ panorama ] = stitchImages( image1, image2, H )
% Author: Patrick Wahrmann & ...
% input: image1 ... image1 (RGB double)
%        image2 ... image2 (RGB double)
%        H      ... Homographie-Matrix
% output: panorama ... image1 and image2 stitched together 
panorama = zeros(size(image1,1)+2*size(image2,1),size(image1,2)+2*size(image2,2),3); %Size of the resulting image, because theoretically the second image could could be completely above, beyond, right or left of the first image

% Adding image1 to the final image
xp = (size(image2,1)+size(image1,1))-size(image2,1)
xim1 = size(image1,1)
yp = (size(image2,2)+size(image1,2))-size(image2,2)
yim1 = size(image1,2)
zp = size(panorama,3)
zim1 = size(image1,3)
panorama(size(image2,1)+1:(size(image2,1)+size(image1,1)),size(image2,2)+1:(size(image2,2)+size(image1,2)),:) = image1;



end

