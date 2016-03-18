function histogram = dlbp(image, radius, neighbors, dlbpK, region_y, region_x, mapping, mode) % image,radius,neighbors,mapping,mode)

d_image=double(image);

if nargin==6
    mapping=0;
    mode='h';
end
    
spoints=zeros(neighbors,2);
% Angle step.
a = 2*pi/neighbors;
for i = 1:neighbors
    spoints(i,1) = -radius*sin((i-1)*a);
    spoints(i,2) = radius*cos((i-1)*a);
end


% Determine the dimensions of the input image.
[ysize xsize] = size(image);

miny=min(spoints(:,1));
maxy=max(spoints(:,1));
minx=min(spoints(:,2));
maxx=max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
origy=1-floor(min(miny,0));
origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% Fill the center pixel matrix C.
C = image(origy:origy+dy,origx:origx+dx);
d_C = double(C);

bins = 2^neighbors;

% Initialize the result matrix with zeros.
result=zeros(dy+1,dx+1);

%Compute the LBP code image

for i = 1:neighbors
  y = spoints(i,1)+origy;
  x = spoints(i,2)+origx;
  % Calculate floors, ceils and rounds for the x and y.
  fy = floor(y); cy = ceil(y); ry = round(y);
  fx = floor(x); cx = ceil(x); rx = round(x);
  % Check if interpolation is needed.
  if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
    % Interpolation is not needed, use original datatypes
    N = image(ry:ry+dy,rx:rx+dx);
    D = N >= C; 
  else
    % Interpolation needed, use double type images 
    ty = y - fy;
    tx = x - fx;

    % Calculate the interpolation weights.
    w1 = (1 - tx) * (1 - ty);
    w2 =      tx  * (1 - ty);
    w3 = (1 - tx) *      ty ;
    w4 =      tx  *      ty ;
    % Compute interpolated pixel values
    N = w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
        w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx);
    D = N >= d_C; 
  end  
  % Update the result matrix.
  v = 2^(i-1);
  result = result + v*D;
end

%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(result,1)
        for j = 1:size(result,2)
            result(i,j) = mapping.table(result(i,j)+1);
        end
    end
end

[r1 c1]=size(result);
histogram = [];
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    for i = 1:region_y
        for j = 1:region_x
            region_result = result((1+(i-1)*floor(r1/region_y)):i*floor(r1/region_y),(1+(j-1)*floor(c1/region_x)):j*floor(c1/region_x));
            tmp_hist = hist(region_result(:),0:(bins-1));
            tmp_hist = sort(tmp_hist, 'descend');
%             tmp_hist = tmp_hist(1:dlbpK) * region_weights(i,j);
            tmp_hist = tmp_hist(1:dlbpK);
            histogram = [histogram tmp_hist];
        end
    end
     if (strcmp(mode,'nh'))
        histogram=histogram/sum(histogram);
    end
% else
%     %Otherwise return a matrix of unsigned integers
%     if ((bins-1)<=intmax('uint8'))
%         result=uint8(result);
%     elseif ((bins-1)<=intmax('uint16'))
%         result=uint16(result);
%     else
%         result=uint32(result);
%     end
end

% result = sort(result, 'descend');
% result = result(1:dlbpK);

end




