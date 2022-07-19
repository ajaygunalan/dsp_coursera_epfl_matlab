%% Points
% n is the length of the signal vector; In this case, 2500= 50*50.
% m is the length of the measurement vector; In this case, 250.
% SamplingMat is m by n.
% TransformDomain n by n.
%% 
clc;
clear all;
%% 0. Load the image
% All images are reszided to 512*512 as reported in paper. You can change it for you. 
n1=512;    n2=512;                       % size of the image
                                         % n1 and n2, both should be power of two
img=im2double(imread('lena512.bmp'));
img=imresize(img,[n1,n2]);  
imshow(img);
%% 1. Design Sampling Matrix
%% 2. Sample the data to obtain the measurement.
%% 3. Transform into sparse domain.  
%% 4. Reconstruct Image
%% 5. Plot the display