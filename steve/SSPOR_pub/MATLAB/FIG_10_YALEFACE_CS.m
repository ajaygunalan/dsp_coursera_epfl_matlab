% Code to reproduce Figure 10 compressed sensing reconstruction of Yale B
% faces
clear; close all; clc

datpath = 'C:\Users\agunalan\fastCS\steve\SSPOR_pub\DATA\';
figpath = 'C:\Users\agunalan\fastCS\steve\SSPOR_pub\figures';

load([datpath,'YaleB_32x32.mat']);

%===========================================
[nSmp,nFea] = size(fea);
for i = 1:nSmp
     fea(i,:) = fea(i,:) ./ max(1e-12,norm(fea(i,:)));
end
%===========================================
%Scale the features (pixel values) to [0,1]%
%===========================================
maxValue = max(max(fea));
fea = fea/maxValue;
%===========================================

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

Iord = 1:size(X,2);
testIdx = Iord(~ismember(Iord,trainIdx));
XTrain = X(:,trainIdx);

[Psi,S,V] = svd(XTrain,'econ');
[m,n] = size(XTrain);
sing = diag(S);
sing = sing(sing>1e-13);
thresh = optimal_SVHT_coef(m/n,0)*median(sing);

r = length(sing(sing>=thresh));

% select training image
x = X(:,testIdx(1))+meanface;
subplot(1,4,1)
imagesc(reshape(x,32,32)), axis image,  colormap(gray), axis off,
title("original image + avgface");

% select training image

x = X(:,testIdx(1));
subplot(1,4,2)
imagesc(reshape(x,32,32)), axis image,  colormap(gray), axis off,
title("original image");


% R = [100 r 300 600];
R = [600];

%for i=1:4
    sensors = randperm(m,R);
    mask = zeros(size(x));
    mask(sensors) = x(sensors);
    subplot(1,4,3)
    imagesc(reshape(mask,32,32)), axis image,  colormap(gray), axis off,
    title("mask");

    
    [~,xcs] = compressedsensingF( x, sensors, m);
    subplot(1,4,4)
    imagesc(reshape(xcs,32,32)), axis image,  colormap(gray), axis off,
    title("recoverd cs image");
  %end

