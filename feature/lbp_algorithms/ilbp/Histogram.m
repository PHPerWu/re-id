function HistogramData = Histogram(A,Maxpix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    功  能：输入一幅图像，得到其对应的直方图；             %%%
%%%    输  入：SrcImage：灰度图像矩阵；                           %%%
%%%               Maxpix：图像中的最大灰度值，默认为256      %%%
%%%    输  出：HistogramData ：图像直方图数据。              %%%
%%%                                                                                  %%%
%%%    作  者：盛卉                                                            %%%
%%%    时  间：2013.1.08                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==1 
    Maxpix=256;
end
A=round(A);
HistogramData=zeros(1,Maxpix);                            
for k=0:Maxpix-1
    HistogramData(k+1)=length(find(A==k));    
end

end

