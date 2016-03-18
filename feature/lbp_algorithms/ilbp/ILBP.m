function model = ILBP(image, radius, neighbor, region_y, region_x)
%ILBP Summary of this function goes here
%   Detailed explanation goes here

grayValues = LBPimproved_Circle(image, radius, neighbor);

[r1 c1]=size(grayValues);
histogram = [];
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
for i = 1:region_y
    for j = 1:region_x
        region_result = grayValues((1+(i-1)*floor(r1/region_y)):i*floor(r1/region_y),(1+(j-1)*floor(c1/region_x)):j*floor(c1/region_x));
%         region_hist = Histogram(region_result(:)) * region_weights(i,j);
        region_hist = Histogram(region_result(:));
        histogram = [histogram region_hist];
    end
end
model = histogram;
end

