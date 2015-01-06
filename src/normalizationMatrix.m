function [T] = normalizationMatrix(x)
%% Author: Hanna Huber
% Performs normalization for normalized DLT
%   Input:  x ... 3xN matrix of N points in homogeneous coordinates
%   Output: T ... 3x3 transformation matrix that normalizes each point x(:,i)

% Translate x s.t. mean(x)=0
tx = -mean(x(1,:));
ty = -mean(x(2,:));
T_trans = [1,0,tx;0,1,ty;0,0,1];

x_trans = T_trans*x;

% Scale x s.t. mean(|x|)=sqrt(2)
l = sqrt(sum(x_trans(1:2,:).^2));
s = sqrt(2)/mean(l);
T_scale = [s,0,0;0,s,0;0,0,1];
T = T_scale*T_trans;

end

