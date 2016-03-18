
% radius=2;
% neighbors=8;

trainWeights = [];

radius = str2num(vfpParamSplit{1});
neighbors = str2num(vfpParamSplit{2});

% 训练图片之前先计算出平均值K
k_sum = 0;
for trainsamples=1:size(vfpTrainImgs,2)
    train_imgs=reshape(vfpTrainImgs(:,trainsamples),size_y,size_x);  
%     train_imgs=ttpreprocess(train_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    k_sum = k_sum + dlbpK(train_imgs,radius,neighbors);
end
resultK = floor(k_sum/size(vfpTrainImgs, 2));

trainCount = 1;
index = 0;
limit = 300;
trainlength = size(vfpTrainImgs,2);
for trainsamples=0:trainlength-1
    index = mod(trainsamples, limit)+1;
    train_imgs=reshape(vfpTrainImgs(:,trainsamples+1),size_y,size_x);  
    hist11=dlbp(train_imgs,radius,neighbors,resultK, region_y,region_x);
    trainWeights(:,index)=hist11;
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
%     hist11=dlbp(train_imgs,radius,neighbors,dlbpK);
%     trainWeights(:,trainsamples)=hist11;
% end
% 
% vfpTrainMem = trainWeights;

