
testWeights = [];

r1 = str2num(vfpParamSplit{1});
r2 = str2num(vfpParamSplit{2});
S = str2num(vfpParamSplit{3});
w = str2num(vfpParamSplit{4});
a = str2num(vfpParamSplit{5});

testCount = 1;
index = 0;
limit = 300;
for testsamples=0:size(vfpTestImgs,2)-1
    index = mod(testsamples, limit) + 1;
    test_imgs=reshape(vfpTestImgs(:,testsamples+1),size_y,size_x)'; 
%     test_imgs=ttpreprocess(test_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    hist = FPLBP(test_imgs, r1, r2, S, w, a, region_y, region_x);
    testWeights(:,index)=hist;
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

% for testsamples=1:size(vfpTestImgs,2)
%     test_imgs=reshape(vfpTestImgs(:,testsamples),size_y,size_x)';       
%     hist = FPLBP(test_imgs, r1, r2, S, w, a);
%     testWeights(:,testsamples)=hist;
% end
