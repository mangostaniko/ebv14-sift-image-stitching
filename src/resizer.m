function [ RI ] = resizer( inputImage, scale )
% returns a new image half the size of inputImage by skipping every second 
% pixel
RI = inputImage(1:2:end, 1:2:end);
end

