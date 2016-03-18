% matrix v: one vector per column
v = [test_features' train_features'];
k = 100;
[C, D, I, Nassign] = yael_kmeans (single(v), k);

% show particular cluster
c = 1; % class c
images = v(:,I==c);
