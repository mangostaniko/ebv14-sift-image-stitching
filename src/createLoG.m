function [logImages] = createLoG(input_image)

image = im2double(input_image);
if (size(image, 3) == 3)
    image = rgb2gray(input_image);
end

gauss_filt = fspecial('gaussian', [5 5], 0.5);


%% CREATE GAUSSIAN PYRAMID ==> BLUR then SCALE DOWN
[gaussian_pyramid, levels] = createGaussPyr(image);

%% CREATE LoGs
for i=1:levels-1
size_image = size(gaussian_pyramid(i).scale);
logImages(i).scale = gaussian_pyramid(i).scale - imresize(gaussian_pyramid(i+1).scale, size_image, 'bilinear');
end
% size_image = size(gaussian_pyramid(2).scale);
% logImages(2).scale = gaussian_pyramid(2).scale - imresize(gaussian_pyramid(3).scale, size_image, 'bilinear');
% 
% size_image = size(gaussian_pyramid(3).scale);
% logImages(3).scale = gaussian_pyramid(3).scale - imresize(gaussian_pyramid(4).scale, size_image, 'bilinear');

logImages(levels).scale = gaussian_pyramid(levels).scale;

end