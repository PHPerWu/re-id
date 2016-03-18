   
   
% radius=1;
% neibors=8;
radius = str2num(vfpParamSplit{1});
neibors = str2num(vfpParamSplit{2});
mapping=getmappingForCLBP(neibors,'u2');
 
trainWeights = [];

trainCount = 1;
index = 0;
limit = 30;
trainlength = size(vfpTrainImgs,2);
for trainsamples=0:trainlength-1
    index = mod(trainsamples, limit)+1;
    train_imgs=reshape(vfpTrainImgs(:,trainsamples+1),size_y,size_x);
%     train_imgs=ttpreprocess(train_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
%     [CLBP_S,CLBP_M,CLBP_C] = clbp(train_imgs,radius,neibors,mapping,'x');
%     CLBP_MCSum = CLBP_M;
%     idx = find(CLBP_C);
%     CLBP_MCSum(idx) = CLBP_MCSum(idx)+mapping.num;
%     CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
%     Hist3D = hist3(CLBP_SMC,[mapping.num,mapping.num*2]);
%     CLBP_SMCH(index,:) = reshape(Hist3D,1,numel(Hist3D));
%     hist = CLBP_SMCH(index,:) ;
    hist = clbp(train_imgs,radius,neibors, region_y, region_x,mapping,'x');
    trainWeights(:,index)=hist';
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
%      train_imgs=reshape(vfpTrainImgs(:,trainsamples),size_y,size_x);
%      [CLBP_S,CLBP_M,CLBP_C] = clbp(train_imgs,radius,neibors,mapping,'x');
%      CLBP_MCSum = CLBP_M;
%      idx = find(CLBP_C);
%      CLBP_MCSum(idx) = CLBP_MCSum(idx)+mapping.num;
%      CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
%      Hist3D = hist3(CLBP_SMC,[mapping.num,mapping.num*2]);
%      CLBP_SMCH(trainsamples,:) = reshape(Hist3D,1,numel(Hist3D));
% 
%      hist1 = CLBP_SMCH(trainsamples,:) ;
%      trainWeights(:,trainsamples)=hist1';
% end
% vfpTrainMem = trainWeights;
