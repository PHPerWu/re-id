function feature_matrix = generateFeature( images, options)
%GENERATEFEATURE generate features
% [features] = generateFeature(images, options)
% images : images cells
% options fileds: 
%       LBP, color, blockLBP, gabor, normalized, pca

n = size(images,2);
feature_matrix = [];

if isfield(options,'normalized')&& options.normalized
    normalized = options.normalized;
else
    normalized = 0;
end

if isfield(options,'LBP')&& options.LBP
%% LBP feature
    % radius=2;
    % neighbors=8;
    stripes_num = 6;
    region_y = 6;
    region_x = 1;
    mapping=getmapping(16,'u2');

    lbp_feat = [];
    for i = 1:n
        image = images{i};
%         r_lbp = lbp(image(:,:,1), 2, 16, region_y, region_x, mapping);
%         g_lbp = lbp(image(:,:,2), 2, 16, region_y, region_x, mapping);
%         b_lbp = lbp(image(:,:,3), 2, 16, region_y, region_x, mapping);
%         feat = [r_lbp g_lbp b_lbp];
        
        hsv_image = rgb2hsv(image);
%         h_lbp = lbp(hsv_image(:,:,1), 2, 16, region_y, region_x, mapping);
%         s_lbp = lbp(hsv_image(:,:,2), 2, 16, region_y, region_x, mapping);
        v_image = histeq(hsv_image(:,:,3));
        v_lbp = lbp(v_image, 2, 16, region_y, region_x, mapping);
        feat = [v_lbp];
        lbp_feat(i,:) = feat;
    end
    if normalized
        lbp_feat = mapminmax(lbp_feat, 0, 1);
    end
    feature_matrix = [feature_matrix lbp_feat];
end


if isfield(options,'color')&& options.color
    %% color feature
    color_feat = [];
    color_opts = [];
    color_opts.HSV = 1;
    color_opts.RGB = 0;
    color_opts.YCbCr = 0;
    
    for i = 1:n
        image = images{i};
        feat = colorFeature(image,color_opts);
        color_feat(i,:) = feat;
    end
    if normalized
        color_feat = mapminmax(color_feat, 0, 1);
    end
    feature_matrix = [feature_matrix color_feat];
end


if isfield(options,'blockLBP')&& options.blockLBP
    %% block LBP (overlapping block)
    block_feat = [];
    for i=1:n
        image = images{i};
%         lbp_rmap = lbp_image(image(:,:,1));
%         lbp_gmap = lbp_image(image(:,:,2));
%         lbp_bmap = lbp_image(image(:,:,3));
%         ids = -15:16;
%         temp_feat_r = [];
%         temp_feat_g = [];
%         temp_feat_b = [];
%         for j=1:7
%             for k=1:2
%                 temp_feat_r = [temp_feat_r hist(reshape(lbp_rmap(ids+16*j,ids+16*k),1,[]),256)];
%                 temp_feat_g = [temp_feat_g hist(reshape(lbp_gmap(ids+16*j,ids+16*k),1,[]),256)];
%                 temp_feat_b = [temp_feat_b hist(reshape(lbp_bmap(ids+16*j,ids+16*k),1,[]),256)];
%             end
%         end
%         block_feat(i,:) = [temp_feat_r temp_feat_g temp_feat_b];
        image = rgb2gray(uint8(image));
        lbp_map = lbp_image(double(image));
        ids = -15:16;
        temp_feat= [];
        for j=1:7
            for k=1:2
                temp_feat = [temp_feat hist(reshape(lbp_map(ids+16*j,ids+16*k),1,[]),256)];
            end
        end
        block_feat(i,:) = temp_feat;
    end
    if normalized
        block_feat = mapminmax(block_feat, 0, 1);
    end
    feature_matrix = [feature_matrix block_feat];
end

if isfield(options,'gabor')&& options.gabor
    scale = 5;
    direction = 8;
    gabor_feat = [];
    gaborArray = gaborFilterBank(scale,direction,39,39);  % Generates the Gabor filter bank
    for i = 1:n
        image = images{i};
%         featureVector = gaborFeatures(image,gaborArray,4,4); 
        featureVector = gaborFeature(image,gaborArray); 
        gabor_feat(i,:) = featureVector;
    end
    if normalized
        gabor_feat = mapminmax(gabor_feat, 0, 1);
    end
    feature_matrix = [feature_matrix gabor_feat];
end

if isfield(options,'pca')&& options.pca
	pca_opts = [];
	pca_opts.ReducedDim = 100;
	[eigvector,eigvalue,meanData,feature_matrix] = pca(feature_matrix,pca_opts);
end