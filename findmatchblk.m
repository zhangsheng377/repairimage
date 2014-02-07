function [h_offsetvec,v_offsetvec] = findmatchblk(subimage,g,rx,ry)

minsad=999999999;
tempsad=0;

[g_height,g_width]=size(g);  %得出宽度高度

searchwindowleft=-150;       %搜索区域大小；
searchwindowright=150;
searchwindowabove=-50;
searchwindowbelow=50;

for m=searchwindowleft:searchwindowright
    if(ry+m+16-1>g_width) %防止搜索时溢出图像边界；
        break;
    end
    if(ry+m>0)
        tempsad=0;
        temp=g(rx:rx+16-1,ry+m:ry+m+16-1);    
        for i=1:16
            for j=1:16
                tempsad=tempsad+abs((subimage(i,j)-temp(i,j)));%计算出两幅图上选定方块的像素差值；
            end
        end
        if tempsad<minsad   
            matchedimage=temp;  
            v_offsetvec=m;
            h_offsetvec=0;%当像素差值最小时，将此时偏移值保存；
            minsad=tempsad;
        end
    end
end
