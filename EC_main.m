%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���㷨ʵ��ͼ��������ڸ�
% 
% step   ��ʾblocksize�Ĵ�С
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f_ori=imread('imL_teddy.png');f_ori=rgb2gray(f_ori); 
%f_ori=uint8(f_ori);figure,imshow(f_ori);title('ԭʼͼ��');  
g_ori=imread('imR_teddy.png');g_ori=rgb2gray(g_ori);

step=16;
f_loss = image_loss(f_ori,step);  %������ʧ��ͼ��

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ����ͼ���СΪSATURN.bmp��438��328��
%   M  ����ͼ��ĸߣ�     ��ͼ��������е�������328
%   N  ����ͼ��ĳ���������ͼ��������е�������438
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[M,N]=size(g_ori);
[M,N]=size(f_ori);
g=double(g_ori);f=double(f_loss);bz=double(f_ori);
EBx=0; EBy=0; rx=0;ry=0;
temp=zeros(80,80);    
subimage=zeros(48,48);

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ȫ������˫�����ڲ巽��1
bif=double(f);
for i=1:step:(M-step+1)
    for j=1:step:(N-step+1)     
     %���Ƚ��е��������ļ�⣻   
     if bif(i:i+step-1,j:j+step-1)==0
         EBx=i;EBy=j;                   %�ҳ�ͼ���ж�ʧ������Ͻǵ�����
         Out=BI(bif,EBx,EBy,step);      %˫���Բ�ֵ
         bif(i:i+step-1,j:j+step-1)=Out;
     end
    end
end
bif=uint8(bif);
bipsnr=psnr(f_ori,bif);  %������֡��psnr
figure,imshow(bif);title(strcat('˫�����ڸ�Ч��ͼ�㷨1  PSNR=',num2str(bipsnr)));  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ȫ������˫�����ڲ巽��2
bif=double(f);
for i=1:step:(M-step+1)
    for j=1:step:(N-step+1)     
     %���Ƚ��е��������ļ�⣻   
     if bif(i:i+step-1,j:j+step-1)==0
         EBx=i;EBy=j;                   %�ҳ�ͼ���ж�ʧ������Ͻǵ�����
         Out=BI1(bif,EBx,EBy,step);      %˫���Բ�ֵ
         bif(i:i+step-1,j:j+step-1)=Out;
     end
    end
end
bif=uint8(bif);
bipsnr=psnr(f_ori,bif);  %������֡��psnr
figure,imshow(bif);title(strcat('˫�����ڸ�Ч��ͼ�㷨2  PSNR=',num2str(bipsnr)));  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ȫ������ֱ�ӿռ����
left_lost_image = f;
DSP_image=DirectSpatialReplacement(left_lost_image,g,step);
DSP_image=uint8(DSP_image);
DSP_psnr=psnr(f_ori,DSP_image);  %������֡��psnr
figure,imshow(DSP_image);title(strcat('ֱ�ӿռ�����ڸ�Ч��ͼ  PSNR=',num2str(DSP_psnr)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����������㷨1
for i=1:step:(M-step+1)
    for j=1:step:(N-step+1)     
     %���Ƚ��е��������ļ�⣻   
     if f(i:i+step-1,j:j+step-1)==0 %��⵽�����ˣ�
        rx = i-2*step;  %�õ���ȡ��������Ͻǵ�����㣻
        ry = j-2*step;          
        EBx=i;EBy=j;                     
        rx=EBx-16;
        ry=EBy;
        block1 = f(rx:rx+16-1,ry:ry+16-1);     
        [upblock_h_offset_vector,upblock_v_offset_vector] = findmatchblk(block1,g,rx,ry);         %����ͼ��λ�Աȵó�ƫ��ֵ��
        Out=g(EBx+upblock_h_offset_vector:EBx+upblock_h_offset_vector+16-1,EBy+upblock_v_offset_vector:EBy+upblock_v_offset_vector+16-1);     %���������������ˣ�     
        f(i:i+step-1,j:j+step-1)=Out;     
     end 
    end
end
f=uint8(f);
fpsnr=psnr(f_ori,f);  %������֡��psnr
figure,imshow(f);title(strcat('������㷨1Ч��ͼ  PSNR=',num2str(fpsnr))); 

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}


% ����������㷨2
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
end      %����Ϊ����ƫ��ֵ
%        for j=1:N-5
%            for i=1:M
%                if f(i,j)==0
%                    f(i,j)=g(i,j-temp);
%                end
%            end
%        end

f=uint8(f);
fpsnr=psnr(f_ori,f);  %������֡��psnr
figure,imshow(f);title(strcat('������㷨2Ч��ͼ  PSNR=',num2str(fpsnr))); 

%���������㷨����������ڵڶ���������㷨������Ŀ��������������ͼ����Ժ���ƫ��ֵ
%����������ͼ����������ͼ�����޲����㷨Ϊ������ͼ��һ�и������غͼ������Ը�����
%�غ�����ͼ�������غͶԱȣ�Ȼ���Դ����ƣ�ֱ���㵽ֵ��С����������ֵ����������
%Ϊƫ��ֵ