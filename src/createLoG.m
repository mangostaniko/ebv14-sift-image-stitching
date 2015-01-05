function [logImages] = createLoG(input_image)
% Author: Sebastian Kirchner
% input: input_image ... image to create Laplacian of Gauss Images from
% output: logImages ... Laplacian of Gauss image Pyramid

% convert image to double
image = im2double(input_image);

% convert RGB images to Grayscale images
if (size(image, 3) == 3)
    image = rgb2gray(input_image);
end

%% CREATE GAUSSIAN PYRAMID ==> BLUR then SCALE DOWN
[gaussian_pyramid, levels] = createGaussPyr(image);

%% CREATE LoGs 
% G0 is lowest level of GaussPyramid, G4 is highest level
% to create LoGs do the following:
% LoG1 = G0 - expand(G1)
% LoG2 = G1 - expand(G2)
% ...
% LoGN = GN
for i=1:levels-1
size_image = size(gaussian_pyramid(i).scale);
logImages(i).scale = gaussian_pyramid(i).scale - imresize(gaussian_pyramid(i+1).scale, size_image, 'bilinear');
end

logImages(levels).scale = gaussian_pyramid(levels).scale;

end