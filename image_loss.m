function  f = image_loss(image,step)
f=image;
[h,w]=size(f);
for i=3*step+1:3*step:h-2*step
    for j=3*step+1:3*step:w-2*step
        f(i:i+step-1,j:j+step-1)=zeros(step,step);
    end
end

figure,imshow(f);  %��ʾ��ʧ����֮���ͼ��
title('��ʧ����֮���ͼ��');