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
% This code is to compare CS-based reconstruction performance using standard 
% wavelets with that of using matched wavelet.
% Particularly, following wavelets are compared:
% 1). Orthogonal db2 
% 2). Orthogonal db4 
% 3). Bi-orthogonal bior2.2 (5/3)
% 4). Matched Wavelet  
% PCI matrix is used as the sensing matrix.
% Sampling ratios, 90% to 10% are considered.
% Proposed wavelet decomposition, i.e., L-Pyramid wavelet decomposition
% method is used in this code.
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
clc;
clear all;
close all;

%% Load Images
n1=64;    n2=64;                       % size of the image
                                         % n1 and n2, both should be power of two
ImgNo=[1,3];                                 % Image numbers from the list given 
                                         % in function 'Read_allImages'
AllImg=Read_allImages(n1,n2,ImgNo);      % read images
[~,~,noOfImg]=size(AllImg);

%% Paremeters Initializations
SampRat=90:-10:10;                       % Sampling ratios considered
% sampRat=50;
maxIter=1;                               % No of iterations 
lenSampRat=length(SampRat);
PSNR1=zeros(maxIter,1);                PSNR2=zeros(maxIter,1);
PSNR3=zeros(maxIter,1);                PSNR4=zeros(maxIter,1);
    
avgPSNR1=zeros(lenSampRat,noOfImg);    avgPSNR2=zeros(lenSampRat,noOfImg);
avgPSNR3=zeros(lenSampRat,noOfImg);    avgPSNR4=zeros(lenSampRat,noOfImg);       
  
%% Wavelet operator initialization
% For db2
[h,h1,f,f1]=wfilters('db2');
W1t=opMyWaveletMyStrategy_v2(h,h1,h,h1,n1,n2);

% For db4
[h,h1,f,f1]=wfilters('db4');
W2t=opMyWaveletMyStrategy_v2(h,h1,h,h1,n1,n2);

% For bior 5/3
[h,h1,f,f1]=wfilters('bior2.2');
W3t=opMyWaveletMyStrategy_v2(h,h1,h,h1,n1,n2);

%% Main processing
for k=1:noOfImg                       % iterate for all images
    img=AllImg(:,:,k);
    
    for i=1:length(SampRat)           % iterate for all sampling ratios
        for iter=1:maxIter
            disp(sprintf('Iteration %d of sampling ratio %d is is process now',...
                iter,SampRat(i)));
            pause(2);
            
            %% compressive measurements of the image
            idx=randperm(n1*n2);        % index of the samples to be picked as per PCI sensing matrix
            idx=idx(1:ceil(SampRat(i)*n1*n2/100));
            R=opRestriction(n1*n2,idx); % operator for PCI sensing matrix
            
            y=R(img(:),1);            % sub-sampled image
            
            %% Reconstruct full image using Wavelet 1
            A1=opFoG(R,W1t);          % operator A=R*Wt
            [recImg1,~] = RecFullImageFromCompImage(A1,y,W1t,n1,n2);
            
            %% Reconstruct full image using Wavelet 2
            A2=opFoG(R,W2t);          % operator A=R*Wt
            [recImg2,~] = RecFullImageFromCompImage(A2,y,W2t,n1,n2);
            
            %% Reconstruct full image using Wavelet 3
            A3=opFoG(R,W3t);          % operator A=R*Wt
            [recImg3,~] = RecFullImageFromCompImage(A3,y,W3t,n1,n2);
            
            %% Learn matched wavelet operator
            clear hc h1c hr h1r;
            [hc,h1c,hr,h1r]=Fun_DesignImageMatched_1by2_1by2Filters_ForPaper2(recImg3,h,h1);
            W4t=opMyWaveletMyStrategy_v2(hc,h1c,hr,h1r,n1,n2);
            
            %% Reconstruct full image using Wavelet 4
            A4=opFoG(R,W4t);          % operator A=R*Wt
            [recImg4,~] = RecFullImageFromCompImage(A4,y,W4t,n1,n2);
            
            %% Compare the CS-performance in terms of PSNR
            PSNR1(iter)=calPSNR(img,recImg1,0);     PSNR2(iter)=calPSNR(img,recImg2,0);    
            PSNR3(iter)=calPSNR(img,recImg3,0);     PSNR4(iter)=calPSNR(img,recImg4,0);     
            
        end
        avgPSNR1(i,k)=mean(PSNR1);     avgPSNR2(i,k)=mean(PSNR2);
        avgPSNR3(i,k)=mean(PSNR3);     avgPSNR4(i,k)=mean(PSNR4);    
    end
end

%% This ends the code