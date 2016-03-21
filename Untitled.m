%% matrix v: one vector per column
v = [test_features' train_features'];
k = 100;
[C, D, I, Nassign] = yael_kmeans (single(v), k);

%% show particular cluster
c = 1; % class c
images = v(:,I==c);


%% NN classification
train = feature_matrix(1:632,:)';
test = feature_matrix(633:1264,:)';
train_ids = labels(1:632);
test_ids = labels(633:1264);
n = 100;
results = nn_classification_PhD(train, train_ids, test, test_ids, n, 'euc','all');
output = evaluate_results_PhD(results,'ID');
plot_CMC_PhD(output.CMC_rec_rates, uint8(output.CMC_ranks));