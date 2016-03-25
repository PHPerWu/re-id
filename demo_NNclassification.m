%% NN classification
train = feature_matrix(1:632,:)';
test = feature_matrix(633:1264,:)';
train_ids = labels(1:632);
test_ids = labels(633:1264);

% load('mat/features.mat');
% load('mat/viper_own.mat');
% train = descriptors(1:632,:)';
% test = descriptors(633:1264,:)';

n = size(train,1);
results = nn_classification_PhD(train, train_ids, test, test_ids, n, 'euc','all');
output = evaluate_results_PhD(results,'ID');
plot_CMC_PhD(output.CMC_rec_rates, uint8(output.CMC_ranks));