function [ RI ] = resizer( inputImage, scale )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% read the Original Image (OI)
OI = inputImage;
SIZEOI = size(OI);

%compute the reduction factor
RF = pow2(scale); 

% compute the new size
SIZERI = SIZEOI;
SIZERI(1) = SIZERI(1)/RF;
SIZERI(2) = SIZERI(2)/RF;

% create the reduce image through sampling
for i=1:1:SIZERI(1)
	for j=1:1:SIZERI(2)
		
			RI(i,j) = OI(i*RF,j*RF);
		
	end;
end;


end

