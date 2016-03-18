function model = TPLBP(image, r, S, w, a, region_y, region_x)
%TPLBP Summary of this function goes here
%   Detailed explanation goes here

% �����ͼƬ�ָ�Ϊ3*3����������ΪԭTPLBP�������gridCellY/X�����ص�ĸ�������������ֱ����3
[sizeY sizeX] = size(image);
gridCellY = ceil(sizeY/region_y);
gridCellX = ceil(sizeX/region_x);
[descTPLBP codeTPLBP] = ThreePatch_LBP(image, 'r', r, 'S', S, 'w', w, 'alpha', a, 'gridCellY', gridCellY, 'gridCellX', gridCellX);
% [descTPLBP codeTPLBP] = ThreePatch_LBP(image);

histogram = [];
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
for i = 1:region_y
    for j = 1:region_x
%         region_hist = descTPLBP(:, (i-1)*region_y+j) * region_weights(i,j);
        region_hist = descTPLBP(:, (i-1)*region_y+j);
        histogram = [histogram region_hist'];
    end
end

model = histogram;

end
