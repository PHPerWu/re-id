function HistogramData = Histogram(A,Maxpix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ��  �ܣ�����һ��ͼ�񣬵õ����Ӧ��ֱ��ͼ��             %%%
%%%    ��  �룺SrcImage���Ҷ�ͼ�����                           %%%
%%%               Maxpix��ͼ���е����Ҷ�ֵ��Ĭ��Ϊ256      %%%
%%%    ��  ����HistogramData ��ͼ��ֱ��ͼ���ݡ�              %%%
%%%                                                                                  %%%
%%%    ��  �ߣ�ʢ��                                                            %%%
%%%    ʱ  �䣺2013.1.08                                                    %%%
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

