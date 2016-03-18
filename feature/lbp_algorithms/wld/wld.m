function model = wld(X, Tbin, Mbin, Sbin, region_y, region_x) 

% The example codes are computed using N=8 sampling points on a square of R=3
% image=imread('sample_image.bmp');
% subplot(2,2,1),imshow(image); title('RGB image'); %stem(image);
% image=rgb2gray(image); subplot(2,2,2),imshow(image); title('grey image');
% d_image=double(image);

d_image = double(X);


% Determine the dimensions of the input image.
[ysize xsize] = size(d_image);


% Block size, each WLD code is computed within a block of size bsizey*bsizex
bsizey=3;
bsizex=3;

radius = 1;

BELTA=5; % to avoid that center pixture is equal to zero
ALPHA=3; % like a lens to magnify or shrink the difference between neighbors
EPSILON=0.0000001;
PI=3.141592653589;

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% filter
%    1  2  3  4   5  6  7  8  9
f00=[1, 1, 1; 1, -8, 1; 1, 1, 1];
% f00=[1, 1, 1, 1, 1; 1, 0, 0, 0, 1; 1, 0, -8, 0, 1; 1, 0, 0, 0, 1; 1, 1, 1, 1, 1];


% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% two matriies 
% Initialize the result matrix with zeros.
d_differential_excitation = zeros(dy+1,dx+1);
d_gradient_orientation    = zeros(dy+1,dx+1);

%Compute the WLD code per pixle
for y = (radius+1):ysize-radius
    for x = (radius+1):xsize-radius
         N=d_image(y-radius:y+radius,x-radius:x+radius); % 3*3 block neighbors
         center=d_image(y,x);
        
        % step 1 compute differential excitationt
        v00=sum(sum(f00 .* N));
        v01=center + BELTA; % BELTA to avoid that center pixture is equal to zero

        if ( v01 ~= 0 )
            d_differential_excitation(y,x)=atan(ALPHA*v00/v01);% ALPHA like a lens to magnify or shrink the difference between neighbors
        else
            d_differential_excitation(y,x)=0.1;% set the phase of the current pixel directly by WLD
        end
        
         % step 2 compute gradient orientation
         N1=d_image(y-radius,x);         N5=d_image(y+radius,x);
         N3=d_image(y,x+radius);         N7=d_image(y,x-radius);
         
         if ( abs(N7-N3) < EPSILON)		d_gradient_orientation(y,x) = 0;
         else
             v10=N5-N1;		v11=N7-N3;
             d_gradient_orientation(y,x) = atan(v10/v11);
             
             % transform to a degree for convient visualization
             d_gradient_orientation(y,x)=d_gradient_orientation(y,x)*180/PI;
             
             if     (v11 >  EPSILON && v10 >  EPSILON)		
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 0;    % the first quadrant
             elseif (v11 < -EPSILON && v10 >  EPSILON)      
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 180;  % the second quadrant
             elseif (v11 < -EPSILON && v10 < -EPSILON)      
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 180;  % the third quadrant
             elseif (v11 >  EPSILON && v10 < -EPSILON)		
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 360;  % the fourth quadrant
             end
         end
    end
end

% generate histogram

if nargin<2
    Tbin = 8;
    Mbin = 6;
    Sbin = 3;
end

T = Tbin; % for orientation, 8 if omitted
M = Mbin; % for excitation, 6 if omitted
S = Sbin; % number of bins in subhistogram
C = M*S;

Cval = -pi/2:pi/C:pi/2; % Excitation
Cvalcen = (Cval(1:end-1)+Cval(2:end))/2;

Tval = 0:360/T:360; % Orientation

[r1 c1] = size(d_differential_excitation);
dy = floor(r1/region_y);
dx = floor(c1/region_x);
histogram = [];
weight = [0.2688, 0.0852, 0.0955, 0.1000, 0.1018, 0.3487];
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
% region_d_differential_excitation = zeros(dy,dx);
% region_d_gradient_orientation    = zeros(dy,dx);
for m = 1:region_y
    start_y = (m-1)*dy;
    for n = 1:region_x
        start_x = (n-1)*dx;
        WLDH2D = zeros(C,T);
        region_d_differential_excitation = d_differential_excitation(1+start_y:dy+start_y, 1+start_x:dx+start_x);
        region_d_gradient_orientation = d_gradient_orientation(1+start_y:dy+start_y, 1+start_x:dx+start_x);
        for i = 1:T
            if i>1
                temp = region_d_differential_excitation(region_d_gradient_orientation>Tval(i)&region_d_gradient_orientation<=Tval(i+1));
            else
                temp = region_d_differential_excitation(region_d_gradient_orientation>=Tval(i)&region_d_gradient_orientation<=Tval(i+1));
            end
%             WLDH2D(:,i) = hist(temp,Cvalcen) * region_weights(m,n);
            WLDH2D(:,i) = hist(temp,Cvalcen);
        end

        h = WLDH2D';
        h = reshape(h,[T,S,M]);
        temph = []; % final 1d histogram
        for j = 1:M;
            temp = h(:,:,j);
            temp = temp';
            temp = temp*weight(j);
            temph = [temph; temp(:)];
        end
        histogram = [histogram; temph(:)];
    end
end
% model = temph;
model = histogram;