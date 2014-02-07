function [h_offsetvec,v_offsetvec] = findmatchblk(subimage,g,rx,ry)

minsad=999999999;
tempsad=0;

[g_height,g_width]=size(g);  %�ó���ȸ߶�

searchwindowleft=-150;       %���������С��
searchwindowright=150;
searchwindowabove=-50;
searchwindowbelow=50;

for m=searchwindowleft:searchwindowright
    if(ry+m+16-1>g_width) %��ֹ����ʱ���ͼ��߽磻
        break;
    end
    if(ry+m>0)
        tempsad=0;
        temp=g(rx:rx+16-1,ry+m:ry+m+16-1);    
        for i=1:16
            for j=1:16
                tempsad=tempsad+abs((subimage(i,j)-temp(i,j)));%���������ͼ��ѡ����������ز�ֵ��
            end
        end
        if tempsad<minsad   
            matchedimage=temp;  
            v_offsetvec=m;
            h_offsetvec=0;%�����ز�ֵ��Сʱ������ʱƫ��ֵ���棻
            minsad=tempsad;
        end
    end
end
