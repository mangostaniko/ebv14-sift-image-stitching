function [ oct, dog ] = createDoG2( input_image )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  CREATE THE SCALE SPACE, 4 Octaves with 5 frequencies
%%%%  1.) Change input_image to grayscale double image
%%%%  2.) Blur the input_image with sigma 0.5
%%%%  3.) Double the size of the image via interpolation
%%%%  4.) starting sigma is sqrt(2), each scale is blured using the 
%%%%        previously scaled image and the same sigma
%%%%  5.) for the beginning of octaves 2, 3 and 4 scale the image down to 
%%%%        half the size and double the sigma

%% >>> (1) & (2) & (3) <<<
image = im2double(rgb2gray(input_image));   
pre_sigma = 0.5;
image = blur(image, pre_sigma);
image_dbl_size = imresize(image, 2, 'bilinear');

%% >>> (4) <<< 
img_temp = image_dbl_size;
sigma = 2^(1/2);

for i=1:4
    
    img_loop = img_temp; % temporary img for resizing later
    
    image_blurred = blur(img_loop, sigma);
    oct(i).scale1 = image_blurred;
    imwrite(image_blurred, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/oct', num2str(i), '_scale1.jpg'));
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale2 = image_blurred;
    imwrite(image_blurred, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/oct', num2str(i), '_scale2.jpg'));
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale3 = image_blurred;
    imwrite(image_blurred, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/oct', num2str(i), '_scale3.jpg'));
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale4 = image_blurred;
    imwrite(image_blurred, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/oct', num2str(i), '_scale4.jpg'));
    
    image_blurred = blur(image_blurred, sigma);
    oct(i).scale5 = image_blurred;
    imwrite(image_blurred, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/oct', num2str(i), '_scale5.jpg'));

    
    %% >>> (5) <<<
    sigma = 2*sigma;
    img_temp = imresize(img_loop, 0.5, 'bilinear');
    
    
    %% Create Difference of Gauss Pictures
    dog(i).scale1 = oct(i).scale1 - oct(i).scale2;
    imwrite(dog(i).scale1, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/dog', num2str(i), '_scale1.jpg'));
    
    dog(i).scale2 = oct(i).scale2 - oct(i).scale3;
    imwrite(dog(i).scale2, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/dog', num2str(i), '_scale2.jpg'));
    
    dog(i).scale3 = oct(i).scale3 - oct(i).scale4;
    imwrite(dog(i).scale3, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/dog', num2str(i), '_scale3.jpg'));
    
    dog(i).scale4 = oct(i).scale4 - oct(i).scale5;
    imwrite(dog(i).scale4, strcat('C:/Users/Sebastian/Pictures/SebiTestDogs/dog', num2str(i), '_scale4.jpg'));
end
end

function I_conv = blur( image, sigma )

h_hori = fspecial('gaussian', [1 5], sigma);
h_vert = fspecial('gaussian', [5 1], sigma);

I_conv = imfilter(image, h_hori, 'replicate');
I_conv = imfilter(I_conv, h_vert, 'replicate');

end

