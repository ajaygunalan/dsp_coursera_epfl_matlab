%%-----------------------------------------------------------------------%%
% %% Copyright Naushad Ansari and Anubha Gupta, 2017.
% %% Please feel free to use this open-source code for research purposes only. 
% %%
% %% Please cite the following paper while using the results:
% %%
% %% N. Ansari, and A. Gupta, "Image Reconstruction using Matched Wavelet
% %% Estimated from Data Sensed Compressively using Partial Canonical 
% %% Identity Matrix," Accepted, in IEEE Transactions on Image Processing, 2017. 
%%-----------------------------------------------------------------------%%
% This code is to compare the CS-based reconstruction performance among 
% three different sensing matrices, that is Bernoulli, Gaussian and Prtial
% Canonical Identity (PCI) matrix as reported in paper.
% Sampling ratios, 90% to 10% are considered.

% CS based reconstruction is performed only with existing wavelet, db4 
% as the sparsifying transform.
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
clc;
clear all;
close all;

%% Load image
% All images are reszided to 512*512 as reported in paper. You can change it for you. 
n1=512;    n2=512;                       % size of the image
                                         % n1 and n2, both should be power of two
img=im2double(imread('lena512.bmp'));
img=imresize(img,[n1,n2]);                    

%% Some Common parameters
BlkLen = 64;                               % length of block on which CS is performed 
NoOfBlk1 = n1/BlkLen;  NoOfBlk2=n2/BlkLen; % number of blocks along columns and rows
% SampRat=90:-10:10;                       % Sampling ratios considered 
SampRat = 10;
MaxIter = 1;                               % Number of iterations to perform experiments

%% Wavelet operator initialization
% for Gaussian and Bernboulli sensing matrix (they are performed
% blockwise, hence, size is BlkLen*BlkLen)
% Wt = opWavelet(BlkLen,BlkLen,'Daubechies',8,3,'min');

%opWavelet(N,FAMILY,FILTER,LEVELS,REDUNDANT,TYPE);
% N creates a Wavelet transform for 1-dimensional signals of size N. 
% FAMILY 'Daubechies' and 'Haar'
% FILTER (default 8) specifies the filter length, which must be even.
% LEVELS (default 5) gives the number of levels in the transformation
% The Boolean field REDUNDANT (default false) indicates whether the wavelet is redundant. 
% TYPE (default 'min') indictates what type of solution is desired; 'min' for minimum phase, 'max' for maximum phase, and 'mid' for mid-phase solutions.
Wt = opWavelet2(BlkLen,BlkLen,'Daubechies',8,3,false,'min');
% Wt = opWavelet(BlkLen,'Daubechies'); 

                                         % transpose of the wavelet operator 

% for Partial Canonical Identity (PCI) sesning matrix
% WPt = opWavelet(n1,n2,'Daubechies',8,3,'min'); % applied on full image at once
WPt = opWavelet2(n1,n2,'Daubechies',8,3,false,'min');  % applied on full image at once

                                        % transpose of the wavelet operator
% (operaor 'psi' in paper is equivalent to Wt or WPt)                                        

%% PSNR and time for the reconstruction
for iter = 1:MaxIter
    display(sprintf('Code running for %d iteration...',iter));
    [psnrB(iter,:),timB(iter,:)] = Fun_SensingMatrices_comparison(img,Wt,WPt,SampRat,BlkLen,n1,n2);
    % Average psnr and time over different iterations with Bernoulli,
    % Gaussian and PCI sensing matrices.
    avgPsnrB = mean(psnrB);
%     avgPsnrG = mean(psnrG);
%     avgPsnrP = mean(psnrP);
    
    avgTimB = mean(timB);
%     avgTimG = mean(timG);
%     avgTimP = mean(timP);
end

%% Plot results for psnr and time comparisons
plot(SampRat,psnrB,'k','LineWidth',1,'marker','.');
hold on;
% plot(SampRat,psnrG,'k','LineWidth',1,'marker','s');
% hold on;
% plot(SampRat,psnrP,'k','LineWidth',1,'marker','p');
set(gca,'XDir','reverse')
xlabel('Sampling Ratio (in %)','Fontsize',14);
ylabel('PSNR (in dB)','Fontsize',14);
legend('Bernoulli Measuerement operator')

plot(SampRat,timB,'k','LineWidth',1,'marker','.');
hold on;
% plot(SampRat,timG,'k','LineWidth',1,'marker','s');
% hold on;
% plot(SampRat,timP,'k','LineWidth',1,'marker','p');
set(gca,'XDir','reverse')
xlabel('Sampling Ratio (in %)','Fontsize',14);
ylabel('Time (in secs)','Fontsize',14);
legend('Bernoulli Measuerement operator')