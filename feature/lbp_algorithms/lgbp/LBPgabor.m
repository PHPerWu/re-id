function histograms = LBPgabor( SrcImage,Scale,Direction, region_y, region_x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    ��  �ܣ�����һ��ͼ�񣬵õ����Ӧֱ��ͼ������   %%%
%%%    ��  �룺SrcImage���Ҷ�ͼ�����                    %%%
%%%                Scale��Gabor�˲����߶ȣ�                    %%%
%%%                Direction��Gabor�˲�������              %%%
%%%    ��  ����histograms ��ͼ��ֱ��ͼ������              %%%
%%%                                                                            %%%
%%%    ��  �ߣ�������                                                   %%%
%%%    ʱ  �䣺2013.1.08                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=0;histogram=[];
histograms = zeros(59, Scale*Direction*region_y*region_x);
region_weights = [2 1 1 1 1 1 2; 2 4 4 1 4 4 2; 1 1 1 0 1 1 1; 0 1 1 0 1 1 0; 0 1 1 1 1 1 0; 0 1 1 2 1 1 0; 0 1 1 1 1 1 0];
Gs=mygabor(Scale,Direction);     %����mygabor()��������Gabor�˲�ģ��
 for i=1:Scale
      for j=1:Direction 
          n=n+1;
          conimg = conv2(double(SrcImage),Gs{i,j},'same');    %�˲�ģ���ͼ����
          mapping=getmapping(8,'u2');
          lbpimage = LBPoriginal(conimg, 1, 8, mapping);   %���û���LBP��������LBP����
          HistogramData=[];
          [r1 c1]=size(lbpimage);
          for h=1:region_y                   %3X3�����ص����򻮷�
               for l=1:region_x
%                     A=lbpimage((1+(h-1)*floor(r1/3)):h*floor(r1/3),(1+(l-1)*floor(c1/3)):l*floor(c1/3));
                    A=lbpimage((1+(h-1)*floor(r1/region_y)):h*floor(r1/region_y),(1+(l-1)*floor(c1/region_x)):l*floor(c1/region_x));
%                     region_hist = Histogram(round(A), 59) * region_weights(h,l);
                    region_hist = Histogram(round(A), 59);
                    HistogramData=[HistogramData region_hist];      %ÿ��ͼ���е�9������ֱ��ͼ����
%                     HistogramData = Histogram(round(A));
%                     histograms(:,n) = HistogramData;
               end
          end
         histogram=[histogram HistogramData];  %����ͼ�������Ϊһ��ֱ��ͼ����
    end
 end
     histograms=histogram;
end





