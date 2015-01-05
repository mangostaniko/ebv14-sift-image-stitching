function [ gaussian_pyramid ] = createGaussPyr( input_image)

image = im2double(input_image);
if (size(image, 3) == 3)
    image = rgb2gray(input_image);
end

%% SET SIGMA HERE
sigma = 0.5;

%% USE 2 FILTERS FOR SPEED
gauss_filt_1 = fspecial('gaussian', [1 5], sigma);
gauss_filt_2 = fspecial('gaussian', [5 1], sigma);


%% CREATE GAUSSIAN PYRAMID ==> BLUR then SCALE DOWN
gaussian_pyramid(1).scale = image;

filtered = imfilter(gaussian_pyramid(1).scale, gauss_filt_1, 'replicate');
filtered = imfilter(filtered, gauss_filt_2, 'replicate');
gaussian_pyramid(2).scale = filtered(1:2:end,1:2:end);

filtered = imfilter(gaussian_pyramid(2).scale, gauss_filt_1, 'replicate');
filtered = imfilter(filtered, gauss_filt_2, 'replicate');
gaussian_pyramid(3).scale = filtered(1:2:end,1:2:end);

filtered = imfilter(gaussian_pyramid(3).scale, gauss_filt_1, 'replicate');
filtered = imfilter(filtered, gauss_filt_2, 'replicate');
gaussian_pyramid(4).scale = filtered(1:2:end,1:2:end);

end

