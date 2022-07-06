% function to read all the images position of which is indicated by variable 
% 'ImgNo'
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
% One can choose images from the following list:
% 1) beads,   2) boat,    3) lena,  4) balloon,  5) barbara,
% 6) peppers, 7) mandril, 8) hiuse, 9) building, 10) cameraman.
% image number can be choosen from the above list and is stored in variable 
% 'ImgNo'.
% %% output: AllImg1-> set of the images in variable 'ImgNo'. 
% %% input:  n1,n2-> size of the image
%            ImgNo-> index of all the images to be selected.
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
function AllImg1=Read_allImages(n1,n2,ImgNo)

AllImg=zeros(n1,n2);
img1=im2double(imread('beads_RGB.bmp'));     img1=imresize(img1(:,:,1),[n1,n2]);    AllImg(:,:,1)=img1;
img2=im2double(imread('boat.png'));          img2=imresize(img2(:,:,1),[n1,n2]);    AllImg(:,:,2)=img2; 
img3=im2double(imread('lena512.bmp'));       img3=imresize(img3(:,:,1),[n1,n2]);    AllImg(:,:,3)=img3;
img4=im2double(imread('balloons_RGB.bmp'));  img4=imresize(img4(:,:,1),[n1,n2]);    AllImg(:,:,4)=img4; 
img5=im2double(imread('barbara.png'));       img5=imresize(img5(:,:,1),[n1,n2]);    AllImg(:,:,5)=img5;
img6=im2double(imread('peppers.png'));       img6=imresize(img6(:,:,1),[n1,n2]);    AllImg(:,:,6)=img6;
img7=im2double(imread('mandril_color.tif')); img7=imresize(img7(:,:,1),[n1,n2]);    AllImg(:,:,7)=img7;
img8=im2double(imread('house.tif'));         img8=imresize(img8(:,:,1),[n1,n2]);    AllImg(:,:,8)=img8;
img9=im2double(imread('Building.png'));      img9=imresize(img9(:,:,1),[n1,n2]);    AllImg(:,:,9)=img9;
img10=im2double(imread('cameraman.tif'));    img10=imresize(img10(:,:,1),[n1,n2]);  AllImg(:,:,10)=img10;

AllImg1(:,:,1:length(ImgNo))=AllImg(:,:,ImgNo);