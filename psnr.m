function[ps]=psnr(i0,i1)
%i0Ϊ��ʵԭʼͼ��i1Ϊ�ؽ�ͼ��
% [M,N]=size(g);
%  M  ����ͼ��ĸߣ�     ��ͼ��������е�����
%  N  ����ͼ��ĳ���������ͼ��������е�����

[imgrownumber, imgcolnumber]=size(i0); %���С
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

