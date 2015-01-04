function [ gaussian_pyramid ] = createGaussPyr( input_image)

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

end

