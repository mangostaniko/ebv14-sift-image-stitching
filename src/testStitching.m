function [nichts] = testStitching()
%% Only used for testing the stitchImage-Method

%%
result = stitchImages(im2double(imread('../pictures/B1.jpg')),im2double(imread('../pictures/B2.jpg')),0);
imshow(result);
end