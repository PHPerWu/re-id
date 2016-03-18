% Randomized ids and images

function [rand_ids, rand_images] = randId(ids, images)
index = randperm(length(ids));

rand_ids = ids(index);
rand_images = images(:,index);