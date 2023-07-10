function [rmse,cc] = evaluate_propose(X,Y1,Y2,Y3,Y4,w1,w2,w3,w4,v1,v2,v3,v4,t,beta)
n = size(X,1);
m = size(Y1,2);

for i = 1:n
    y1(i,:) = v1 * X(i,:)' + (w1 * X(i,:)'+ beta(1,2)) * t + beta(1,1);
    y2(i,:) = v2 * X(i,:)' + (w2 * X(i,:)'+ beta(2,2)) * t + beta(2,1);
    y3(i,:) = v3 * X(i,:)' + (w3 * X(i,:)'+ beta(3,2)) * t + beta(3,1);
    y4(i,:) = v4 * X(i,:)' + (w4 * X(i,:)'+ beta(4,2)) * t + beta(4,1);    
end
for i = 1:n
     aa1(i) =  sqrt((norm(Y1(i,:)  - y1(i,:)).^2 ) /m);
     aa2(i) =  sqrt((norm(Y2(i,:)  - y2(i,:)).^2) /m);
     aa3(i) =  sqrt((norm(Y3(i,:)  - y3(i,:)).^2 ) /m);
     aa4(i) =  sqrt((norm(Y4(i,:)  - y4(i,:)).^2) /m);     
end
aa = aa1 + aa2 + aa3 + aa4;
rmse = sum(aa) / n ;

for i = 1:m
   cc1(i)=corr(Y1(:,i),y1(:,i));
end
cc1 = sum(sum(cc1))/m;
for i = 1:m
   cc2(i)=corr(Y2(:,i),y2(:,i));
end
cc2 = sum(sum(cc2))/m;
for i = 1:m
   cc3(i)=corr(Y3(:,i),y3(:,i));
end
cc3 = sum(sum(cc3))/m;
for i = 1:m
   cc4(i)=corr(Y4(:,i),y4(:,i));
end
cc4 = sum(sum(cc4))/m;
cc = (cc1 + cc2 + cc3 + cc4)/4;