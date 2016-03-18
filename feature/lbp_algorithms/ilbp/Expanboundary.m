function DesImage = Expanboundary( SrcImage,Num )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ��  �ܣ�����һ��ͼ��������߽磻             %%%
%%%    ��  �룺SrcImage���Ҷ�ͼ�����               %%%
%%%               Num���߽������������Ŀ��             %%%
%%%    ��  ����DesImage������߽���ͼ��        %%%
%%%                                                                       %%%
%%%    ��  �ߣ�ʢ��                                                 %%%
%%%    ʱ  �䣺2013.1.08                                         %%%
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

