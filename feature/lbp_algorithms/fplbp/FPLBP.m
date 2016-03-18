function model = FPLBP(image, r1, r2, S, w, a, region_y, region_x)
%TPLBP Summary of this function goes here
%   Detailed explanation goes here

% �����ͼƬ�ָ�Ϊ3*3����������ΪԭFPLBP�������gridCellY/X�����ص�ĸ�������������ֱ����3
[sizeY sizeX] = size(image);
gridCellY = floor(sizeY/region_y);
gridCellX = floor(sizeX/region_x);
[descFPLBP codeFPLBP] = FourPatch_LBP(image, 'r1', r1, 'r2', r2, 'S', S, 'w', w, 'alpha', a, 'gridCellY', gridCellY, 'gridCellX', gridCellX);
% [descTPLBP codeTPLBP] = ThreePatch_LBP(image);

histogram = [];
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
for i = 1:region_y
    for j = 1:region_x
%         region_hist = descFPLBP(:, (i-1)*region_y+j) * region_weights(i,j);
        region_hist = descFPLBP(:, (i-1)*region_y+j);
        histogram = [histogram region_hist'];
    end
end

model = histogram;

end

