function [w1,w2,w3,w4,v1,v2,v3,v4,obj,time,Beta] = reg_pro(X,Y1,Y2,Y3,Y4,alpha1,alpha2,lambda1,lambda2,t)
 %% Normalization
 tic
 n = size(X,1);
% ---------- solve beta --------------
     

max_Iter = 100;
tol = 1e-5;
obj = [];
tw1 = inf;
tw2 = inf;
tv1 = inf;
tv2 = inf;
tw3 = inf;
tw4 = inf;
tv3 = inf;
tv4 = inf;
res11 = [];
res12 = [];
res13 = [];
res14 = [];
res21 = [];
res22 = [];
res23 = [];
res24 = [];

e = ones(1,4);
TT = t * t';
ee = e * e';
n = size(X,1);
p = size(X,2);



XX = zeros(p,p);

for j = 1:n
     XX = XX + X(j,:)' * X(j,:);
end
XtX = TT * XX;
XeX = ee * XX;
Gu = updateGraph2(p,'FGL');
w1 = 0.001*ones(1,p);
w2 = 0.001*ones(1,p);
w3 = 0.001*ones(1,p);
w4 = 0.001*ones(1,p);
v1 = 0.001*ones(1,p);
v2 = 0.001*ones(1,p);
v3 = 0.001*ones(1,p);
v4 = 0.001*ones(1,p);

        [beta11,beta01,~] = solvebeta(Y1,t,w1,v1,X);
        [beta12,beta02,~] = solvebeta(Y2,t,w2,v2,X);
        [beta13,beta03,~] = solvebeta(Y3,t,w3,v3,X);
        [beta14,beta04,~] = solvebeta(Y4,t,w4,v4,X);
        Y1n = Y1 - beta01*e - beta11 * t;
        Y2n = Y2 - beta02*e - beta12 * t;
        Y3n = Y3- beta03*e - beta13 * t;
        Y4n = Y4 - beta04*e - beta14 * t;
       


i = 1;
while (i<max_Iter && (tw1>tol || tw2>tol || tv1>tol || tv2>tol || tw4>tol || tw3>tol || tv3>tol || tv4>tol))
    i = i + 1;
        % Normalization
     
    
    
    w1_old = w1;
    w2_old = w2;
    v1_old = v1;
    v2_old = v2;
    w3_old = w3;
    w4_old = w4;
    v3_old = v3;
    v4_old = v4;
    D1 = updateD2(w1,w2,w3,w4);
    Dfglw1 = updateDfgl(w1,Gu,'FGL');
    Dfglw1 = diag(Dfglw1);
    Y1X1 = zeros(1,p);
    for j = 1:n
        Y1X1 = Y1X1 + (Y1n(j,:) - v1 * X(j,:)' ) * t' * X(j,:);
    end
    w1 = (Y1X1)/(alpha1 *D1  + XtX + lambda1 *  Dfglw1);
    
    Dfglw2 = updateDfgl(w2,Gu,'FGL');
    Dfglw2 = diag(Dfglw2);
    Y2X1 = zeros(1,p);
    for j = 1:n
        Y2X1 = Y2X1 + (Y2n(j,:) - v2 * X(j,:)' ) * t' * X(j,:);
    end
    w2 = (Y2X1)/(alpha1 *D1  + XtX + lambda1 *  Dfglw2);
    
    Dfglw3 = updateDfgl(w3,Gu,'FGL');
    Dfglw3 = diag(Dfglw3);
    Y3X1 = zeros(1,p);
    for j = 1:n
        Y3X1 = Y3X1 + (Y3n(j,:) - v3 * X(j,:)' ) * t' * X(j,:);
    end
    w3 = (Y3X1)/(alpha1 *D1  + XtX + lambda1 *  Dfglw3);
    
    
    Dfglw4 = updateDfgl(w4,Gu,'FGL');
    Dfglw4 = diag(Dfglw4);
    Y4X1 = zeros(1,p);
    for j = 1:n
        Y4X1 = Y4X1 + (Y4n(j,:) - v4 * X(j,:)' ) * t' * X(j,:);
    end
    w4 = (Y4X1)/(alpha1 *D1  + XtX + lambda1 *  Dfglw4 );
    
    
   
    D2 = updateD2(v1,v2,v3,v4);
    Dfglv1 = updateDfgl(v1,Gu,'FGL');
    Dfglv1 = diag(Dfglv1);
    Y1X2 = zeros(1,p);
   
    for j = 1:n
        Y1X2 = Y1X2 + (Y1n(j,:)  - w1 * X(j,:)' * t) * e' * X(j,:);
    end
    v1 = (Y1X2)/(alpha2 *D2 + XeX + lambda2 *  Dfglv1);
    
    Dfglv2 = updateDfgl(v2,Gu,'FGL');
    Dfglv2 = diag(Dfglv2);
    Y2X2 = zeros(1,p);
    for j = 1:n
        Y2X2 = Y2X2 + (Y2n(j,:)  - w2 * X(j,:)' * t) * e' * X(j,:);
    end
    v2 = (Y2X2)/(alpha2 *D2 + XeX + lambda2 *  Dfglv2);
    
    Dfglv3 = updateDfgl(v3,Gu,'FGL');
    Dfglv3 = diag(Dfglv3);
    Y3X2 = zeros(1,p);
    Y3X2 = zeros(1,p);
    for j = 1:n
        Y3X2 = Y3X2 + (Y3n(j,:)  - w3 * X(j,:)' * t) * e' * X(j,:);
    end
    v3 = (Y3X2)/(alpha2 *D2 + XeX + lambda2 *  Dfglv3);
    
    Dfglv4 = updateDfgl(v4,Gu,'FGL');
    Dfglv4 = diag(Dfglv4);
    Y4X2 = zeros(1,p);
    for j = 1:n
        Y4X2 = Y4X2 + (Y4n(j,:)  - w4 * X(j,:)' * t) * e' * X(j,:);
    end
    v4 = (Y4X2)/(alpha2 *D2 + XeX + lambda2 *  Dfglv4);
     
%     
        [beta11,beta01,~] = solvebeta(Y1,t,w1,v1,X);
        [beta12,beta02,~] = solvebeta(Y2,t,w2,v2,X);
        [beta13,beta03,~] = solvebeta(Y3,t,w3,v3,X);
        [beta14,beta04,~] = solvebeta(Y4,t,w4,v4,X);

        Y1n = Y1- beta01*e - beta11 * t;
        Y2n = Y2 - beta02*e - beta12 * t;
        Y3n = Y3- beta03*e - beta13 * t;
        Y4n = Y4 - beta04*e - beta14 * t;
      
    
    res11(end + 1) = max(abs(w1 - w1_old));
    res12(end + 1) = max(abs(w2 - w2_old));
    res13(end + 1) = max(abs(w3 - w3_old));
    res14(end + 1) = max(abs(w4 - w4_old));
    res21(end + 1) = max(abs(v1 - v1_old));
    res22(end + 1) = max(abs(v2 - v2_old));
    res23(end + 1) = max(abs(v3 - v3_old));
    res24(end + 1) = max(abs(v4 - v4_old));
    if i > 1
        tw1 = max(abs(w1 - w1_old));
        tw2 = max(abs(w2 - w2_old));
        tw3 = max(abs(w3 - w3_old));
        tw4 = max(abs(w4 - w4_old));
        tv1 = max(abs(v1 - v1_old));
        tv2 = max(abs(v2 - v2_old));
        tv3 = max(abs(v3 - v3_old));
        tv4 = max(abs(v4 - v4_old));
    else
        tw1 = tol * 10;
        tw2 = tol * 10;
        tw3 = tol * 10;
        tw4 = tol * 10;
        tv1 = tol * 10;
        tv2 = tol * 10;
        tv3 = tol * 10;
        tv4 = tol * 10;
    end
    aa = [];
    for jj = 1:n
     aa(jj) = norm(Y1n(jj,:)  - v1 * X(jj,:)' - (w1 * X(jj,:)') * t).^2 +  norm(Y2n(jj,:)  - v2 * X(jj,:)' - (w2 * X(jj,:)') * t).^2 + norm(Y3n(jj,:)  - v3 * X(jj,:)' - (w3 * X(jj,:)') * t).^2 + norm(Y4n(jj,:)  - v4 * X(jj,:)' - (w4 * X(jj,:)') * t).^2  ;
    end
    aaa(i) = sum(aa);
    bb(i) = 0;
     cc(i) = 0;
    for jj = 1:p
         bb(i) = bb(i)+ sqrt(w1(jj).^2 + w2(jj).^2 + w3(jj).^2 + w4(jj).^2);
         cc(i) = cc(i)+ sqrt(v1(jj).^2 + v2(jj).^2 + v3(jj).^2 + v4(jj).^2);
         
    end
    
    obj(i) = aaa(i) + alpha1 * bb(i) + alpha2 * cc(i) ;
end
Beta = [beta01,beta11;beta02,beta12;beta03,beta13;beta04,beta14];
time = toc;

