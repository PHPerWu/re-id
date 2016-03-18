
trainWeights = [];

r1 = str2num(vfpParamSplit{1});
r2 = str2num(vfpParamSplit{2});
S = str2num(vfpParamSplit{3});
w = str2num(vfpParamSplit{4});
a = str2num(vfpParamSplit{5});

trainCount = 1;
index = 0;
limit = 300;
trainlength = size(vfpTrainImgs,2);
for trainsamples=0:trainlength-1
    index = mod(trainsamples, limit)+1;
    train_imgs=reshape(vfpTrainImgs(:,trainsamples+1),size_y,size_x)';  
%     train_imgs=ttpreprocess(train_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    hist = FPLBP(train_imgs, r1, r2, S, w, a, region_y, region_x);
    trainWeights(:,index)=hist;
    if index == limit
        save([vfpTempTrainWeights num2str(trainCount) '.mat'], 'trainWeights');
        trainCount = trainCount+1;
        if trainsamples ==  trainlength-1
            modeSize = length(trainWeights(:,1)) * 8;           
        end
        trainWeights = [];
    end
end
% ���һ��.mat�����index������300����ô��󻹲�һ��matû�д档
if index>0 && index ~= limit
    save([vfpTempTrainWeights num2str(trainCount) '.mat'], 'trainWeights');
    modeSize = length(trainWeights(:,1)) * 8;
end
clear trainWeights;

% for trainsamples=1:size(vfpTrainImgs,2)
%     train_imgs=reshape(vfpTrainImgs(:,trainsamples),size_y,size_x)';       
%     hist = FPLBP(train_imgs, r1, r2, S, w, a);
%     trainWeights(:,trainsamples)=hist;
% end
% 
% vfpTrainMem = trainWeights;
