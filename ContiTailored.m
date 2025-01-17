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
r = 600;

% select training image
x = X(:,testIdx(1));
%print_face(x+meanface,[figpath,'FIG_10_true']);
% subplot(4,4,1);
% imagesc(reshape(x,32,32)), axis image,  colormap(gray), axis off,
% title("1. Image from Training data");
% for r = [50 100 r_opt 300]
%% Discrete Compressive Sampling 
 sensors = randperm(m,r);
 mask = zeros(size(x));
 mask(sensors) = x(sensors);
subplot(5,2,1);
imagesc(reshape(mask,32,32)), axis image,  colormap(gray), axis off,
title("2.1 Discrete Mask");

[~,xcs] = compressedsensingF(x, sensors, m);
subplot(5,2,2);
imagesc(reshape(xcs,32,32)), axis image,  colormap(gray), axis off,
title("2.2 Reconstructed Image: Discrete Compressive Sensing");
%% Continuous Compressive Sampling
%Define the trajectory
%Get the i, j cord of spiral sampling
Image = reshape(x,32,32);
dSpirals = 380;
nSpirals = 18;
nPoints = 600;  % size of x, y is 1 by m
bPlot = false;
[xTraj, yTraj] = spiralSamp(Image, nSpirals, nPoints, dSpirals, bPlot);
Traj = [xTraj; yTraj]; %two nPoints are generated 
Traj = unique(Traj','stable','rows'); %two nPoints are generated 
Traj = Traj(1:nPoints,:); %chops excess points
xTraj = Traj(:,1);
yTraj = Traj(:,2);

%Plot the image and the trajectory
subplot(5,2,3);
% subplot(1,2,1);
axis image,  colormap(gray), axis off, 
title('3.1 Continuous Spiral Mask');
imagesc(Image);
axis off;
hold on;
% scatter(xTraj,yTraj,'filled','sizedata',szscale*25)
plot(xTraj,yTraj);

SamplerV = [];
for i = 1:nPoints
    linearIndex = sub2ind(size(Image), xTraj(i),yTraj(i));
    SamplerV = [SamplerV; linearIndex];
end

%Pass the vector image x, SamplerMatV which contains the pixel location to
%be sampled and m is the length of x.
[~,xcs] = compressedsensingF(x, SamplerV, m);
subplot(5,2,4);
% subplot(1,2,2);
imagesc(reshape(xcs,32,32)), axis image,  colormap(gray), axis off,
title("3.2 Reconstructed Image: Continuous Compressive Sensing");
%% Discrete Tailored Sesning 
% Approximation with r eigenfaces
% xproj = Psi(:,1:r)*Psi(:,1:r)'*x;
% subplot(4,4,6);
% imagesc(reshape(xproj+meanface,32,32)), axis image,  colormap(gray), axis off,
% title("Approximation with r eigenfaces");
 
% Random reconstruction with r sensors
sensors = randperm(m,r);
mask = zeros(size(x));
mask(sensors)  = x(sensors);
subplot(5,2,5);
imagesc(reshape(mask,32,32)), axis image,  colormap(gray), axis off,
title("4.1 Discrete Random Mask");


% xls = Psi(:,1:r)*(Psi(sensors,1:r)\x(sensors));
y = x(sensors); %Measured data
theta=Psi(sensors,1:r);
xls = Psi(:,1:r)*(theta\y);

subplot(5,2,6);
imagesc(reshape(xls+meanface,32,32)), axis image,  colormap(gray), axis off,
title("4.2 Reconstructed Image: Tailored Sensing");

% QDEIM with r QR sensors
[~,~,pivot] = qr(Psi(:,1:r)','vector');
sensors = pivot(1:r);
mask = zeros(size(x));
%mask(sensors)  = x(sensors)+meanface(sensors);
% Measure the data at those pivot locations
mask(sensors)  = x(sensors);
subplot(5,2,7);
imagesc(reshape(mask,32,32)), axis image, axis off,
title("5.1 QR Optimal Mask")
    
xls = Psi(:,1:r)*(Psi(sensors,1:r)\x(sensors));
subplot(5,2,8);
imagesc(reshape(xls+meanface,32,32)), axis image,  colormap(gray), axis off,
% imagesc(reshape(xls,32,32)), axis image,  colormap(gray), axis off,
title("5.2 Reconstructed Image: Tailored Sensing (Optimal Mask)")
%% Continuous Compressive Sampling
QRPoints = sensors;
SamplerV = transpose(SamplerV);
QRPivotCont = ones(size(SamplerV));
for i=1:r
    for j=1:r
        if(SamplerV(i) == QRPoints(j))
            QRPivotCont(i) = SamplerV(i);
%             disp("its a match");
        end
    end
end

%remove all ones from the combined masj
QRPivotCont = QRPivotCont(find(QRPivotCont~=1));
% QRPivotCont = sensors;
mask = zeros(size(x));
mask(QRPivotCont)  = x(QRPivotCont);
subplot(5,2,9);
imagesc(reshape(mask,32,32)), axis image, axis off,
title("6.1 QR Optimal Mask Continuous")
    
xls = Psi(:,1:r)*(Psi(QRPivotCont,1:r)\x(QRPivotCont));
subplot(5,2,10);
imagesc(reshape(xls+meanface,32,32)), axis image,  colormap(gray), axis off,
% imagesc(reshape(xls,32,32)), axis image,  colormap(gray), axis off,
title("6.2 Reconstructed Image: Tailored Sensing (Continuous)")