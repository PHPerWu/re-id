 
 
% radius=1;
% neibors=8;

radius = str2num(vfpParamSplit{1});
neibors = str2num(vfpParamSplit{2});
testWeights = [];
mapping=getmappingForCLBP(neibors,'u2');

testCount = 1;
index = 0;
limit = 30;
for testsamples=0:size(vfpTestImgs,2)-1
    index = mod(testsamples, limit) + 1;
    test_imgs=reshape(vfpTestImgs(:,testsamples+1),size_y,size_x); 
%     test_imgs=ttpreprocess(test_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
%     [CLBP_S,CLBP_M,CLBP_C] = clbp(test_imgs,radius,neibors,mapping,'x');
%     CLBP_MCSum = CLBP_M;
%     idx = find(CLBP_C);
%     CLBP_MCSum(idx) = CLBP_MCSum(idx)+mapping.num;
%     CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
%     Hist3D = hist3(CLBP_SMC,[mapping.num,mapping.num*2]);
%     CLBP_SMCH(index,:) = reshape(Hist3D,1,numel(Hist3D));
%     hist = CLBP_SMCH(index,:) ; 
    hist = clbp(test_imgs,radius,neibors,region_y, region_x, mapping,'x');
    testWeights(:,index)=hist';
    if index == limit
        save([vfpTempTestWeights num2str(testCount) '.mat'], 'testWeights');
        testCount = testCount+1;
        testWeights = [];
    end
end
if index>0 && index ~= limit
    save([vfpTempTestWeights num2str(testCount) '.mat'], 'testWeights');
end
clear testWeights;

% 
% for testsamples=1:size(vfpTestImgs,2)
%      test_imgs=reshape(vfpTestImgs(:,testsamples),size_y,size_x);
%     [CLBP_S,CLBP_M,CLBP_C] = clbp(test_imgs,radius,neibors,mapping,'x');
%      CLBP_MCSum = CLBP_M;
%      idx = find(CLBP_C);
%      CLBP_MCSum(idx) = CLBP_MCSum(idx)+mapping.num;
%      CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
%      Hist3D = hist3(CLBP_SMC,[mapping.num,mapping.num*2]);
%      CLBP_SMCH(testsamples,:) = reshape(Hist3D,1,numel(Hist3D));
% 
%     hist1 = CLBP_SMCH(testsamples,:) ; 
%     testWeights(:,testsamples)=hist1';
% end
