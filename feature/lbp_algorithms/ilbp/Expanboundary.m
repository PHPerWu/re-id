function DesImage = Expanboundary( SrcImage,Num )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    功  能：输入一幅图像，扩充其边界；             %%%
%%%    输  入：SrcImage：灰度图像矩阵；               %%%
%%%               Num：边界扩充的像素数目；             %%%
%%%    输  出：DesImage：扩充边界后的图像。        %%%
%%%                                                                       %%%
%%%    作  者：盛卉                                                 %%%
%%%    时  间：2013.1.08                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [Row Column]=size(SrcImage);
 DesImage=zeros(Row+2*Num,Column+2*Num);
 DesImage(Num+1:Row+Num,Num+1:Column+Num)=SrcImage(1:Row,1:Column); 

 for i=0:Num-1
    DesImage(i+1,:)=DesImage(Num+1,:);
    DesImage((Row+2*Num-i),:)=DesImage(Row+2*Num-Num,:);
    DesImage(:,i+1)=DesImage(:,Num+1);
    DesImage(:,(Column+2*Num-i))=DesImage(:,Column+2*Num-Num); 
 end
end

