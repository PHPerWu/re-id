function histograms = LBPgabor( SrcImage,Scale,Direction, region_y, region_x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    功  能：输入一幅图像，得到其对应直方图特征；   %%%
%%%    输  入：SrcImage：灰度图像矩阵；                    %%%
%%%                Scale：Gabor滤波器尺度；                    %%%
%%%                Direction：Gabor滤波器方向；              %%%
%%%    输  出：histograms ：图像直方图特征。              %%%
%%%                                                                            %%%
%%%    作  者：李永超                                                   %%%
%%%    时  间：2013.1.08                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=0;histogram=[];
histograms = zeros(59, Scale*Direction*region_y*region_x);
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
Gs=mygabor(Scale,Direction);     %调用mygabor()函数生成Gabor滤波模板
 for i=1:Scale
      for j=1:Direction 
          n=n+1;
          conimg = conv2(double(SrcImage),Gs{i,j},'same');    %滤波模板和图像卷积
          mapping=getmapping(8,'u2');
          lbpimage = LBPoriginal(conimg, 1, 8, mapping);   %调用基本LBP函数进行LBP运算
          HistogramData=[];
          [r1 c1]=size(lbpimage);
          for h=1:region_y                   %3X3互不重叠区域划分
               for l=1:region_x
%                     A=lbpimage((1+(h-1)*floor(r1/3)):h*floor(r1/3),(1+(l-1)*floor(c1/3)):l*floor(c1/3));
                    A=lbpimage((1+(h-1)*floor(r1/region_y)):h*floor(r1/region_y),(1+(l-1)*floor(c1/region_x)):l*floor(c1/region_x));
%                     region_hist = Histogram(round(A), 59) * region_weights(h,l);
                    region_hist = Histogram(round(A), 59);
                    HistogramData=[HistogramData region_hist];      %每个图像中的9个区域直方图连接
%                     HistogramData = Histogram(round(A));
%                     histograms(:,n) = HistogramData;
               end
          end
         histogram=[histogram HistogramData];  %所有图像的连接为一个直方图序列
    end
 end
     histograms=histogram;
end





