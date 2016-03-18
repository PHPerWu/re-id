function  Gs = mygabor(V,U)
% 生成的gabor filter 还是不错的
%            ||Ku,v||^2
% G(Z) = ---------------- exp(-||Ku,v||^2 * Z^2)/(2*sigma^2)(exp(i*Ku,v*Z)-exp(-sigma*sigma/2))
%          sigma*sigma

sigma = 2^(1/2)*pi;   
sigma2 =sigma^2;
GaborZ =51;
n=1;
% figure;
for v=0:V-1
    for u=0:U-1
        Kv = pi*2^(-(v+2)/2);   %Kv=Kmax/f^v;  Kmax=pi/2;  f=2^2;  v决定了滤波器的尺度
                                           %sigma/Kv决定了高斯窗口的大小
        faiu = pi * u/U;   %faiu=pi*miu/K；    
                                  %miu值表示核函数的方向，K表示总方向数
        Kj = [Kv *cos(faiu)  Kv *sin(faiu)];%Kj = Kv * exp( i * faiu );
        Kuv = norm(Kj');   %norm求范数
        Kuv = Kuv.^2;
        Gab1 = (Kuv /(sigma2));
        for zx = -GaborZ:GaborZ-1
            for zy = -GaborZ:GaborZ-1
                x = [zx zy];
                x=x';
                Gab2 = exp(-Kuv * (zx^2 + zy^2)/(2*sigma2));
                Gab3 = (exp(sqrt(-1) * Kj * x) - exp(-(sigma2)/2));
                Gr(zx+GaborZ+1,zy+GaborZ+1) = real(Gab1 * Gab2 * Gab3);
            end
        end
%         subplot(V,U,n),imshow(Gr,[]);
        Gs{v+1,u+1}=Gr;
        n=n+1; 
    end
end

