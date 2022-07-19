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
% This function is to compare the CS-based reconstruction performance among 
% three different sensing matrices, that is Bernoulli, Gaussian and Prtial
% Canonical Identity (PCI) matrix as reported in paper. Particularly, it
% compares the reconstruction accuracy and time of reconstruction with the
% three sensing matrices.
%
% Please note that operator 'phi' in paper is equivalent to 'Rb', 'Rg' or 
% 'Rp' here in this code and 'psi' is equivalent to Wt or WPt. 
% Hence, A=phi*psi in paper is equivalent to A=R*Wt, where Wt denotes 
% transpose of wavelet operator, W
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
% %% output: psnrB, psnrG, psnrP-> psnr of the reconstructed image from
%            compressiveley sensed image, sensed with with Bernoulli, 
%            Gaussian and PCI sensing matrix, respectively.
%            timB, timG, timP-> time in reconstruction of the image from
%            compressiveley sensed image, sensed with with Bernoulli, 
%            Gaussian and PCI sensing matrix, respectively.
%            
% %% input:  img-> original full image
%            Wt-> wavelet transpose (or operator 'phi' in paper) for
%            Gaussian and Bernoulli sensing matrix
%            WPt-> wavelet transpose (or operator 'phi' in paper) for
%            PCI sensing matrix
%            SampRat-> sampling ratios considered for experiment
%            BlkLen-> % length of the block on which CS is performed 
%            n1,n2-> size of the image
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
function [psnrB,psnrG,psnrP,timB,timG,timP] = ...
    Fun_SensingMatrices_comparison(img,Wt,WPt,SampRat,BlkLen,n1,n2)
NoOfBlk1 = n1/BlkLen;  NoOfBlk2=n2/BlkLen;       % number of blocks along columns and rows
for k = 1:length(SampRat)                        % Iterate for different sampling ratios
    display(sprintf('Code running for %d samping ratio...',SampRat(k)));
    %% Reconstruction with Bernoulli and Gaussian sensing matrix
    m1 = ceil(SampRat(k)*BlkLen*BlkLen/100);     % number of compressively sensed measurements
    recImg = zeros(n1,n2);                       % initialize recoonstructed image
    for i = 0:NoOfBlk1-1                         % iterate for every block in the image
        for j = 0:NoOfBlk2-1
 
            img1 = img(BlkLen*i+1:BlkLen*(i+1),BlkLen*j+1:BlkLen*(j+1)); % pick a block of image
                                
            % reconstruction with Berboulli sensing matrix
            Rb = opBernoulli(m1,BlkLen*BlkLen);  % Bernoulli sensing matrix
            Ab = opFoG(Rb,Wt);                   % operator A=R*Wt
%             yb = Rb(img1(:),1);                  % compressive measurements
            yb = Rb*img1(:);
            [recImgB_Blk,timB_Blk(i+1,j+1)] = RecFullImageFromCompImage(Ab,yb,Wt,BlkLen,BlkLen);
                                               % reconstruction of single
                                               % block.
            recImgB1(BlkLen*i+1:BlkLen*(i+1),BlkLen*j+1:BlkLen*(j+1)) = recImgB_Blk;
                                               % full reconstructed image
            
            % reconstruction with Gaussian sensing matrix
            Rg = opGaussian(m1,BlkLen*BlkLen);  % Gaussian sensing matrix
            Ag = opFoG(Rg,Wt);                  % operator A=R*Wt
            yg = Rg(img1(:),1);                 % compressive measurements
            yg = Rg*(img1(:);                 % compressive measurements
            
            [recImgG_Blk,timG_Blk(i+1,j+1)] = RecFullImageFromCompImage(Ag,yg,Wt,BlkLen,BlkLen);
                                              % reconstruction of single
                                              % block.
            recImgG1(BlkLen*i+1:BlkLen*(i+1),BlkLen*j+1:BlkLen*(j+1)) = recImgG_Blk;
                                              % full reconstructed image
        end
    end
    
    % Remove block artifacts from reconstructed images
    recImgB = RemoveBlockArtifacts(recImgB1,2,BlkLen,n1,n2);
    recImgG = RemoveBlockArtifacts(recImgG1,2,BlkLen,n1,n2);
    
    % check qulaity of reconstructed image in terms of PSNR and also, calculate
    % total time in reconstruction
    psnrB(k) = calPSNR(img,recImgB,0);
    timB(k) = sum(timB_Blk(:));
    
    psnrG(k) = calPSNR(img,recImgG,0);
    timG(k) = sum(timG_Blk(:));
    
    %% Reconstruction with Partial Canonical Identity (PCI) matrix
    clear m1;
    m1 = ceil(SampRat(k)*n1*n2/100);     % number of compressively sensed measurements
    idx = randperm(n1*n2);               
    idx = sort(idx(1:m1));               % index of randomly picked samples
    Rp = opRestriction(n1*n2,idx);       % operator to pick random samples from image
    Ap = opFoG(Rp,WPt);                  % operator A=R*Wt
    yp = Rp(img(:),1);                   % compressive measurements
    [recImgP,timP(k)] = RecFullImageFromCompImage(Ap,yp,WPt,n1,n2);
                                       % reconstruction of image
    psnrP(k) = calPSNR(img,recImgP,0);   % psnr of reconstructed image
end