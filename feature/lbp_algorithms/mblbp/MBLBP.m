% This function just using to obtain the MBLBP image
% Hunan University
% Edit 25.01.2013
% if you find anything wrong,just not hesitate to email me
% hudalikm@163.com
% look for the paper:"Learning Multi-scale Block Local Binary Patterns for
% Face Recognition" for details.
function result=MBLBP(img,scales, region_y, region_x)
% img:input image,double type
% scales: operator scale
if ndims(img)==3 % if the image is rgb,just transform to gray
    img=rgb2gray(img);
end
[m,n]=size(img);
dlbpvalue=zeros(m,n); % variant for result
intergraimg=getIntergraimage(img); % obtain the intergral image
tempimg=zeros(m+3*scales,n+3*scales); % scales+1 for the first pixel and 2*scales-1 for the last ,every dimensions 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempimg(scales+2:m+scales+1,scales+2:n+scales+1)=intergraimg.img; % extend the image

for i=scales+2:m+scales+1 % image
    for j=scales+2:n+scales+1
        value.center=getblockmeanv(tempimg,i,j,scales);
        value.one=getblockmeanv(tempimg,i-scales,j-scales,scales);
        value.two=getblockmeanv(tempimg,i-scales,j,scales);
        value.three=getblockmeanv(tempimg,i-scales,j+scales,scales);
        value.four=getblockmeanv(tempimg,i,j+scales,scales);
        value.five=getblockmeanv(tempimg,i+scales,j+scales,scales);
        value.six=getblockmeanv(tempimg,i+scales,j,scales);
        value.seven=getblockmeanv(tempimg,i+scales,j-scales,scales);
        value.eight=getblockmeanv(tempimg,i,j-scales,scales);
        dlbpvalue(i-scales-1,j-scales-1)=lbp(value);
    end
end

[r1 c1]=size(dlbpvalue);
histogram = [];
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
for i = 1:region_y
    for j = 1:region_x
        region_result = dlbpvalue((1+(i-1)*floor(r1/region_y)):i*floor(r1/region_y),(1+(j-1)*floor(c1/region_x)):j*floor(c1/region_x));
%         region_hist = Histogram(region_result(:)) * region_weights(i,j);
        region_hist = Histogram(region_result(:));
        histogram = [histogram region_hist];
    end
end
result=histogram;
end


function value=getblockmeanv(tempimg,i,j,scales) 
% This function using to get every blocks average value
    value=tempimg(i+scales-1,j+scales-1)-tempimg(i+scales-1,j-1)-tempimg(i-1,j+scales-1)+tempimg(i-1,j-1);
    value=value/(scales*scales);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tempimg(scales+3:m+scales+2,scales+3:n+scales+2)=intergraimg.img; % extend the image
% 
% for i=scales+3:m+scales+2 % image
%     for j=scales+3:n+scales+2
%         value.center=getblockmeanv(tempimg,i,j,scales);
%         value.one=getblockmeanv(tempimg,i-scales,j-scales,scales);
%         value.two=getblockmeanv(tempimg,i-scales,j,scales);
%         value.three=getblockmeanv(tempimg,i-scales,j+scales,scales);
%         value.four=getblockmeanv(tempimg,i,j+scales,scales);
%         value.five=getblockmeanv(tempimg,i+scales,j+scales,scales);
%         value.six=getblockmeanv(tempimg,i+scales,j,scales);
%         value.seven=getblockmeanv(tempimg,i+scales,j-scales,scales);
%         value.eight=getblockmeanv(tempimg,i,j-scales,scales);
%         dlbpvalue(i-scales-2,j-scales-2)=lbp(value);
%     end
% end
% MBLBPIMG=dlbpvalue;
% end
% 
% 
% function value=getblockmeanv(tempimg,i,j,scales) 
% % This function using to get every blocks average value
%     value=tempimg(i+scales-2,j+scales-2)-tempimg(i+scales-2,j-2)-tempimg(i-2,j+scales-2)+tempimg(i-2,j-2);
%     value=value/(scales*scales);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function dvalue=lbp(value)
% This function using to get block LBP
      dvalue=0;
      vectors=[value.one value.two value.three value.four value.five value.six value.seven value.eight];
      bvectors=vectors>=value.center;
      for i=1:length(bvectors)
          dvalue=dvalue+bvectors(i)*2.^(i-1);
      end
end












