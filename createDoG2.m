function [ oct, dog ] = createDoG2( input_image, write, double )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% input_image ... the image of which to create a Difference of Gaussian
%%%%                 Pyramid
%%%% write  ...  boolean, true = write all pictures to files
%%%% double ...  boolean, true = double the orig. image in size before
%%%%             createing DoG pyramid
%%%%%%%%
%%%% oct ... 4 Octaves containing scale space (5 subsequently blurred 
%%%%         pictures per octave = 4 * 5 = 20 pictues in total)
%%%% dog ... 4 Difference of Gauss pictures, created using the ScaleSpace
%%%%%%%%
%%%% HOW TO USE OUTPUT:
%%%% Octaves: 
%%%% oct(i).scaleX ... where i is the number of the Octave (1-4)
%%%%                   and X is the ScaleLevel (1-5)
%%%%                   (oct(1).scale1 gives once blurred image of octave1)
%%%% dog(i).scaleX ... where i is the number of the Octave the DoG was
%%%%                   created from (1-4)
%%%%                   and X is the ScaleLevel (1-4)
%%%%%%%%
%%%%  CREATE THE SCALE SPACE, 4 Octaves with 5 frequencies
%%%%  1.) Change input_image to grayscale double image
%%%%  2.) Blur the input_image with sigma 0.5
%%%%  3.) Double the size of the image via interpolation (IF DOUBLE == TRUE)
%%%%  4.) starting sigma is sqrt(2), each scale is blurred using the
%%%%        previously scaled image and the same sigma
%%%%  5.) for the beginning of octaves 2, 3 and 4 the image is scaled down
%%%%        to half the size and the sigma is doubled
%%%%  6.) write all images to specified place for easier debugging and to
%%%%        see results (IF WRITE == TRUE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set Path for output pictures, filenames are generated automatically
path_for_debug = 'C:/Users/Sebastian/Pictures/SebiTestDogs/';

%% >>> (1) & (2) & (3) <<<
image = im2double(rgb2gray(input_image));
pre_sigma = 0.5;
image = blur(image, pre_sigma);

if double
    image = imresize(image, 2, 'bilinear');
end

%% >>> (4) <<<
img_temp = image;
sigma = 2^(1/2);

for i=1:4
    
    image_blurred = blur(img_temp, sigma);
    oct(i).scale1 = image_blurred;
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale2 = image_blurred;
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale3 = image_blurred;
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale4 = image_blurred;
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale5 = image_blurred;
    
    %% >>> (5) <<<
    sigma = sigma*1.5;
    img_temp = imresize(oct(i).scale1, 1/2, 'bilinear');
    
    %% Create Difference of Gauss Pictures
    dog(i).scale1 = oct(i).scale1 - oct(i).scale2;
    dog(i).scale2 = oct(i).scale2 - oct(i).scale3;
    dog(i).scale3 = oct(i).scale3 - oct(i).scale4;
    dog(i).scale4 = oct(i).scale4 - oct(i).scale5;
    
    %% >>> (6) <<<
    if write
        imwrite(oct(i).scale1, strcat(path_for_debug, 'oct', num2str(i), '_scale1.jpg'));
        imwrite(oct(i).scale2, strcat(path_for_debug, 'oct', num2str(i), '_scale2.jpg'));
        imwrite(oct(i).scale3, strcat(path_for_debug, 'oct', num2str(i), '_scale3.jpg'));
        imwrite(oct(i).scale4, strcat(path_for_debug, 'oct', num2str(i), '_scale4.jpg'));
        imwrite(oct(i).scale5, strcat(path_for_debug, 'oct', num2str(i), '_scale5.jpg'));
        
        imwrite(dog(i).scale1, strcat(path_for_debug, 'dog', num2str(i), '_scale1.jpg'));
        imwrite(dog(i).scale2, strcat(path_for_debug, 'dog', num2str(i), '_scale2.jpg'));
        imwrite(dog(i).scale3, strcat(path_for_debug, 'dog', num2str(i), '_scale3.jpg'));
        imwrite(dog(i).scale4, strcat(path_for_debug, 'dog', num2str(i), '_scale4.jpg'));
    end
end
end

function I_conv = blur( image, sigma )

h_hori = fspecial('gaussian', [1 5], sigma);
h_vert = fspecial('gaussian', [5 1], sigma);

I_conv = imfilter(image, h_hori, 'replicate');
I_conv = imfilter(I_conv, h_vert, 'replicate');

end

