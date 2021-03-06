 
testWeights = [];

radius = str2num(vfpParamSplit{1});
neighbors = str2num(vfpParamSplit{2});

testCount = 1;
index = 0;
limit = 300;
for testsamples=0:size(vfpTestImgs,2)-1
    index = mod(testsamples, limit) + 1;
    test_imgs=reshape(vfpTestImgs(:,testsamples+1),size_y,size_x); 
%     test_imgs=ttpreprocess(test_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    hist11=dlbp(test_imgs,radius,neighbors,resultK, region_y, region_x);
    testWeights(:,index)=hist11;
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
%     test_imgs=reshape(vfpTestImgs(:,testsamples),size_y,size_x); 
%     hist11=dlbp(test_imgs,radius,neighbors,dlbpK);
%     testWeights(:,testsamples)=hist11;
% end


