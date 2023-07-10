function [beta1,beta0,p] = solvebeta(Y,t,w,v,X)
n = size(Y,1);
for i = 1:n
    Y(i,:) = Y(i,:) - w * X(i,:)'* t - v * X(i,:)'; 
end
YY1 = mean(Y);
p = polyfit(t, YY1, 1);
beta1 = p(1);
beta0 = p(2);