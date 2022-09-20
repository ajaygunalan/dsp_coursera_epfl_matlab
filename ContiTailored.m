%% Continous Tailored Sensing
clear; close all; clc
datpath = 'C:\Users\agunalan\fastCS\steve\SSPOR_pub\DATA\';
figpath = 'C:\Users\agunalan\fastCS\steve\SSPOR_pub\figures';

%Load the dataBase
load([datpath,'YaleB_32x32.mat']);

%
[nSmp,nFea] = size(fea);
for i = 1:nSmp
     fea(i,:) = fea(i,:) ./ max(1e-12,norm(fea(i,:)));
end

%Scale the features (pixel values) to [0,1]%
maxValue = max(max(fea));
fea = fea/maxValue;

%Data formate for SVD
X = fea';
meanface = mean(X,2);
X = X-repmat(meanface, 1,size(X,2)); % mean centered data

% 64 images of each person
% seed random number generator for predictable sequence
rng(729); 
trainIdx = [];
for i=1:37
   idx = randperm(64,32);
   trainIdx =  [trainIdx, i*idx];
end

%Form the training dataBase
Iord = 1:size(X,2);
testIdx = Iord(~ismember(Iord,trainIdx));
XTrain = X(:,trainIdx);

%Find the eigen basis
[Psi,S,V] = svd(XTrain,'econ');

%Find the optimal number of eigen basis
[m,n] = size(XTrain);
sing = diag(S);
sing = sing(sing>1e-13);
thresh = optimal_SVHT_coef(m/n,0)*median(sing);
r_opt = length(sing(sing>=thresh));
r = [r_opt];
r = [500];

% select training image
x = X(:,testIdx(1))+meanface;
%print_face(x+meanface,[figpath,'FIG_10_true']);
subplot(4,4,1)
imagesc(reshape(x,32,32)), axis image,  colormap(gray), axis off,
title("Image from Training data");
% for r = [50 100 r_opt 300]
%% Demonstrates discrete compressively sampling 
 sensors = randperm(m,r);
 mask = zeros(size(x));
 mask(sensors) = x(sensors);
subplot(4,4,2);
imagesc(reshape(mask,32,32)), axis image,  colormap(gray), axis off,
title("discrete mask");

[~,xcs] = compressedsensingF(x, sensors, m);
subplot(4,4,3)
imagesc(reshape(xcs,32,32)), axis image,  colormap(gray), axis off,
title("recoverd cs image - Discrete");
%% Demonstrates continuous compressively sampling
%Define the trajectory
%Get the i, j cord of spiral sampling
Image = reshape(x,32,32);
dSpirals = 280;
nSpirals = 12;
nPoints = m;  % size of x, y is 1 by m
bPlot = false;
[xTraj, yTraj] = spiralSamp(Image, nSpirals, nPoints, dSpirals, bPlot);
%Plot the image and the trajectory
axis off;
subplot(4,4,4);
axis image,  colormap(gray), axis off, 
title('Image with Spiral Sampling');
imagesc(Image);
hold on;
plot(xTraj,yTraj);
%Measure the pixel values along the given trajectory
Measure = zeros(m,1);
SamplerV = [];
for i = 1:m
    Measure(i) = Image(xTraj(i),yTraj(i));
    linearIndex = sub2ind(size(Image), xTraj(i),yTraj(i));
    SamplerV = [SamplerV; linearIndex];
end

%Pass the vector image x, SamplerMatV which contains the pixel location to
%be sampled and m is the length of x.
[~,xcs] = compressedsensingF(x, SamplerV, m);
subplot(4,4,5)
imagesc(reshape(xcs,32,32)), axis image,  colormap(gray), axis off,
title("recoverd cs image - conti");
%% ----------------------------------------------------------------------------------
%% Demonstrates compressively sampling and D-AMP recovery of an image.
% i.e y = Cx;
% where y is a m*1 measument matrix
% C is a m*N sampling matrix
% X is a N by 1 vectorized Image. 
% N = n1*n2 where n1, n2 are size of the image
%% Parameters
denoiser2='fast-BM3D'; %Available options are NLM, Gauss, Bilateral, BLS-GSM, BM3D, fast-BM3D, and BM3D-SAPCA 
iters=30;
% Image = reshape(x+meanface, 32, 32);
Image = rgb2gray(imread('barbara128.png'));
[height width] = size(Image);
CompresRatio = 0.3; 
N = height*width;
m = round(CompresRatio*N);
%% CS using spiral traj
% Get the i, j cord of spiral sampling
dSpirals = 280;
nSpirals = 12;
nPoints = m;  % size of x, y is 1 by m
bPlot = false;
[xTraj, yTraj] = spiralSamp(Image, nSpirals, nPoints, dSpirals, bPlot);
% Plot the image and the trajectory
subplot(4,4,2);
axis image,  colormap(gray), axis off, 
title('Original Image with Spiral Sampling');
imagesc(Image);
hold on;
plot(xTraj,yTraj);
axis off;
% Measure the pixel values along the given trajectory
Measure = zeros(m,1);
for i = 1:m
    Measure(i) = Image(xTraj(i),yTraj(i));
end
% masImage=ind2sub(size(Image),xTraj,yTraj);
% Measure=Image(mask);
% Find the Sampler (C) matrix in y = Cx where:
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
%% CS using random matrix
%Generate Gaussian Measurement Matrix
ImageV = double(im2gray(Image));
ImageV = ImageV(:);
SamplerMat=randn(m,N);
for j = 1:N
    SamplerMat(:,j) = SamplerMat(:,j) ./ sqrt(sum(abs(SamplerMat(:,j)).^2));
end
%Compressively sample the image
Measure=SamplerMat*ImageV;
%% Recover Signal using D-AMP algorithms
y=Measure;
Sampler=opMatrix(SamplerMat);
x_hat2 = DAMP(y,iters,height,width,denoiser2,Sampler);
%% Plot Recovered Signals
subplot(4,4,3);
axis image,  colormap(gray), axis off, 
title([denoiser2, '-AMP']);
imshow(uint8(x_hat2));
%imagesc(x_hat2);
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Approximation with r eigenfaces
    xproj = Psi(:,1:r)*Psi(:,1:r)'*x;
    %print_face(xproj+meanface,[figpath,'FIG_10_proj_',num2str(r)]);
    subplot(2,3,2)
    imagesc(reshape(xproj+meanface,32,32)), axis image,  colormap(gray), axis off,
    title("Approximation with r eigenfaces");
    
    %% Random reconstruction with r sensors
    sensors = randperm(m,r);
    
    mask = zeros(size(x));
    mask(sensors)  = x(sensors)+meanface(sensors);
    %print_face(mask,[figpath,'FIG_10_rand_mask_',num2str(r)]);
    subplot(2,3,3)
    imagesc(reshape(mask,32,32)), axis image,  colormap(gray), axis off,
    title("Random mask for reconstruction")
    
    xls = Psi(:,1:r)*(Psi(sensors,1:r)\x(sensors));
    %print_face(xls+meanface,[figpath,'FIG_10_rand_',num2str(r)]);
    subplot(2,3,4)
    imagesc(reshape(xls+meanface,32,32)), axis image,  colormap(gray), axis off,
    title("Random reconstruction with r sensors")
    
    %% QDEIM with r QR sensors
    [~,~,pivot] = qr(Psi(:,1:r)','vector');
    sensors = pivot(1:r);
    
    mask = zeros(size(x));
    %mask(sensors)  = x(sensors)+meanface(sensors);
    % Measure the data at those pivot locations
    mask(sensors)  = x(sensors);
    %print_face(mask,[figpath,'FIG_10_qr_mask_',num2str(r)]);
    subplot(2,3,5)
    imagesc(reshape(mask,32,32)), axis image, axis off,
    title("QR sensors Mask")
    
    
    xls = Psi(:,1:r)*(Psi(sensors,1:r)\x(sensors));
    %print_face(xls+meanface,[figpath,'FIG_10_qr_',num2str(r)]);
    subplot(2,3,6)
    imagesc(reshape(xls+meanface,32,32)), axis image,  colormap(gray), axis off,
    imagesc(reshape(xls,32,32)), axis image,  colormap(gray), axis off,
    title("Tailored Sensing")
    
% end