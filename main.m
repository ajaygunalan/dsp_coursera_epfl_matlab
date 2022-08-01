%% Demonstrates compressively sampling and D-AMP recovery of an image.
clear all;
clc;
%Parameters
denoiser2='fast-BM3D'; %Available options are NLM, Gauss, Bilateral, BLS-GSM, BM3D, fast-BM3D, and BM3D-SAPCA 
iters=30;
%% Goal is to acuqire a pixel values along a spiral trajectory of Image (X).
% i.e y = Cx;
% where y is a m*1 measument matrix
% C is a m*N sampling matrix
% X is a N by 1 vectorized Image. 
% N = n1*n2 where n1, n2 are size of the image
% Paramters for Spiral
dSpirals = 200;
nSpirals = 35;
CompresRatio = 0.4; 
Image = rgb2gray(imread('barbara128.png'));
imshow(Image);
hold on;
[height width] = size(Image);
N = height*width;
m = round(CompresRatio*N);
nPoints = m;
theta = linspace(0,360*nSpirals, nPoints);
% Define Spiral
xTraj = round(((width/2)+1) +(theta/dSpirals).*cosd(theta));
yTraj = round(((height/2)+1) +(theta/dSpirals).*sind(theta));
plot(xTraj,yTraj);
axis([0 width 0 height]);
grid on;
%% Measure the pixel values along the spiral trajectory
Measure = zeros(m,1);
for i = 1:m
    Measure(i) = Image(xTraj(i),yTraj(i));
end
% masImage=ind2sub(size(Image),xTraj,yTraj);
% Measure=Image(mask);
%% How to find Sampler (C) matrix in y = CX where:
% y = Measure
% X = ImageV  
ImageV = Image(:);
% Measure = Sampler*ImageV;
sz=size(Image);
J=sub2ind(sz,xTraj,yTraj);
I=(1:numel(xTraj))'; %I size is m by 1. 
SamplerMat=sparse(I,J,1); 
SamplerMat=sparse(I,J,1,numel(xTraj), prod(sz));
SamplerMat = full(SamplerMat);
%% Recover Signal using D-AMP algorithms
y=Measure;
Sampler=opMatrix(SamplerMat);
x_hat2 = DAMP(y,iters,height,width,denoiser2,Sampler);
%% Plot Recovered Signals
subplot(1,2,1);
imshow(uint8(Image));title('Original Image with Spiral Sampling');
hold on;
plot(xTraj,yTraj);
axis([0 width 0 height]);
grid on;
% hold on;
subplot(1,2,2);
imshow(uint8(x_hat2));title([denoiser2, '-AMP']);
