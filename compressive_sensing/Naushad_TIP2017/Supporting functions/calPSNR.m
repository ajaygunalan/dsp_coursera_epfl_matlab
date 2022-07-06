%% This function calculates the psnr of the image "recImg" with reference to
% the original image "img". boun is the boundary left at the corners for the 
% psnr calculation. "boun" can be taken as 0 in general case.
% PSNR is calculated as per the Gonzalez book.

function psnr=calPSNR(img,recImg,boun)

img=img(boun+1:end-boun,boun+1:end-boun);
recImg=recImg(boun+1:end-boun,boun+1:end-boun);

mse=norm((img(:)-recImg(:)))^2/length(img(:));
% mse=sum(abs((img(:)-recImg(:)).^2))/length(img(:));
maxval=max(abs(img(:)));
psnr=10*log10((maxval^2)/mse);
