clear all;
clc;
% Read an image into the workspace, and display it.
I = imread('barbara1.png');
imshow(I);
hold on;
[width, heiht]= size(I);
% init mask
mask = zeros(width, heiht);
% Creating mask
% for lines
i = [2,5, 120];
mask(:,i)=1;


% for spiral?



maskL = logical(mask);
line1 = I(maskL);
% line2 = mask*double(I);

