% Load Image
cmrManImg = imread('cameraman.jpg');
% Reduce Resolution
cmrManImg64 = imresize(cmrManImg, [64, 64]);
% Display
%imshow(cmrManImg64);
%size(cmrManImg64)
start = cmrManImg64(:,1,1);
a = cmrManImg64(:,:,1);
b = cmrManImg64(:,:,2);
c = cmrManImg64(:,:,3);

d = [1, 0, 1, 0; 0, 1, 0, 1; 1, 0, 1,0; 0, 1, 0, 1]

x = randi([0,256],256,256);

imshow(d);



