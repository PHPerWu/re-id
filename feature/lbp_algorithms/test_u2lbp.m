 
testWeights = [];

% radius=2;
% neighbors=8;

radius = str2num(vfpParamSplit{1});
neighbors = str2num(vfpParamSplit{2});

mapping=getmapping(neighbors,'u2');

testCount = 1;
index = 0;
limit = 300;
for testsamples=0:size(vfpTestImgs,2)-1
    index = mod(testsamples, limit) + 1;
    test_imgs=reshape(vfpTestImgs(:,testsamples+1),size_y,size_x); 
%     test_imgs=ttpreprocess(test_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    hist11=lbp(test_imgs,radius,neighbors,region_y, region_x, mapping);
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


