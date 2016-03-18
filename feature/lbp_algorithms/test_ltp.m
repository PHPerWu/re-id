 
  
testWeights = [];

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

testCount = 1;
index = 0;
limit = 300;
for testsamples=0:size(vfpTestImgs,2)-1
    index = mod(testsamples, limit) + 1;
    test_imgs=reshape(vfpTestImgs(:,testsamples+1),size_y,size_x); 
%     test_imgs=ttpreprocess(test_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
    [lower_hist, upper_hist] = ltp_hist(test_imgs,thresh, region_y, region_x);
    testWeights(:,index) = [lower_hist upper_hist];
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
%     test_imgs=ttpreprocess(test_imgs,gamma,sigma1,sigma2,[sx,sy],mask,do_norm);
%     [lower_hist, upper_hist] = ltp_hist(test_imgs,thresh);
%     
%     testWeights(:,testsamples) = [lower_hist upper_hist];
% end


