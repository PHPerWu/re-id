% feature matrix extraction
load('datasets/VIPeR.mat');

%% 
images = [cam_a cam_b];
labels = [id_a id_b];
options = [];
options.LBP = 1;
options.blockLBP = 1;
options.color = 1;
options.gabor = 1;
options.normailze = 1;
options.pca = 1;
feature_matrix = generateFeature( images, options);
