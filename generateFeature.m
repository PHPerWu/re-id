function feature_matrix = generateFeature( images, options)
%GENERATEFEATURE generate features
% [features] = generateFeature(images, options)
% images : images cells
% options fileds: 
%       LBP, color, blockLBP, gabor, normalized, pca

n = size(images,2);
feature_matrix = [];
[y x z] = size(images{1});

if isfield(options,'LBP')&& options.LBP
    disp('extracting LBP feature...');
%% LBP feature
    % radius=2;
    % neighbors=8;

    region_y = 6;
    region_x = 1;
    mapping=getmapping(16,'u2');

    lbp_feat = [];
    h = waitbar(0, 'extracting LBP feature...');
    for i = 1:n
        image = images{i};
%         r_lbp = lbp(image(:,:,1), 2, 16, region_y, region_x, mapping);
%         g_lbp = lbp(image(:,:,2), 2, 16, region_y, region_x, mapping);
%         b_lbp = lbp(image(:,:,3), 2, 16, region_y, region_x, mapping);
%         feat = [r_lbp g_lbp b_lbp];
        
        hsv_image = rgb2hsv(image);
%         h_lbp = lbp(hsv_image(:,:,1), 2, 16, region_y, region_x, mapping);
%         s_lbp = lbp(hsv_image(:,:,2), 2, 16, region_y, region_x, mapping);
        v_lbp = lbp(hsv_image(:,:,3), 2, 16, region_y, region_x, mapping,'nh');

        lbp_feat(i,:) = v_lbp; % normed already
        waitbar(i/n, h);
    end
    close(h);
    
    if isfield(options,'normalized')&& options.normalized
%         lbp_feat = lbp_feat/norm(lbp_feat);
        lbp_feat = mapminmax(lbp_feat,0,1);
    end
    feature_matrix = [feature_matrix lbp_feat];
end


if isfield(options,'color')&& options.color
    disp('extracting color feature...');
%% color feature
    color_feat = [];
    
    color_opts = [];
    color_opts.HSV = 1;
    color_opts.RGB = 0;
    color_opts.YCbCr = 0;
    
    h = waitbar(0, 'extracting color feature...');
    for i = 1:n
        image = images{i};
        feat = colorFeature(image,color_opts);
        color_feat(i,:) = feat;
        waitbar(i/n, h);
    end
    close(h);
    
    if isfield(options,'normalized')&& options.normalized
%         color_feat = color_feat/norm(color_feat);
        color_feat = mapminmax(color_feat, 0,1);
    end
    feature_matrix = [feature_matrix color_feat];
end


if isfield(options,'blockLBP')&& options.blockLBP
    disp('extracting block LBP feature...');
    %% block LBP (overlapping block)
    block_feat = [];
    step = 8;
    block_size = 16;
    range_horizontal = floor((x-block_size)/step);
    range_vertical = floor((y-block_size)/step);
    
    h = waitbar(0, 'extracting block LBP feature...');

    for i=1:n    
        image = images{i};
        image = rgb2gray(uint8(image));
        lbp_map = lbp_image(double(image));
%         for k=1:range_horizontal
%             temp_feat= [];
%             for j=1:range_vertical
%                 
                %% test
                blockSize = 16;
                blockStep = 8;
                minRow = 1;
                minCol = 1;
                height = size(image, 1);
                width = size(image, 2);
                maxRow = height - blockSize + 1;
                maxCol = width - blockSize + 1;

                [cols,rows] = meshgrid(minCol:blockStep:maxCol, minRow:blockStep:maxRow); % top-left positions
                cols = cols(:);
                rows = rows(:);
                numBlocks = length(cols);
                
                offset = bsxfun(@plus, (0 : blockSize-1)', (0 : blockSize-1) ); % offset to the top-left positions. blockSize-by-blockSize
                index = sub2ind([height, width], rows, cols);
                index = bsxfun(@plus, offset(:), index'); % (blockSize*blockSize)-by-numBlocks
                lbp_map = reshape(lbp_map,[],1);
                patches = lbp_map(index(:), :); % (blockSize * blockSize * numBlocks)-by-numImgs
                patches = reshape(patches, [], numBlocks); % (blockSize * blockSize)-by-(numBlocks * numChannels * numImgs)

                fea = hist(patches, 0 : 255); % totalBins-by-(numBlocks * numImgs)
                fea = reshape(fea, 1, []);

%                 block_hist = hist(reshape(lbp_map(block_size+step*j-step,...
%                     block_size+step*k-step),1,[]),256);
%                 temp_feat = [temp_feat block_hist]; 
%             end    
%         end
        block_feat(i,:) = fea;
        waitbar(i/n,h);
    end
    close(h);
    
    if isfield(options,'normalized')&& options.normalized
%         block_feat = block_feat/norm(block_feat);
        block_feat = mapminmax(block_feat,0,1);
    end
    feature_matrix = [feature_matrix block_feat];
end

if isfield(options,'gabor')&& options.gabor
    disp('extracting gabor feature...');
    scale = 5;
    direction = 8;
    gabor_feat = [];
    gaborArray = gaborFilterBank(scale, direction, 39, 39);  % Generates the Gabor filter bank
    h = waitbar(0, 'extracting gabor feature...');
    for i = 1:n
        image = images{i};
%         featureVector = gaborFeatures(image,gaborArray,4,4); 
        featureVector = gaborFeature(image,gaborArray); 
        gabor_feat(i,:) = featureVector;
        waitbar(i/n, h);
    end
    close(h);
    if isfield(options,'normalized')&& options.normalized
%         gabor_feat = gabor_feat/norm(gabor_feat);
        gabor_feat = mapminmax(gabor_feat, 0,1);
    end
    feature_matrix = [feature_matrix gabor_feat];
end

if isfield(options,'pca')&& options.pca
    disp('performing PCA');
	pca_opts = [];
	pca_opts.ReducedDim = 100;
	[eigvector,eigvalue,meanData,feature_matrix] = pca(feature_matrix,pca_opts);
end