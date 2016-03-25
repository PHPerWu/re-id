function features = colorFeatures(image, options )

%COLORFEATURES generate color feature of images
%   'RGB', 'YCbCr', 'HSV'
%   Detailed explanation goes here

if isfield(options, 'RGB')
    RGB = options.RGB;
end

if isfield(options, 'HSV')
    HSV = options.HSV;
end

if isfield(options, 'YCbCr')
    YCbCr = options.YCbCr;
end

stripes_num = 6;
features = [];
bins = 16;

%% color transfer
% image = Retinex(image);

%%
[m, n, c] = size(image);
horizontal_step = floor(m/stripes_num);

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
        hsv_image(:,:,3)= histeq(hsv_image(:,:,3));
        
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

    
