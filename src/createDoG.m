function [ oct1, oct2, oct3, oct4, dog1, dog2, dog3, dog4 ] = createDoG( inputImage )
% Author: Ernad Sehic
% input: inputImage ... RGB image (double format)
% output: oct1, oct2, oct3, oct4 ... arrays of 4 DoG images at different
% blur levels (x*y*3*4 matrices: x, y are scaled down for the different octaves)

H = fspecial('gaussian', [5 5], 1.5);

%compute the reduction factor

%Original image
originalImage = rgb2gray(inputImage);
bluredImage_1 = gauss(originalImage, H);
help_1 = gauss(originalImage, H);

%Creating ocateve 1 & DoG 1
oct1 = zeros(size(originalImage,1), size(originalImage,2), 7, class(originalImage));
oct1(:,:,1) = bluredImage_1;
dog1 = zeros(size(originalImage,1), size(originalImage,2), 4, class(originalImage));



for i=2:7
     help_1 = gauss(help_1 , H);
     oct1(:,:,i) = help_1;
     
end

dog1(:,:,1) = mapIntervall(minus(oct1(:,:,1),oct1(:,:,2)));

dog1(:,:,2) = mapIntervall(minus(oct1(:,:,2),oct1(:,:,3)));

dog1(:,:,3) = mapIntervall(minus(oct1(:,:,3),oct1(:,:,4)));

dog1(:,:,4) = mapIntervall(minus(oct1(:,:,4),oct1(:,:,5)));


%Creating octave 2 & DoG 2
firstScale = resizer(bluredImage_1,2);
bluredImage_2 = gauss(firstScale, H);
help_2 = firstScale;

oct2 = zeros(size(firstScale,1), size(firstScale,2), 5, class(firstScale));
oct2(:,:,1) = firstScale;
dog2 = zeros(size(firstScale,1), size(firstScale,2), 4, class(firstScale));


for i=2:5
     help_2 = gauss(help_2 , H);
     oct2(:,:,i) = help_2;
end

dog2(:,:,1) = minus(oct2(:,:,1),oct2(:,:,2));
dog2(:,:,2) = minus(oct2(:,:,2),oct2(:,:,3));
dog2(:,:,3) = minus(oct2(:,:,3),oct2(:,:,4));
dog2(:,:,4) = minus(oct2(:,:,4),oct2(:,:,5));

%Creating octave 3 & DoG 3
secondScale = resizer(bluredImage_2,2);
bluredImage_3 = gauss(secondScale, H);
help_3 = secondScale;

oct3 = zeros(size(secondScale,1), size(secondScale,2), 5, class(secondScale));
oct3(:,:,1) = secondScale;
dog3 = zeros(size(secondScale,1), size(secondScale,2), 4, class(secondScale));


for i=2:5
     help_3 = gauss(help_3 , H);
     oct3(:,:,i) = help_3;
end

dog3(:,:,1) = minus(oct3(:,:,1),oct3(:,:,2));
dog3(:,:,2) = minus(oct3(:,:,2),oct3(:,:,3));
dog3(:,:,3) = minus(oct3(:,:,3),oct3(:,:,4));
dog3(:,:,4) = minus(oct3(:,:,4),oct3(:,:,5));

%Creating octave 4 & DoG 4
thirdScale = resizer(bluredImage_3,2);
help_4 = thirdScale;

oct4 = zeros(size(thirdScale,1), size(thirdScale,2), 5, class(thirdScale));
oct4(:,:,1) = thirdScale;
dog4 = zeros(size(thirdScale,1), size(thirdScale,2), 4, class(thirdScale));


for i=2:5
     help_4 = gauss(help_4 , H);
     oct4(:,:,i) = help_4;
end

dog4a(:,:,1) = minus(oct4(:,:,1),oct4(:,:,2));
dog4a(:,:,2) = minus(oct4(:,:,2),oct4(:,:,3));
dog4a(:,:,3) = minus(oct4(:,:,3),oct4(:,:,4));
dog4a(:,:,4) = minus(oct4(:,:,4),oct4(:,:,5));

dog4(:,:,1) = mapIntervall(dog4a(:,:,1));
dog4(:,:,2) = mapIntervall(dog4a(:,:,2));
dog4(:,:,3) = mapIntervall(dog4a(:,:,3));
dog4(:,:,4) = mapIntervall(dog4a(:,:,4));


end

function [I_mapped] = mapIntervall(I)
    qMin = min(min(I));
    qMax = max(max(I));
    I_mapped = (I-qMin)/(qMax-qMin);

end

