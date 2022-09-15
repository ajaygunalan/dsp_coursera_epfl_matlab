%% Demonstrates compressively sampling and D-AMP recovery of an image.
% i.e y = Cx;
% where y is a m*1 measument matrix
% C is a m*N sampling matrix
% X is a N by 1 vectorized Image. 
% N = n1*n2 where n1, n2 are size of the image
%% Parameters
clear all;
clc;
denoiser2='fast-BM3D'; %Available options are NLM, Gauss, Bilateral, BLS-GSM, BM3D, fast-BM3D, and BM3D-SAPCA 
iters=30;
Image = rgb2gray(imread('barbara128.png'));
[height width] = size(Image);
CompresRatio = 0.4; 
N = height*width;
m = round(CompresRatio*N);
%% Get the i, j cord of spiral sampling
dSpirals = 200;
nSpirals = 35;
nPoints = m  % size of x, y is 1 by m
bPlot = true;
[xTraj, yTraj] = spiralSamp(Image, nSpirals, nPoints, dSpirals, bPlot);
%% Get the i, j cord of lissajous sampling
% A = 60;
% B = 60;
% delta = 0.33*pi;
% t = 10;
% nPoints = m; % size of x, y is 1 by m
% bPlot = true;
% [xTraj, yTraj] = lissajousSamp(Image, A, B, delta, t, nPoints, bPlot);
%% Get the i, j cord of rosette sampling
% t = 1;
% a = 60;
% k = 10;
% nPoints = m; % size of x, y is 1 by m
% bPlot = true;
% [xTraj, yTraj] = rosetteSamp(Image, t, a, k, nPoints,  bPlot);
%% Measure the pixel values along the given trajectory
Measure = zeros(m,1);
for i = 1:m
    Measure(i) = Image(xTraj(i),yTraj(i));
end
% masImage=ind2sub(size(Image),xTraj,yTraj);
% Measure=Image(mask);
%% Find the Sampler (C) matrix in y = Cx where:
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