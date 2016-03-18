function [histogram_low, histogram_high] = ltp_hist(X, threshold, region_y, region_x)

X = double(X);

[high,low,ternary] = ltp_image(X,threshold,'P8R2');

neighbors = 8;
numBins = 2^neighbors;
histogram_low = spatialhistogram(low, region_y, region_x, numBins);
histogram_high = spatialhistogram(high, region_y, region_x, numBins);
% histogram_low = spatialhistogram(low, 5, 5,numBins);
% histogram_high = spatialhistogram(high, 5, 5,numBins);
% histogram = histogram_high+histogram_low;


% histogram = spatialhistogram(low, 3, 3,numBins);
% histogram = spatialhistogram(high, 3, 3,numBins);