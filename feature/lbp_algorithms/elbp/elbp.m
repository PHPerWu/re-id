% LBP returns the local binary pattern image or LBP histogram of an image.
%  J = LBP(I,R,N,MAPPING,MODE) returns either a local binary pattern
%  coded image or the local binary pattern histogram of an intensity
%  image I. The LBP codes are computed using N sampling points on a 
%  circle of radius R and using mapping table defined by MAPPING. 
%  See the getmapping function for different mappings and use 0 for
%  no mapping. Possible values for MODE are
%       'h' or 'hist'  to get a histogram of LBP codes
%       'nh'           to get a normalized histogram
%  Otherwise an LBP code image is returned.
%
%  J = LBP(I) returns the original (basic) LBP histogram of image I
%
%  J = LBP(I,SP,MAPPING,MODE) computes the LBP codes using n sampling
%  points defined in (n * 2) matrix SP. The sampling points should be
%  defined around the origin (coordinates (0,0)).
%
%  Examples
%  --------
%       I=imread('lena.jpg');
%       mapping=getmapping(16,'u2'); 
%       H1=LBP(I,1,8,mapping,'h'); %LBP histogram in (8,1) neighborhood
%                                  %using uniform patterns
%       subplot(2,1,1),stem(H1);
%
%       H2=LBP(I);
%       subplot(2,1,2),stem(H2);
%
%       SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
%       I2=LBP(I,SP,0,'i'); %LBP code image using sampling points in SP
%                           %and no mapping. Now H2 is equal to histogram
%                           %of I2.

function model = elbp(varargin) % image,radius,neighbors,mapping,mode)
% Version 0.3.2
% Authors: Marko Heikkil?and Timo Ahonen

% Changelog
% Version 0.3.2: A bug fix to enable using mappings together with a
% predefined spoints array
% Version 0.3.1: Changed MAPPING input to be a struct containing the mapping
% table and the number of bins to make the function run faster with high number
% of sampling points. Lauge Sorensen is acknowledged for spotting this problem.


% Check number of input arguments.
error(nargchk(1,7,nargin));

image=varargin{1};
d_image=double(image);

if nargin==1
    spoints=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
    neighbors=8;
    region_y = 7;
    region_x = 6;
    mapping=0;
    mode='h';
end

if (nargin == 2) && (length(varargin{2}) == 1)
    error('Input arguments');
end

if (nargin > 4) && (length(varargin{2}) == 1)
    radius=varargin{2};
    neighbors=varargin{3};
    region_y = varargin{4};
    region_x = varargin{5};
    
    spoints=zeros(neighbors,2);

    % Angle step.
    a = 2*pi/neighbors;
    
    for i = 1:neighbors
        spoints(i,1) = -radius*sin((i-1)*a);
        spoints(i,2) = radius*cos((i-1)*a);
    end
    
    if(nargin >= 6)
        mapping=varargin{6};
        if(isstruct(mapping) && mapping.samples ~= neighbors)
            error('Incompatible mapping');
        end
    else
        mapping=0;
    end
    
    if(nargin >= 7)
        mode=varargin{7};
    else
        mode='h';
    end
end

if (nargin > 1) && (length(varargin{2}) > 1)
    spoints=varargin{2};
    neighbors=size(spoints,1);
    
    if(nargin >= 3)
        mapping=varargin{3};
        if(isstruct(mapping) && mapping.samples ~= neighbors)
            error('Incompatible mapping');
        end
    else
        mapping=0;
    end
    
    if(nargin >= 4)
        mode=varargin{4};
    else
        mode='h';
    end   
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

% Initialize the result matrix with zeros. Four layers.
result=zeros(dy+1,dx+1,4);

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
    L1 = N >= C; %sign
    D = abs(N - C); %difference
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
    L1 = N >= d_C; 
    D = abs(N - d_C);
  end  
  D(D>7) = 7;
  L = dec2bin(D, 3);
  L2 = reshape(L(:,1), dy+1, dx+1) == '1';
  L3 = reshape(L(:,2), dy+1, dx+1) == '1';
  L4 = reshape(L(:,3), dy+1, dx+1) == '1';
  % Update the result matrix.
  v = 2^(i-1);
  result(:,:,1) = result(:,:,1) + v*L1;
  result(:,:,2) = result(:,:,2) + v*L2;
  result(:,:,3) = result(:,:,3) + v*L3;
  result(:,:,4) = result(:,:,4) + v*L4;
end

%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(result(:,:,1),1)
        for j = 1:size(result(:,:,1),2)
            for l = 1:4
                result(i,j,l) = mapping.table(result(i,j,l)+1);
            end
        end
    end
end

hist = [];
dy = floor(size(result(:,:,1),1)/region_y);
dx = floor(size(result(:,:,1),2)/region_x);
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
for i = 1:region_y
    y = (i-1)*dy;
    for j = 1:region_x
        x = (j-1)*dx;
        h_orientation = [];
        for k = 1:4
%             region_hist = Histogram(result(y+1:y+dy,x+1:x+dx,k), bins) * region_weights(i,j);
            region_hist = Histogram(result(y+1:y+dy,x+1:x+dx,k), bins);
            h_orientation = [h_orientation region_hist];
        end
        hist = [hist h_orientation];
    end
end

model = hist;

% if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
%     % Return with LBP histogram if mode equals 'hist'.
%     result=hist(result(:),0:(bins-1));
%     if (strcmp(mode,'nh'))
%         result=result/sum(result);
%     end
% else
%     %Otherwise return a matrix of unsigned integers
%     if ((bins-1)<=intmax('uint8'))
%         result=uint8(result);
%     elseif ((bins-1)<=intmax('uint16'))
%         result=uint16(result);
%     else
%         result=uint32(result);
%     end
% end

end