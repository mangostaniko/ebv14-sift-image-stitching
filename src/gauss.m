function [ resultImage ] = gauss( inputImage, filter )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

resultImage = imfilter(inputImage, filter, 'replicate');

end