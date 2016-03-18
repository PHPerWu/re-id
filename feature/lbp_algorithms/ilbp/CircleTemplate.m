function  Template = CircleTemplate(Radius,Number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ��  �ܣ�����Բ��뾶�Ͳ�������Ŀ�õ�Բ�����������ģ��    %%%
%%%    ��  �룺Radius��Բ��뾶��                                                %%%
%%%               Number��Բ���������Ŀ��                                     %%%
%%%    ��  ����Template ��Բ�����������ģ�塣                           %%%
%%%                                                                                             %%%
%%%    ��  �ߣ�������                                                                    %%%
%%%    ʱ  �䣺2013.1.08                                                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Template=ones(1,Number,2);
for i=1:Number      
     Template(1,i,1) = (cos((360*i/Number) * (pi/180)) * Radius); 
     Template(1,i,2) = (sin((360*i/Number) * (pi/180)) * Radius); 
end

end

