function [D,d] = updateD2(v1,v2,v3,v4)
% clear;clc;
% v1 = [zeros(25,1);ones(25,1)*2; zeros(50,1)];
% v2 = [zeros(25,1);ones(25,1)*2; zeros(50,1)];

q = size(v1,2);
for i = 1:q
    d(i) = 1/(2 * sqrt(v1(:,i).^2 + v2(:,i).^2 + v3(:,i).^2 + v4(:,i).^2 + eps));
end
D = diag(d);
