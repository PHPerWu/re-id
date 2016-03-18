function  Template = CircleTemplate(Radius,Number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    功  能：输入圆域半径和采样点数目得到圆域采样点坐标模板    %%%
%%%    输  入：Radius：圆域半径；                                                %%%
%%%               Number：圆域采样点数目；                                     %%%
%%%    输  出：Template ：圆域采样点坐标模板。                           %%%
%%%                                                                                             %%%
%%%    作  者：李永超                                                                    %%%
%%%    时  间：2013.1.08                                                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Template=ones(1,Number,2);
for i=1:Number      
     Template(1,i,1) = (cos((360*i/Number) * (pi/180)) * Radius); 
     Template(1,i,2) = (sin((360*i/Number) * (pi/180)) * Radius); 
end

end

