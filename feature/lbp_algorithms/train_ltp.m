
trainWeights = [];
% parameter setting for preprocessing
gamma   = str2num(vfpParamSplit{1}); % gamma parameter
sigma1  = str2num(vfpParamSplit{2}); % inner Gaussian size
sigma2  = str2num(vfpParamSplit{3}); % outer Gaussian size
sx      = str2num(vfpParamSplit{4}); % x offset of centers of inner and outer filter
sy      = str2num(vfpParamSplit{5}); % y offset of centers of inner and outer filter
mask    = str2num(vfpParamSplit{6}); % mask
do_norm = str2num(vfpParamSplit{7}); % Normalize the spread of output values
thresh  = str2num(vfpParamSplit{8});

if mask
   load('mask.mat');
   mask = double(mask1);
else
   mask = [];
end

trainCount = 1;
index = 0;
limit = 300;
trainlength = size(vfpTrainImgs,2);
for trainsamples=0:trainlength-1
    index = mod(trainsamples, limit)+1;
    train_imgs=reshape(vfpTrainImgs(:,trainsamples+1),size_y,size_x);  
%     train_imgs=ttpreprocess(train_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    [lower_hist, upper_hist] = ltp_hist(train_imgs,thresh, region_y, region_x);
    trainWeights(:,index) = [lower_hist upper_hist];
    if index == limit
        save([vfpTempTrainWeights num2str(trainCount) '.mat'], 'trainWeights');
        trainCount = trainCount+1;
        if trainsamples ==  trainlength-1
            modeSize = length(trainWeights(:,1)) * 8;           
        end
        trainWeights = [];
    end
end
% 最后一个.mat：如果index不等于300，那么最后还差一个mat没有存。
if index>0 && index ~= limit
    save([vfpTempTrainWeights num2str(trainCount) '.mat'], 'trainWeights');
    modeSize = length(trainWeights(:,1)) * 8;
end
clear trainWeights;

         
% for trainsamples=1:size(vfpTrainImgs,2)
%     train_imgs=reshape(vfpTrainImgs(:,trainsamples),size_y,size_x);
%     train_imgs=ttpreprocess(train_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
%     [lower_hist, upper_hist] = ltp_hist(train_imgs,thresh);
%     
%     trainWeights(:,trainsamples) = [lower_hist upper_hist];
% end
% 
% vfpTrainMem = trainWeights;
