function NormalImage  =  LBPnormalize(SrcImage,Maxpix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    功  能：输入一幅图像，得到其对应归一化后的图像；    %%%
%%%    输  入：SrcImage：灰度图像矩阵；                            %%%
%%%               Maxpix：图像中的最大灰度值，默认为255       %%%
%%%    输  出：NormalImage ：归一化后图像。                    %%%
%%%                                                                                   %%%
%%%    作  者：盛卉                                                             %%%
%%%    时  间：2013.1.08                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==1
    Maxpix=255;
end
    
[Row Column]=size(SrcImage);
NormalImage=zeros(Row,Column);
Max=max(max(SrcImage));
Min=min(min(SrcImage));
 for  i=1:Row
        for  j=1:Column
               NormalImage (i,j)=(SrcImage(i,j)-Min)*Maxpix/(Max-Min);
        end
 end

end

