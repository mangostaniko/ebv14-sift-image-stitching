function [ gaussian_pyramid, levels ] = createGaussPyr( input_image)
% Author: Sebastian Kirchner
% input: input_image ... input image from which to create Gaussian Pyramide
% output:   gaussian_pyramid ... a Gaussian Pyramid 
%           levels ... the levels of the pyramid

%% CHANGE IMAGE TO DOUBLE AND IF input_image IS RGB CONVERT TO GRAY-SCALE
image = im2double(input_image);
if (size(image, 3) == 3)
    image = rgb2gray(input_image);
end

%% SET SIGMA HERE
sigma = 0.5;

%% USE 2 FILTERS FOR SPEED, ONE HORIZONTAL AND ONE VERTICAL
gauss_filt_1 = fspecial('gaussian', [1 5], sigma);
gauss_filt_2 = fspecial('gaussian', [5 1], sigma);


%% CREATE GAUSSIAN PYRAMID ==> BLUR then SCALE DOWN
% first level is the original image
gaussian_pyramid(1).scale = image;

% filter and then scale down, for downsampling just take only every second
% row and column
filtered = imfilter(gaussian_pyramid(1).scale, gauss_filt_1, 'replicate');
filtered = imfilter(filtered, gauss_filt_2, 'replicate');
gaussian_pyramid(2).scale = filtered(1:2:end,1:2:end);

filtered = imfilter(gaussian_pyramid(2).scale, gauss_filt_1, 'replicate');
filtered = imfilter(filtered, gauss_filt_2, 'replicate');
gaussian_pyramid(3).scale = filtered(1:2:end,1:2:end);

filtered = imfilter(gaussian_pyramid(3).scale, gauss_filt_1, 'replicate');
filtered = imfilter(filtered, gauss_filt_2, 'replicate');
gaussian_pyramid(4).scale = filtered(1:2:end,1:2:end);

% give back the amount of levels in the pyramid
levels = 4;


end

