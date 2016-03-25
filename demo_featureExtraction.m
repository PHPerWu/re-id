set_paths
%% VIPeR feature matrix extraction
load('datasets/VIPeR.mat');
images = [cam_a cam_b];
labels = [id_a id_b];

%% ETHZ 
% load('datasets/ETHZ-seq3-norm.mat');
% images=data;
% labels = gnd;

setting = [1 0 0 0 0 1 ;  ...
           0 1 0 0 0 1 ;  ...
           0 0 1 0 0 1 ;  ...
           0 0 0 1 0 1 ;  ...
%            0 0 0 1 1 0 ;  ...
           ]

for i = 1:size(setting,1)
    options = [];
    options.LBP         = setting(i,1);
    options.color       = setting(i,2);
    options.blockLBP    = setting(i,3);
    options.gabor       = setting(i,4);
    options.normalized  = setting(i,5); 
    options.pca         = setting(i,6);
    feature_matrix = generateFeature( images, options);
    % alls = feature_matrix';
    % save('ETHZ3.mat','alls','gnd');

    demo_NNclassification
end
