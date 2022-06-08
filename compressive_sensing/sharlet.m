clear;clc,
%%settings
scales = 4;
useGPU=0;
%%load data
X = imread('barbara.jpg');
data = double(X);
%% create shearlets
shearletSystem = SLgetShearletSystem2D(useGPU,size(data,1),size(data,2),scales);
%% decomposition
coeffs = SLsheardec2D(data,shearletSystem);
%% 
reconstruction = SLshearrec2D(coeffs, shearletSystem);
%% Display
for i = 1:49
    imshow(coeffs(:,:,i));
end