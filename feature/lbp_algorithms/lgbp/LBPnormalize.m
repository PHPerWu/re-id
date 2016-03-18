function NormalImage  =  LBPnormalize(SrcImage,Maxpix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ��  �ܣ�����һ��ͼ�񣬵õ����Ӧ��һ�����ͼ��    %%%
%%%    ��  �룺SrcImage���Ҷ�ͼ�����                            %%%
%%%               Maxpix��ͼ���е����Ҷ�ֵ��Ĭ��Ϊ255       %%%
%%%    ��  ����NormalImage ����һ����ͼ��                    %%%
%%%                                                                                   %%%
%%%    ��  �ߣ�ʢ��                                                             %%%
%%%    ʱ  �䣺2013.1.08                                                     %%%
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

