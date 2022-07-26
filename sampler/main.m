clear all;
clc;
% Read an image into the workspace, and display it.
I = double(imread('barbara.png'));
imshow(I);
hold on;
[width, heiht]= size(I);
mask = zeros(width, heiht);
% lines
mask(:,1)=1;
maskL = logical(mask);
line1 = I(maskL);
line2 = mask*I;

