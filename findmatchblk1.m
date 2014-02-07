function [h_offsetvec,v_offsetvec] = findmatchblk1(subimage,g,rx,ry)

for j=1:438
   temp=0;
   sum=0;
   tot=0;
    for i=1:328
        sum=sum+temp(i,j);
        sum=double(sum);
    for k=1:328
     tot=tot+subimage(k,j);
     if sum-tot==0
         h_offsetvec=0;
         v_offsetvec=k-j;
         break;
     end
     end
    end
end

end