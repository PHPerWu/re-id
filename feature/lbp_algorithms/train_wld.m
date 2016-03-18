
trainWeights = [];

% Tbin = 16;
% Mbin = 6;
% Sbin = 6;

Tbin = str2num(vfpParamSplit{1});
Mbin = str2num(vfpParamSplit{2});
Sbin = str2num(vfpParamSplit{3});

trainCount = 1;
index = 0;
limit = 300;
trainlength = size(vfpTrainImgs,2);
for trainsamples=0:trainlength-1
    index = mod(trainsamples, limit)+1;
    train_imgs=reshape(vfpTrainImgs(:,trainsamples+1),size_y,size_x)';  
%     train_imgs=ttpreprocess(train_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    hist11=wld(train_imgs, Tbin, Mbin, Sbin, region_y, region_x);
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
%     train_imgs=reshape(vfpTrainImgs(:,trainsamples),size_y,size_x)';       
%     hist = wld(train_imgs, Tbin, Mbin, Sbin);
%     trainWeights(:,trainsamples)=hist;
% end
% 
% vfpTrainMem = trainWeights;
