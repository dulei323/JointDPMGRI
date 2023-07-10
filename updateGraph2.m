function [E] = updateGraph2(p, flag)

% -----------------------------------------

ncol = p;
iedge = 0;

switch flag
    case 'FGL' % fused group lasso
        E = zeros(2*(p-1),p);
        for i = 1:p-1
            j = i+1;
            E(2*i-1,i) = 1;
            E(2*i-1,j) = 1;
            E(2*i,i) = 1;
            E(2*i,j) = 1;
        end
end