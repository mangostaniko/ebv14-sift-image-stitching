function [ oct1, oct2, oct3, oct4, dog1, dog2, dog3, dog4 ] = createDoG( input_image )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% input_image ... the image of which to create a Difference of Gaussian
%%%%                 Pyramid from
%%%%%%%%
%%%% oct ... 4 Octaves containing scale space (5 subsequently blurred
%%%%         pictures per octave = 4 * 5 = 20 pictues in total)
%%%% dog ... 4 Difference of Gauss pictures, created using the ScaleSpace
%%%%%%%%
%%%% HOW TO USE OUTPUT:
%%%% [oct1, oct2, oct3, oct4, dog1, dog2, dog3, dog4] will give you the
%%%% corresponding octs and dogs
%%%%%%%%
%%%%  CREATE THE SCALE SPACE, 4 Octaves with 5 frequencies
%%%%  1.) Change input_image to grayscale double image if it is RGB
%%%%  2.) starting sigma is sqrt(2), each scale is blurred using the
%%%%        previously scaled image and sigma is adjusted every scale
%%%%  3.) for the beginning of octaves 2, 3 and 4 the image is scaled down
%%%%        to half the size
%%%%  4.) fit output for rest of program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% >>> (1) <<<
image = im2double(input_image);
if (size(image, 3) == 3)
    image = rgb2gray(input_image);
end

%% NOT USED ==> WOULD BE USED TO DOUBLE THE INPUT IMAGE TO CREATE MORE KEYPOINTS
% Rest of the programme would need to be arranged for that case 
% if double
%     pre_sigma = 0.5;
%     image = blur(image, pre_sigma);
%     image = imresize(image, 2, 'bilinear');
% end

%% >>> (2) <<< CALCULATE SIGMAS
img_temp = image;
initial_sigma = 2^(1/2);
sigmas(1) = initial_sigma;
for i=1:4
    sigmas(i+1) = initial_sigma * 2^(i/5);
end

for i=1:4
    
    % blur image using blur function, kernel size is adjusted to sigma
    image_blurred = blur(img_temp, sigmas(1));
    oct(i).scale1 = image_blurred;
    
    image_blurred = blur(image_blurred, sigmas(2));
    oct(i).scale2 = image_blurred;
    
    image_blurred = blur(image_blurred, sigmas(3));
    oct(i).scale3 = image_blurred;
    
    image_blurred = blur(image_blurred, sigmas(4));
    oct(i).scale4 = image_blurred;
    
    image_blurred = blur(image_blurred, sigmas(5));
    oct(i).scale5 = image_blurred;
    
    %% >>> (5) <<< SET IMAGE TO HALF SIZE
    img_temp = half_image(oct(i).scale1);
    
    %% CREATE DIFFERENCE OF GAUSSIAN PICTURES BY CALCULATING THE DIFFERENCE BETWEEN TWO SCALES
    dog(i).scale1 = oct(i).scale1 - oct(i).scale2;
    dog(i).scale2 = oct(i).scale2 - oct(i).scale3;
    dog(i).scale3 = oct(i).scale3 - oct(i).scale4;
    dog(i).scale4 = oct(i).scale4 - oct(i).scale5;
    
    %% CAN BE USED TO WRITE OCTS AND DOGS TO FILE FOR EASIER DEBUGGING
%     path_for_debug = '../pictures/octs_dogs/';
%     if write
%         imwrite(oct(i).scale1, strcat(path_for_debug, 'oct', num2str(i), '_scale1.jpg'));
%         imwrite(oct(i).scale2, strcat(path_for_debug, 'oct', num2str(i), '_scale2.jpg'));
%         imwrite(oct(i).scale3, strcat(path_for_debug, 'oct', num2str(i), '_scale3.jpg'));
%         imwrite(oct(i).scale4, strcat(path_for_debug, 'oct', num2str(i), '_scale4.jpg'));
%         imwrite(oct(i).scale5, strcat(path_for_debug, 'oct', num2str(i), '_scale5.jpg'));
%         
%         imwrite(dog(i).scale1, strcat(path_for_debug, 'dog', num2str(i), '_scale1.jpg'));
%         imwrite(dog(i).scale2, strcat(path_for_debug, 'dog', num2str(i), '_scale2.jpg'));
%         imwrite(dog(i).scale3, strcat(path_for_debug, 'dog', num2str(i), '_scale3.jpg'));
%         imwrite(dog(i).scale4, strcat(path_for_debug, 'dog', num2str(i), '_scale4.jpg'));
%     end
end

%% >>> (7) <<< WRITE THE OCTS AND DOGS TO MATRICES FOR THE REST OF THE PROGRAM
% We use arrays before to keep it compact

%%%%%% OCTAVES
oct1(:,:,1) = oct(1).scale1;
oct1(:,:,2) = oct(1).scale2;
oct1(:,:,3) = oct(1).scale3;
oct1(:,:,4) = oct(1).scale4;
oct1(:,:,5) = oct(1).scale5;

oct2(:,:,1) = oct(2).scale1;
oct2(:,:,2) = oct(2).scale2;
oct2(:,:,3) = oct(2).scale3;
oct2(:,:,4) = oct(2).scale4;
oct2(:,:,5) = oct(2).scale5;

oct3(:,:,1) = oct(3).scale1;
oct3(:,:,2) = oct(3).scale2;
oct3(:,:,3) = oct(3).scale3;
oct3(:,:,4) = oct(3).scale4;
oct3(:,:,5) = oct(3).scale5;

oct4(:,:,1) = oct(4).scale1;
oct4(:,:,2) = oct(4).scale2;
oct4(:,:,3) = oct(4).scale3;
oct4(:,:,4) = oct(4).scale4;
oct4(:,:,5) = oct(4).scale5;

%%%%%% DOGS
dog1(:,:,1) = dog(1).scale1;
dog1(:,:,2) = dog(1).scale2;
dog1(:,:,3) = dog(1).scale3;
dog1(:,:,4) = dog(1).scale4;

dog2(:,:,1) = dog(2).scale1;
dog2(:,:,2) = dog(2).scale2;
dog2(:,:,3) = dog(2).scale3;
dog2(:,:,4) = dog(2).scale4;

dog3(:,:,1) = dog(3).scale1;
dog3(:,:,2) = dog(3).scale2;
dog3(:,:,3) = dog(3).scale3;
dog3(:,:,4) = dog(3).scale4;

dog4(:,:,1) = dog(4).scale1;
dog4(:,:,2) = dog(4).scale2;
dog4(:,:,3) = dog(4).scale3;
dog4(:,:,4) = dog(4).scale4;

end

%% KERNEL SIZE DEPENDS ON SIGMA
function I_conv = blur( image, sigma )

% change kernel size depending on sigma but make sure it stays greater than
% or equal to 1
kernelSize = round(sigma*3 - 1);
if(kernelSize<1)
    kernelSize = 1;
end

% two filters for faster calculation
h_hori = fspecial('gaussian', [1 kernelSize], sigma);
h_vert = fspecial('gaussian', [kernelSize 1], sigma);

% filter the image
I_conv = imfilter(image, h_hori, 'replicate');
I_conv = imfilter(I_conv, h_vert, 'replicate');

end

%% REDUCE SIZE OF PICTURE IN HALF BY TAKING EVERY SECOND PIXEL
function I_half = half_image( image )
I_half=image(1:2:end,1:2:end) ;

end

