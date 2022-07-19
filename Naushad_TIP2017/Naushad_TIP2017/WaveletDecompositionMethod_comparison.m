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
% This code is to compare CS-based reconstruction performance using proposed
% wavelet decomposition (L-Pyramid wavelet decomposition) method with that
% of using existing wavelet decomposition (R-Pyramid wavelet decomposition) method.
% PCI matrix is used as the sensing matrix.
% Sampling ratios, 90% to 10% are considered.

% CS based reconstruction is performed only with existing wavelet, db4 
% as the sparsifying transform.
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
SampRat=90:-10:10;                   % Sampling ratios considered
% sampRat=30; 
maxIter=1;                             % No of iterations 
lenSampRat=length(SampRat); 
PSNR1=zeros(maxIter,1);                PSNR2=zeros(maxIter,1);
avgPSNR1=zeros(lenSampRat,noOfImg);    avgPSNR2=zeros(lenSampRat,noOfImg);

%% Wavelet operator initialization
% wavelet transpose operator for R-Pyramid wavelet decomposition
W1t=opWavelet(n1,n2,'Daubechies',8,3,'min');

% wavelet transpose operator for L-Pyramid wavelet decomposition
[h,h1,f,f1]=wfilters('db4');
W2t=opMyWaveletMyStrategy_v2(h,h1,h,h1,n1,n2);

%% Main processing
for k=1:noOfImg                      % iterate for all images
    img=AllImg(:,:,k);
    
    for i=1:length(SampRat)          % iterate for all sampling ratios
        for iter=1:maxIter
            disp(sprintf('Iteration %d of sampling ratio %d on %dth image is in process now',...
                iter,SampRat(i),k));
            pause(2);
            
            %% compressive measurements of the image
            idx=randperm(n1*n2);        % index of the samples to be picked as per PCI sensing matrix
            idx=idx(1:ceil(SampRat(i)*n1*n2/100));
            R=opRestriction(n1*n2,idx); % operator for PCI sensing matrix
            
            y=R(img(:),1);            % sub-sampled image
           
            %% Reconstruct full image using R-Pyramid wavelet decomposition method
            A1=opFoG(R,W1t);          % operator A=R*Wt
            [recImg1,~] = RecFullImageFromCompImage(A1,y,W1t,n1,n2);
            
            %% Reconstruct full image using L-Pyramid wavelet decomposition method
            A2=opFoG(R,W2t);          % operator A=R*Wt
            [recImg2,~] = RecFullImageFromCompImage(A2,y,W2t,n1,n2);
            
            %% Compare the performance in terms of PSNR
            PSNR1(iter)=calPSNR(img,recImg1,0);     PSNR2(iter)=calPSNR(img,recImg2,0);
           
        end
        %% Average PSNR over different iterations
        avgPSNR1(i,k)=mean(PSNR1);     avgPSNR2(i,k)=mean(PSNR2);
    end
end

%% Plot results for psnr comparisons
plot(SampRat,avgPSNR1(:,1),'k','LineWidth',1,'marker','.');
hold on;
plot(SampRat,avgPSNR2(:,1),'k','LineWidth',1,'marker','p');
set(gca,'XDir','reverse')
xlabel('Sampling Ratio (in %)','Fontsize',14);
ylabel('PSNR (in dB)','Fontsize',14);
legend('R−Pyramid wavelet decomposition','L−Pyramid wavelet decomposition')

%% This ends the code