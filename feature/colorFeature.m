function features = colorFeatures( image )
%COLORFEATURES generate color feature of images
%   'RGB', 'YCbCr', 'HSV'
%   Detailed explanation goes here

RGB = 0;
YCbCr = 0;
HSV = 1;

stripes_num = 6;
features = [];
bins = 16;

%% color transfer
% image = Retinex(image);

[m, n, c] = size(image);
horizontal_step = uint8(m/stripes_num);

for i = 1:stripes_num
    if RGB
       RGB_feat = [hist_16D(image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,1),bins) ...
           hist_16D(image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,2),bins) ...
           hist_16D(image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,3),bins)];
       features = [features RGB_feat];
    end

    if YCbCr
        ycbcr_image = rgb2ycbcr(image);
        YCbCr_feat = [hist_16D(ycbcr_image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,1), bins) ...
           hist_16D(ycbcr_image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,2),bins) ...
           hist_16D(ycbcr_image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,3), bins)];
       features = [features YCbCr_feat];
    end

    if HSV 
        hsv_image = rgb2hsv(uint8(image));
        HSV_feat = [ hist_16D(hsv_image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,1),bins) , ...
               hist_16D(hsv_image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,2), bins), ...
               hist_16D(hsv_image((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,3), bins)];
       features = [features HSV_feat];
    end
end

function feat_histogram = hist_16D(res, bins)
%% Construct a 16 dimension vector 
    res = double(res);
    feat_histogram = [];
    feat_histogram = hist(reshape(res,1,[]), bins);

    
