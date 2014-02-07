function DSP_result = DirectSpatialReplacement(lost_image,reference_image,blocksize)

uint8_lost_image=uint8(lost_image);
[M,N]=size(uint8_lost_image);

for i=1:blocksize:(M-blocksize+1)
    for j=1:blocksize:(N-blocksize+1)     
         if lost_image(i:i+blocksize-1,j:j+blocksize-1)==0
         lost_image(i:i+blocksize-1,j:j+blocksize-1)=reference_image(i:i+blocksize-1,j:j+blocksize-1);
     end
    end
end

DSP_result=lost_image;
