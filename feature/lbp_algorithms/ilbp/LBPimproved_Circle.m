function  LbpSpectrum = LBPimproved_Circle( SrcImage,Radius,Number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ��  �ܣ�����һ��ͼ�񣬵õ����Ӧ��LBPͼ�ף�    %%%
%%%    ��  �룺SrcImage���Ҷ�ͼ�����                     %%%
%%%               Radius��Բ��뾶��                                 %%%
%%%               Number��Բ���������Ŀ��                     %%%
%%%    ��  ����LbpSpectrum ��LBP�׾���                  %%%
%%%                                                                            %%%
%%%    ��  �ߣ�������                                                   %%%
%%%    ʱ  �䣺2013.1.08                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Row Column]=size(SrcImage);
LbpSpectrum=zeros(Row,Column);
Template = CircleTemplate(Radius,Number);
Temp=zeros(1,Number,2);
r=floor(Radius+1);
SrcImage = Expanboundary( SrcImage,r );
[Row Column]=size(SrcImage);

   for  i=r+1:Row-r
        for  j=r+1:Column-r
              Temp(1,:,1)=i+Template(1,:,1);Temp(1,:,2)=j+Template(1,:,2);
              GrayValue=0; 
              pixarry=ones(1,Number);
              
              for w=1:Number
                   X1=floor(Temp(1,w,1));    X2=X1+1;
                   Y1=floor(Temp(1,w,2));    Y2=Y1+1;
                   Pix(w)=Interpolate(Temp(1,w,1),Temp(1,w,2),X1,Y1,SrcImage(X1,Y1),SrcImage(X2,Y1),SrcImage(X1,Y2),SrcImage(X2,Y2));                  
              end
              pix=sum(sum(Pix))/w;
              for w=1:Number
                   if  Pix(w)>=pix
                       pixarry(w)=1;     
                   else
                      pixarry(w)=0;   
                   end
                   GrayValue=GrayValue+pixarry(w)*(2^(w-1));
              end         
              LbpSpectrum(i-r,j-r)=GrayValue;
        end
   end
end

