function [predicted_rmse, optimal_opts, all_opts] = tuneParas( X,Y1,Y2,Y3,Y4, paras, Kfold, indices,t,e)


disp('Parameters tuning');

% -------------------------------------------------

predicted_rmse = 0;
% -------------------------------------------------
% Set parameters
all_opts.alpha1 = [];
all_opts.alpha2 = [];
all_opts.lambda1 = [];
all_opts.lambda2 = [];
all_opts.rmse = [];
all_opts.obj = [];
% %
alpha1 = paras.alpha1;
alpha2 = paras.alpha2;
lambda1 = paras.lambda1;
lambda2 = paras.lambda2;

alpha1_number = length(alpha1);
alpha2_number = length(alpha2);
lambda1_number = length(lambda1);
lambda2_number = length(lambda2);
% default
alpha1_optimal = alpha1(1);
alpha2_optimal = alpha2(1);
lambda1_optimal = lambda1(1);
lambda2_optimal = lambda2(1);
% -------------------------------------------------
% Loop to search the optimal parameters, Group parameters
% -------------------------------------------------
% Begin Loop
% disp('----------------------------------------------------------');
% disp('Begin searching the optimal parameters...');
% disp('----------------------------------------------------------');
temp_rmse = 0;
for k = 1:alpha1_number
    opts.alpha1 = alpha1(k);
    for p = 1:alpha2_number
        opts.alpha2 = alpha2(p);
        for i = 1:lambda1_number
            opts.lambda1 = lambda1(i);
                for j = 1:lambda2_number
                    opts.lambda2 = lambda2(j);
                % Inner loop - tuning parameters
                    for kk = 1 : Kfold
                        test = (indices == kk); 
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

                            % solve beta
                        [beta11,beta01,~] = solvebeta(trainData.Y1,t);
                        [beta12,beta02,~] = solvebeta(trainData.Y2,t);
                        [beta13,beta03,~] = solvebeta(trainData.Y3,t);
                        [beta14,beta04,~] = solvebeta(trainData.Y4,t);


                        trainData.Y1 = trainData.Y1 - beta01*e - beta11 * t;
                        trainData.Y2 = trainData.Y2 - beta02*e - beta12 * t;
                        trainData.Y3 = trainData.Y3 - beta03*e - beta13 * t;
                        trainData.Y4 = trainData.Y4 - beta04*e - beta14 * t;
                        testData.Y1 = testData.Y1 - beta01*e - beta11 * t;
                        testData.Y2 = testData.Y2 - beta02*e - beta12 * t;
                        testData.Y3 = testData.Y3 - beta03*e - beta13 * t;
                        testData.Y4 = testData.Y4 - beta04*e - beta14 * t;

                        % Normalization
                        trainData.X1 = getNormalization(trainData.X1, 'normalize');
                        trainData.Y1= getNormalization(trainData.Y1, 'normalize');
                        trainData.Y2= getNormalization(trainData.Y2, 'normalize');
                        trainData.Y3= getNormalization(trainData.Y3, 'normalize');
                        trainData.Y4= getNormalization(trainData.Y4, 'normalize');
                        testData.X1 = getNormalization(testData.X1, 'normalize');
                        testData.Y1= getNormalization(testData.Y1, 'normalize');
                        testData.Y2= getNormalization(testData.Y2, 'normalize');
                        testData.Y3= getNormalization(testData.Y3, 'normalize');
                        testData.Y4= getNormalization(testData.Y4, 'normalize');


                       [w1,w2,w3,w4,v1,v2,v3,v4,obj] = reg_pro(trainData.X1, trainData.Y1,trainData.Y2,trainData.Y3,trainData.Y4,opts.alpha1,opts.alpha2,opts.lambda1,opts.lambda2,t);


                    % ---------- RMSE of all features ----------

                       [test_rmse,~]= evaluate_propose(testData.X1,testData.Y1,testData.Y2,testData.Y3,testData.Y4,w1,w2,w3,w4,v1,v2,v3,v4,t);
                       temp_rmse = temp_rmse + abs(test_rmse);
                    end
                    temp_rmse = temp_rmse / Kfold;
                    % store the results of every parameter pair
                    all_opts.rmse(end+1) = temp_rmse;
                    all_opts.alpha1(end+1) = opts.alpha1;
                    all_opts.alpha2(end+1) = opts.alpha2;
                    all_opts.lambda1(end+1) = opts.lambda1;
                    all_opts.lambda2(end+1) = opts.lambda2;

                    if predicted_rmse > temp_rmse
                        predicted_rmse = temp_rmse;
                        alpha1_optimal = opts.alpha1;
                        alpha2_optimal = opts.alpha2;
                        lambda1_optimal = opts.lambda1;
                        lambda2_optimal = opts.lambda2;
                    end
                    temp_rmse = 0;
                end
        end
    end
end

% Output the optimal parameters
optimal_opts.alpha1 = alpha1_optimal;
optimal_opts.alpha2 = alpha2_optimal;
optimal_opts.lambda1 = lambda1_optimal;
optimal_opts.lambda2 = lambda2_optimal;
% disp('----------------------------------------------------------');
% disp('End searching optimal parameters!');
% disp('----------------------------------------------------------');