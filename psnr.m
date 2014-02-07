function[ps]=psnr(i0,i1)
%i0为真实原始图像，i1为重建图像
% [M,N]=size(g);
%  M  代表图像的高，     即图像矩阵所有的行数
%  N  代表图像的长（宽），即图像矩阵所有的列数

[imgrownumber, imgcolnumber]=size(i0); %求大小
hi=imgrownumber;
vj=imgcolnumber;
b0=double(i0);
b1=double(i1);
sum=0.0;
A=255;
for i=1:imgrownumber
    for j=1:imgcolnumber
        sum=sum+(b0(i,j)-b1(i,j))^2;
    end
end
p=(hi*vj*(A^2))/sum;
ps=10*log10(p);

