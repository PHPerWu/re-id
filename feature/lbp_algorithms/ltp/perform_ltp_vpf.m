function [lower_model, upper_model] = perform_ltp_vpf(X,threshold,size_y,size_x)

[rows, cols] = size(X);

lower_model = [];
upper_model = [];

for i = 1:cols
    image = reshape(X(:,i),[size_y,size_x]);
    [lower_hist, upper_hist] = ltp_hist(image,threshold);
    lower_model = [lower_model,lower_hist'];
    upper_model = [upper_model,upper_hist'];
end
