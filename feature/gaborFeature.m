function featureVector = gaborFeature( img, gaborArray )
%GABORFEATURE Extract gabor feature form image
%   Different from gabor/gaborFeatures, it based on spatial sampling not 
% downsampling.

    if size(img,3) == 3     % Check if the input image is grayscale
        warning('The input RGB image is converted to grayscale!')
        img = rgb2gray(img);
    end

    img = double(img);

    %% Filter the image using the Gabor filter bank

    % Filter input image by each Gabor filter
    [u,v] = size(gaborArray);
    gaborResult = cell(u,v);
    for i = 1:u
        for j = 1:v
            gaborResult{i,j} = imfilter(img, gaborArray{i,j});
        end
    end

    % Extract feature vector from input image
    featureVector = [];
    [m, n, c] = size(img);
    stripes_num = 6;
    bins = 16;
    horizontal_step = uint8(m/stripes_num);
    for i = 1:u
        for j = 1:v
            for k = 1:stripes_num
                gaborAbs = abs(gaborResult{i,j});
                gaborAbs = hist_16D(gaborAbs((i*horizontal_step -horizontal_step +1):i*horizontal_step,:,1), bins);
                gaborAbs = gaborAbs(:);

                % Normalized to zero mean and unit variance. (if not applicable, please comment this line)
                gaborAbs = (gaborAbs-mean(gaborAbs))/std(gaborAbs,1);

                featureVector =  [featureVector; gaborAbs];
            end
        end
    end
end

function feat_histogram = hist_16D(res, bins)
%% Construct a 16 dimension vector 
    res = double(res);
    feat_histogram = [];
    feat_histogram = hist(reshape(res,1,[]), bins);

end