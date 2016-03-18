function model = ldp(image, region_y, region_x)

radius = 1;
neighbors = 8;

[m,n]=size(image);
t=zeros(m+2,n+2);
p=zeros(m+2,n+2,4);%存放每个像素的在4个方向的一阶偏导
t(2:m+1,2:n+1)=image;
ldp=zeros(m,n,4);

% old method
% for i=2:m+1 %求一阶偏导
%    for j=2:n+1
%         p(i,j,1)=((t(i,j)-t(i,j+1))>0);%0°
%         p(i,j,2)=((t(i,j)-t(i-1,j+1))>0);%45°
%         p(i,j,3)=((t(i,j)-t(i-1,j))>0);%90°
%         p(i,j,4)=((t(i,j)-t(i-1,j-1))>0);%135°
%    end
% end

for i=2:m+1 %求一阶偏导
   for j=2:n+1
        p(i,j,1)=t(i,j)-t(i,j+1);%0°
        p(i,j,2)=t(i,j)-t(i-1,j+1);%45°
        p(i,j,3)=t(i,j)-t(i-1,j);%90°
        p(i,j,4)=t(i,j)-t(i-1,j-1);%135°
   end
end

orientation = 4;
% spoints=[-1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1];
spoints = [0,-1; 1,-1; 1,0; 1,1; 0,1; -1,1; -1,0; -1,-1];
% spoints = [];
% a = 2*pi/neighbors;
% for i = 1:neighbors
%     spoints(i,1) = round(-radius*sin((i-1)*a));
%     spoints(i,2) = round(radius*cos((i-1)*a));
% end
origy = 2; origx = 2;
dy = m+1-2; dx = n+1-2;
for k = 1:orientation
    C = p(origy:origy+dy,origx:origx+dx, k);
    result=zeros(m,n);
    for i = 1:neighbors
        y = spoints(i,1) + origy;
        x = spoints(i,2) + origx;
        
        N = p(y:y+dy,x:x+dx,k);
        D = (N.*C<=0);
%         D = N ~= C;
        
        v = 2^(i-1);
        result = result + v*D;
    end
    ldp(:,:,k) = result;
end

histogram = [];
dy = floor(m/region_y);
dx = floor(n/region_x);
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
for i = 1:region_y
    y = (i-1)*dy;
    for j = 1:region_x
        x = (j-1)*dx;
        for k = 1:4
            sub_result = ldp(y+1:y+dy,x+1:x+dx,k);
%             region_hist = hist(sub_result(:), 64) * region_weights(i,j);
            region_hist = hist(sub_result(:), 64);
            histogram = [histogram region_hist];
        end
    end
end

% 注注注：
% 明天调试一下histogram bins 8, 32, 59, 64
%  30bins下运行效果还不错，表情是89.几， 光照是27.几；但8bins下效果不太好

% h_orientation = [];
% for k = 1:4
%     h_orientation = [h_orientation Histogram(ldp(:,:,k))];
% end

model = histogram;

end