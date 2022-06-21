function ImgR=ImgManifest_LeftDown(Img, image_title, start_x,start_y,dx,dy)

% Img(:,:,2)=Img(:,:,1);
% Img(:,:,3)=Img(:,:,1);

%imshow(uint8(Img(start_x-dx:start_x+dx,start_y-dy:start_y+dy,1:3)));
[m n k]=size(Img);
ImgR=Img(:,:,1:3);
ImgR(start_x+dx,start_y-dy:start_y+dy,2)=255;
ImgR(start_x-dx,start_y-dy:start_y+dy,2)=255;
ImgR(start_x-dx:start_x+dy,start_y+dy,2)=255;
ImgR(start_x-dx:start_x+dy,start_y-dy,2)=255;

ImgR(floor(m/2)+1:m,1:n-floor(n/2),1:3)=imresize(Img(start_x-dx:start_x+dx,start_y-dy:start_y+dy,1:3),[m-floor(m/2) n-floor(n/2)],'nearest');

ImgR(floor(m/2),1:floor(n/2),2)                    =255;
ImgR(floor(m/2):m,floor(n/2),2)                    =255;
ImgR(floor(m/2):m,1,2)                                    =255;
ImgR(m,1:n-floor(n/2),2)                                 =255;

figure, imshow(uint8(ImgR(:,:,1:3)));
title(image_title);
