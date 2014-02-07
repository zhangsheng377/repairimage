%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本算法实现图像的误码掩盖
% 
% step   表示blocksize的大小
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_ori=imread('imL_teddy.png');f_ori=rgb2gray(f_ori); 
%f_ori=uint8(f_ori);figure,imshow(f_ori);title('原始图像');  
g_ori=imread('imR_teddy.png');g_ori=rgb2gray(g_ori);

step=16;
f_loss = image_loss(f_ori,step);  %产生丢失的图像；

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   假设图像大小为SATURN.bmp（438×328）
%   M  代表图像的高，     即图像矩阵所有的行数－328
%   N  代表图像的长（宽），即图像矩阵所有的列数－438
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[M,N]=size(g_ori);
[M,N]=size(f_ori);
g=double(g_ori);f=double(f_loss);bz=double(f_ori);
EBx=0; EBy=0; rx=0;ry=0;
temp=zeros(80,80);    
subimage=zeros(48,48);

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 全部采用双线性内插方法1
bif=double(f);
for i=1:step:(M-step+1)
    for j=1:step:(N-step+1)     
     %首先进行的是误码块的检测；   
     if bif(i:i+step-1,j:j+step-1)==0
         EBx=i;EBy=j;                   %找出图象中丢失块的左上角的坐标
         Out=BI(bif,EBx,EBy,step);      %双线性插值
         bif(i:i+step-1,j:j+step-1)=Out;
     end
    end
end
bif=uint8(bif);
bipsnr=psnr(f_ori,bif);  %计算整帧的psnr
figure,imshow(bif);title(strcat('双线性掩盖效果图算法1  PSNR=',num2str(bipsnr)));  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 全部采用双线性内插方法2
bif=double(f);
for i=1:step:(M-step+1)
    for j=1:step:(N-step+1)     
     %首先进行的是误码块的检测；   
     if bif(i:i+step-1,j:j+step-1)==0
         EBx=i;EBy=j;                   %找出图象中丢失块的左上角的坐标
         Out=BI1(bif,EBx,EBy,step);      %双线性插值
         bif(i:i+step-1,j:j+step-1)=Out;
     end
    end
end
bif=uint8(bif);
bipsnr=psnr(f_ori,bif);  %计算整帧的psnr
figure,imshow(bif);title(strcat('双线性掩盖效果图算法2  PSNR=',num2str(bipsnr)));  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%全部采用直接空间替代
left_lost_image = f;
DSP_image=DirectSpatialReplacement(left_lost_image,g,step);
DSP_image=uint8(DSP_image);
DSP_psnr=psnr(f_ori,DSP_image);  %计算整帧的psnr
figure,imshow(DSP_image);title(strcat('直接空间替代掩盖效果图  PSNR=',num2str(DSP_psnr)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%利用相关性算法1
for i=1:step:(M-step+1)
    for j=1:step:(N-step+1)     
     %首先进行的是误码块的检测；   
     if f(i:i+step-1,j:j+step-1)==0 %检测到马赛克；
        rx = i-2*step;  %得到提取区域的左上角的坐标点；
        ry = j-2*step;          
        EBx=i;EBy=j;                     
        rx=EBx-16;
        ry=EBy;
        block1 = f(rx:rx+16-1,ry:ry+16-1);     
        [upblock_h_offset_vector,upblock_v_offset_vector] = findmatchblk(block1,g,rx,ry);         %两幅图定位对比得出偏移值；
        Out=g(EBx+upblock_h_offset_vector:EBx+upblock_h_offset_vector+16-1,EBy+upblock_v_offset_vector:EBy+upblock_v_offset_vector+16-1);     %利用相关性填补马赛克；     
        f(i:i+step-1,j:j+step-1)=Out;     
     end 
    end
end
f=uint8(f);
fpsnr=psnr(f_ori,f);  %计算整帧的psnr
figure,imshow(f);title(strcat('相关性算法1效果图  PSNR=',num2str(fpsnr))); 

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}


% 利用相关性算法2
global offset;
global max;
global sum;
%{
for j=1:N
    for m=1:M
        if f(m,j)==0
            for i=1:N
                f(m,i)=0;
            end
        end
    end
end
%}
%{
for j=1:N
    max=0;
    for l=1:N
        sum=0;
        for m=1:M
            if abs(f(m,j)-bz(m,l))<(0.1*f(m,j))
                sum=sum+1;
                if f(m,j)==0
                    f(m,j)=bz(m,l);
                end
            end
        end
        if sum>max
            max=sum;
            offset=l;
        end
    end
    for m=1:M
        if f(m,j)==0
            f(m,j)=bz(m,l);
        end
    end
end
%}

%{
for j=17:N-17
    for m=17:M-17
        if f(m,j)==0
            for i=17:N-17
            
                if (abs(g(m-16,i)-f(m-16,j))<10)
                    if (abs(g(m+16,i)-f(m+16,j))<10)
                        if (abs(g(m,i-16)-f(m,j-16))<10)
                            if (abs(g(m,i+16)-f(m,j+16))<10)
                                 f(m,j)=g(m,i);
                            end
                        end
                    end
                end
             
            end
        end
    end
end
%}
      
        

for j=1:N
    offset=10;
	max=999999;
	sum=0;
	tot=0;
	for m=1:M
            sum=sum+g(m,j);
    end
    
    for l=j:N
        for k=1:M
                tot=tot+f(k,l);
        end
        if abs(sum-tot)<max
            offset=l-j;
            max=abs(sum-tot);
        end
    end
    for i=1:M
        if f(i,j)==0
            f(i,j)=g(i,j-offset);
        end
	end
end      %以上为计算偏移值
%        for j=1:N-5
%            for i=1:M
%                if f(i,j)==0
%                    f(i,j)=g(i,j-temp);
%                end
%            end
%        end

f=uint8(f);
fpsnr=psnr(f_ori,f);  %计算整帧的psnr
figure,imshow(f);title(strcat('相关性算法2效果图  PSNR=',num2str(fpsnr))); 

%现在整个算法的问题就在于第二个相关性算法，核心目的是利用左右眼图像相对横向偏移值
%来利用右眼图对破损左眼图进行修补。算法为从右眼图第一列各点像素和计算起，以该列像
%素和与左图各列像素和对比，然后以此类推，直到算到值最小，将这两列值进行相减，差即
%为偏移值