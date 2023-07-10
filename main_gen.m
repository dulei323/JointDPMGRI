clc
clear
load("Syn_Data_1s200n600p.mat");
 load("fold_2s200n.mat");
%% Tuned parameters

opt.alpha1 = 0.1;
opt.alpha2 = 0.1;
opt.lambda1 = 0.1;
opt.lambda2 = 0.1;

t = [0,0.5,1,1.5];
e = [1,1,1,1];
n=size(Y1,1);
Kfold =5;  
%  indices = crossvalind('Kfold', n, Kfold);
% paras.alpha1 = [0.01，0.1,1,10,100];
% paras.alpha2 = [0.01，0.1,1,10,100];
% paras.lambda1 = [0.01，0.1,1,10,100];
% paras.lambda2 = [0.01，0.1,1,10,100];
% [predicted_rmse, opt, all_opts] = tuneParas( X,Y1,Y2,Y3,Y4, paras, Kfold, indices,t,e);

   %% Cross validation 
    disp('Begin cross validition ...');
    disp('==============================');
    for k = 1 : Kfold
        fprintf('current fold: %d\n', k);
        test = (indices == k); 
        train = ~test;
        % ---------- Training sets ----------
        trainData.X1 = X(train, :);
        trainData.Y1 = Y1(train, :);
        trainData.Y2 = Y2(train, :);
        trainData.Y3 = Y3(train, :);
        trainData.Y4 = Y4(train, :);
     
        % ---------- Testing sets ----------
        testData.X1 = X(test, :);
        testData.Y1 = Y1(test, :);
        testData.Y2 = Y2(test, :);
        testData.Y3 = Y3(test, :);
        testData.Y4 = Y4(test, :);
       
        % ---------- Trainin ----------
        % Normalization
%         trainData.X1 = getNormalization(trainData.X1);
        trainData.Y1= getNormalization(trainData.Y1);
        trainData.Y2= getNormalization(trainData.Y2);
        trainData.Y3= getNormalization(trainData.Y3);
        trainData.Y4= getNormalization(trainData.Y4);
%         testData.X1 = getNormalization(testData.X1);
        testData.Y1= getNormalization(testData.Y1);
        testData.Y2= getNormalization(testData.Y2);
        testData.Y3= getNormalization(testData.Y3);
        testData.Y4= getNormalization(testData.Y4);
       
%         
    [w1,w2,w3,w4,v1,v2,v3,v4,obj,time_t,Beta{k}] = reg_pro(trainData.X1, trainData.Y1,trainData.Y2,trainData.Y3,trainData.Y4,opt.alpha1,opt.alpha2,opt.lambda1,opt.lambda2,t);
        time(k) = time_t;
        W1(k,:) = w1;W2(k,:) = w2;W3(k,:) = w3; W4(k,:) = w4;
        V1(k,:) = v1;V2(k,:) = v2;V3(k,:) = v3;V4(k,:) = v4;
    % ---------- RMSE of all features ----------
     [train_mse(k),train_cc(k)]= evaluate_propose(trainData.X1,trainData.Y1,trainData.Y2,trainData.Y3,trainData.Y4,W1(k,:),W2(k,:),W3(k,:),W4(k,:),V1(k,:),V2(k,:),V3(k,:),V4(k,:),t,Beta{k});
     [test_mse(k),test_cc(k)]= evaluate_propose(testData.X1,testData.Y1,testData.Y2,testData.Y3,testData.Y4,W1(k,:),W2(k,:),W3(k,:),W4(k,:),V1(k,:),V2(k,:),V3(k,:),V4(k,:),t,Beta{k});
      
    end
    train_mse_std=std(abs(train_mse));
    train_mse_mean=mean(abs(train_mse));
    
    test_mse_std=std(abs(test_mse));
    test_mse_mean=mean(abs(test_mse));
     
    train_cc_std=std(abs(train_cc));
    train_cc_mean=mean(abs(train_cc));
    
    test_cc_std=std(abs(test_cc));
    test_cc_mean=mean(abs(test_cc));
    
    time_mean = mean(abs(time));
    time_std=std(abs(time));

%% ---------- Weights ----------
w1_ave = 0;w2_ave = 0;w3_ave = 0;w4_ave = 0;
for k = 1 : Kfold
    w1_ave = w1_ave + W1(k,:);
    w2_ave = w2_ave + W2(k,:);
    w3_ave = w3_ave + W3(k,:);
    w4_ave = w4_ave + W4(k,:);
end
w1_ave = w1_ave / Kfold;
w2_ave = w2_ave / Kfold;
w3_ave = w3_ave / Kfold;
w4_ave = w4_ave / Kfold;

v1_ave = 0;v2_ave = 0;v3_ave = 0;v4_ave = 0;
for k = 1 : Kfold
    v1_ave = v1_ave + V1(k,:);
    v2_ave = v2_ave + V2(k,:);
    v3_ave = v3_ave + V3(k,:);
    v4_ave = v4_ave + V4(k,:);
end
v1_ave = v1_ave / Kfold;
v2_ave = v2_ave / Kfold;
v3_ave = v3_ave / Kfold;
v4_ave = v4_ave / Kfold;

Beta_ave = 0;
for k = 1 : Kfold
    Beta_ave = Beta_ave + Beta{k};
end
Beta_ave = Beta_ave / Kfold;
%% figure
w_show = [w1_ave;w2_ave;w3_ave;w4_ave];
v_show = [v1_ave;v2_ave;v3_ave;v4_ave];

subplot(1, 2, 1);
range1 = 0.1;
imagesc(w_show,[-range1,range1]);
title('\fontsize{24}slope');
set(gca, 'YTick', [1,2,3,4], 'YTickLabel', {'ROI1','ROI2','ROI3','ROI4'}, 'YAxisLocation', 'left','FontSize',20);

subplot(1, 2, 2);
range2 = 0.1;
imagesc(v_show,[-range2,range2]);
title('\fontsize{24}intercept');
set(gca, 'YTick', [1,2,3,4], 'YTickLabel', {'ROI1','ROI2','ROI3','ROI4'}, 'YAxisLocation', 'left','FontSize',20);

% 
% filename = sprintf('fold_%ds%dn.mat',gen.s, n);
%   save(filename,'indices');

filename = sprintf('result_synpro1_%ds%dn%dalpha1%dalpha2.mat',gen.s, n,opt.alpha1,opt.alpha2);
save(filename,'opt','v_show','w_show','test_cc_mean','test_cc_std','train_cc_mean','train_cc_std','test_mse_mean','test_mse_std','train_mse_mean','train_mse_std','Beta','time_mean','time_std');


