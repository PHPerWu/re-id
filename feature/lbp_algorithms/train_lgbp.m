
trainWeights = [];

scale = str2num(vfpParamSplit{1});
orientation = str2num(vfpParamSplit{2});


trainCount = 1;
index = 0;
trainlength = size(vfpTrainImgs,2);
limit = 50;
for trainsamples=0:trainlength-1
    index = mod(trainsamples, limit)+1;
    train_imgs=reshape(vfpTrainImgs(:,trainsamples+1),size_y,size_x)';  
    hist = LGBP(train_imgs, scale, orientation, region_y, region_x);
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
% ���һ��.mat�����index������200����ô��󻹲�һ��matû�д档
if index>0 && index ~= limit
    save([vfpTempTrainWeights num2str(trainCount) '.mat'], 'trainWeights');
    modeSize = length(trainWeights(:,1)) * 8;
end
clear trainWeights;

% ԭ����train_lgbp����
% for trainsamples=1:size(vfpTrainImgs,2)
%     train_imgs=reshape(vfpTrainImgs(:,trainsamples),size_y,size_x)';       
%     hist = LGBP(train_imgs, scale, orientation);
%     trainWeights(:,trainsamples)=hist;
% end
% 
% vfpTrainMem = trainWeights;
