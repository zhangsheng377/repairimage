function Outimage = BI(image,EBx,EBy,step)
% BIIMAGE interplote the EB by bilinear。
% image is the original image.
% EBx and EBy is the coordinate of the EB.
% Outimage表示恢复出的丢失块，其大小为step*step

%   以step＝4为例：
%   假设 * 表示丢失的像素，而 O 表示紧挨丢失块周围一圈的像素
%   O O O O O O
%   O * * * * O
%   O * * * * O
%   O * * * * O
%   O * * * * O
%   O O O O O O

% smallimage 表示的是由O、*组成的区域，即(step+2)*(step+2)的这样一个区域。
smallimage = zeros((step+2),(step+2)); %BI所需要的窗口大小为18×18，如果step=16
rx=EBx-1;ry=EBy-1;
rowhigh=EBx+step;
colhigh=EBy+step;
Outimage=zeros(step,step);
smallimage = image(rx:rowhigh,ry:colhigh);      %截取丢失块周围可用的象素
smallimage = double(smallimage);
%{
for i=2:(step+1)
        for j=2:(step+1)
       small=(double(smallimage(1,j))*((step+2)-i)+double(smallimage((step+2),j))*(i-1)+double(smallimage(i,1))*((step+2)-j)+...
             double(smallimage(i,(step+2)))*(j-1))/(step*2+2);
       smallimage(i,j)=round(small);           %将双精度的数值截取为整数.
    end
end
%}
for j=2:(step/2+1)
    for i=j:(step/2+3)
      small=(double(smallimage((i-1),j))+double(smallimage((i-1),(j-1))+double(smallimage(i,(j-1)))))/3;
      smallimage(i,j)=round(small);           %将双精度的数值截取为整数. 
      small=(double(smallimage((step-i+4),j))+double(smallimage((step-i+3),(j-1))+double(smallimage((step-i+3),(j-1)))))/3;
      smallimage((step-i+3),j)=round(small); 
      small=(double(smallimage((i-1),(step-j+4)))+double(smallimage((i),(step-j+4))+double(smallimage((i-1),(step-j+3)))))/3;
      smallimage(i,(step-j+3))=round(small);           %将双精度的数值截取为整数.
      small=(double(smallimage((step-i+4),(step-j+4)))+double(smallimage((step-i+3),(step-j+4))+double(smallimage((step-i+4),(step-j+3)))))/3;
      smallimage((step-i+3),(step-j+3))=round(small); 
      small=(double(smallimage((j-1),i))+double(smallimage((j-1),(i-1))+double(smallimage(j,(i-1)))))/3;
      smallimage(j,i)=round(small);           %将双精度的数值截取为整数. 
      small=(double(smallimage((step-j+4),i))+double(smallimage((step-j+3),(i-1))+double(smallimage((step-j+3),(i-1)))))/3;
      smallimage((step-j+3),i)=round(small); 
      small=(double(smallimage((j-1),(step-i+4)))+double(smallimage(j,(step-i+4))+double(smallimage((j-1),(step-i+3)))))/3;
      smallimage(j,(step-i+3))=round(small);           %将双精度的数值截取为整数.
      small=(double(smallimage((step-j+4),(step-i+4)))+double(smallimage((step-j+3),(step-i+4))+double(smallimage((step-j+4),(step-i+3)))))/3;
      smallimage((step-j+3),(step-i+3))=round(small); 
    end
end

Outimage=smallimage(2:(step+1),2:(step+1));