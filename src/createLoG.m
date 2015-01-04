function [logImages] = createLoG(input_image)

image = im2double(input_image);
if (size(image, 3) == 3)
    image = rgb2gray(input_image);
end

gauss_filt = fspecial('gaussian', [5 5], 0.5);


%% CREATE GAUSSIAN PYRAMID ==> BLUR then SCALE DOWN
gaussian_pyramid(1).scale = image;

filtered = imfilter(gaussian_pyramid(1).scale, gauss_filt, 'replicate');
gaussian_pyramid(2).scale = filtered(1:2:end,1:2:end);

filtered = imfilter(gaussian_pyramid(2).scale, gauss_filt, 'replicate');
gaussian_pyramid(3).scale = filtered(1:2:end,1:2:end);

filtered = imfilter(gaussian_pyramid(3).scale, gauss_filt, 'replicate');
gaussian_pyramid(4).scale = filtered(1:2:end,1:2:end);


%% CREATE LoGs
size_image = size(gaussian_pyramid(1).scale);
logImages(1).scale = gaussian_pyramid(1).scale - imresize(gaussian_pyramid(2).scale, size_image, 'bilinear');

size_image = size(gaussian_pyramid(2).scale);
logImages(2).scale = gaussian_pyramid(2).scale - imresize(gaussian_pyramid(3).scale, size_image, 'bilinear');

size_image = size(gaussian_pyramid(3).scale);
logImages(3).scale = gaussian_pyramid(3).scale - imresize(gaussian_pyramid(4).scale, size_image, 'bilinear');

logImages(4).scale = gaussian_pyramid(4).scale;

end