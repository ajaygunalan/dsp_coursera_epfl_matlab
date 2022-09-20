% facial reconstruction template
clear; close all; clc

datpath = '../DATA/';
figpath = '../figures/';

load([datpath,'YaleB_32x32.mat']);
% from: http://www.cad.zju.edu.cn/home/dengcai/Data/FaceData.html
% contains 32 by 32 sized images
% each row is image
% This dataset now has 38 individuals and around 64 near frontal images under different illuminations per individual.
%===========================================
% Normalise the image
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
  
meanface = mean(X,2);
X = X-repmat(meanface,1,size(X,2)); % mean centered data

% proper orthogonal decomposition
[Psi,S,V] = svd(X,'econ');
eigenfaces = Psi(:,1:10);

[m,n] = size(XTrain);
imgtrain = XTrain(:,1:10)+repmat(meanface,1,10);
maxval = max(imgtrain(:));


for i=1:10
    imgtrain(:,i) = imgtrain(:,i)/maxval;
end
imgtrain = reshape(imgtrain,32,10*32);
subplot(2,1,1)
imagesc(imgtrain), axis image,  colormap(gray), axis off, 
title("Training data set");


for i=1:10
    eigenfaces(:,i) = eigenfaces(:,i)/max(abs(eigenfaces(:,i)));
end
subplot(2,1,2)
imagesc(reshape(eigenfaces,32,10*32)), axis image,  colormap(gray), axis off,
title("Eigen Faces");
%% To find optimal number of bases
sing = diag(S);
sing = sing(sing>1e-13);
thresh = optimal_SVHT_coef(m/n,0)*median(sing);
r_opt = length(sing(sing>=thresh));
%% OR
for r = [50 100 r_opt 300]
    [~,~,pivot] = qr(Psi(:,1:r)*Psi(:,1:r)','vector');
    pivot = pivot(1:r);
end

%%




