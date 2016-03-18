function features = generateFeature( images,  lbp_feature, color_feature,...
    blockLBP_feature, gabor_feature, normalized)
%GENERATEFEATURE generate features
% [features] = generateFeature(images)
n = size(images,2);
features = [];

if lbp_feature
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
        v_lbp = lbp(hsv_image(:,:,3), 2, 16, region_y, region_x, mapping);
        feat = [v_lbp];
        lbp_feat(i,:) = feat;
    end
    if normalized
        lbp_feat = mapminmax(lbp_feat, 0, 1);
    end
    features = [features lbp_feat];
end


if color_feature
    %% color feature
    color_feat = [];
    for i = 1:n
        image = images{i};
        feat = colorFeature(image);
        color_feat(i,:) = feat;
    end
    if normalized
        color_feat = mapminmax(color_feat, 0, 1);
    end
    features = [features color_feat];
end


if blockLBP_feature
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
    features = [features block_feat];
end

if gabor_feature
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
    features = [features gabor_feat];
end