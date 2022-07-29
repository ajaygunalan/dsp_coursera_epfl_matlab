clear all;
clc;
%% Goal is to acuqire a pixel values along a spiral trajectory of Image (X).
% i.e y = Cx;
% where y is a m*1 measument matrix
% C is a m*N sampling matrix
% X is a N by 1 vectorized Image. 
% N = n1*n2 where n1, n2 are size of the image
% Paramters for Spiral
dSpirals = 30;
nSpirals = 20;
CompresRatio = 0.4; 
InputImage = imread('barbara1.png');
[height width] = size(InputImage);
N = height*width;
m = round(CompresRatio*N);
nPoints = m;
theta = linspace(0,360*nSpirals, nPoints);
% Define Spiral
x = round(((width/2)+1) +(theta/dSpirals).*cosd(theta));
y = round(((height/2)+1) +(theta/dSpirals).*sind(theta));
plot(x,y);
axis([0 width 0 height]);
grid on;
%% Measure the pixel values along the spiral trajectory
Measure = zeros(m,1);
for i = 1:m
    Measure(m) = InputImage(x(i),y(i));
end
%% How to find Sampler (C) matrix in y = CX where:
% y = Measure
% X = InputImageV  
% InputImageV = InputImage(:);
% Measure = Sampler*InputImageV;
sz=size(InputImage);
J=sub2ind(sz,x,y);
I=(1:numel(x))'; %I size is m by 1. 
SamplerMat=sparse(I,J,1); 
%% Check the samplerMat by:
InputImageV = InputImage(:);
MeasureCheck = SamplerMat*InputImageV; %y=Cx
if(MeasureCheck == Measure)
    fprintf("We have successfully sampled pixel values along spiral trajectory on the give image");
else
    fprintf('job not yet done \n');
end