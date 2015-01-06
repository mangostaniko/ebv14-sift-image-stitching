function [H] = fitSample(sample)
%% Author: Hanna Huber
% Calculates homography matrix that fits sample
%   Input: sample .. n-by-4 matrix containing matches in normalized coordinates,  sample(i) = (p1',p2')
%   Output:     H .. 3-by-3 matrix H satisfying p2_hom = H*p1_hom with hom. coords
    
sampleSize = size(sample,1);
A = zeros(sampleSize*2,9);

% Create coefficient matrix A for direct linear transform
%       p2_hom = H*p1_hom leads to a linear eq system A*h = 0
%       h contains the coefficients of the homography matrix H
for k = 1:sampleSize
   A(2*k-1,:)   = [-sample(k,1:2),-1,0,0,0,[sample(k,1:2),1]*sample(k,3)];
   A(2*k,:) = [0,0,0,-sample(k,1:2),-1,[sample(k,1:2),1]*sample(k,4)];
end

% The best solution is the eigenvector corresp. to the smallest eigenvalue of A^t*A
[V,~] = eig(A'*A);
H = reshape(V(:,1),[3,3])';

% Make H(3,3) = 1
H = H/H(end); 

end
