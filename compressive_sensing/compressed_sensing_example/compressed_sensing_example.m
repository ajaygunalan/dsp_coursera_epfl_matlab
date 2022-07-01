% compressed sensing example
%
%___DESCRIPTION___
% MATLAB implementation of compressive sensing example as described in R.
% Baraniuk, Compressive Sensing, IEEE Signal Processing Magazine, [118],
% July 2007. The code acquires 250 averaged random measurements of a 2500
% pixel image. We assume that the image has a sparse representation in the
% DCT domain (not very sparse in practice). Hence the image can be
% recovered from its compressed form using basis pursuit.
%
%___DEPENDENCIES___
% Requires the MATLAB toolbox l_1-MAGIC: Recovery of Sparse Signals via Convex
% Programming v1.11 by J. Candes and J. Romberg, Caltech, 2005. 
%
%___VARIABLES___
% x = original signal (nx1) y = compressed signal (mx1) SamplingMat = measurement
% matrix (mxn) TransformDomain = Basis functions (nxn) Theta = SamplingMat * TransformDomain (mxn) s =
% sparse coefficient vector (to be determined) (nx1)
%
%___PROBLEM___
% Invert the matrix equation y = Theta * s and therefore recover hat_x as
% k-sparse linear combination of basis functions contained in TransformDomain. Note
% also that y = SamplingMat * x.
%
%___SOLUTION___
% Let SamplingMat be a matrix of i.i.d. Gaussian variables. Solve matrix inversion
% problem using basis pursuit (BP).

%___CREATED___
% o By S.Gibson, School of Physical Sciences, University of Kent. 
% o 1st May, 2013.
% o version 1.0
% o NOTES: If the max number of iterations exceeds 25, error sometimes
%   occurs in l1eq_pd function call.
%
%___DISCLAIMER___
% The code below is my interpretation of Baraniuk's compressed sensing
% article. I don't claim to be an authority on the subject!

%% Points
% n is the length of the signal vector; In this case, 2500= 50*50.
% m is the length of the measurement vector; In this case, 250.
% SamplingMat is m by n.
% TransformDomain n by n.
%% 0. Load the image
clear, close all, clc
A = imread('cameramanlocal.tif');
A = imresize(A,0.0958);
% A = inputImage([50:99],[50:99]);
x = double(A(:));
n = length(x);

%% 1. Design Sampling Matrix
m = 300; % NOTE: small error still present after increasing m to 1500;
SamplingMat = randn(m,n);
    %__ALTERNATIVES TO THE ABOVE MEASUREMENT MATRIX___ 
    %SamplingMat = (sign(randn(m,n))+ones(m,n))/2; % micro mirror array (mma) e.g. single
    %pixel camera SamplingMat = orth(SamplingMat')'; % NOTE: See Candes & Romberg, l1
    %magic, Caltech, 2005.

%% 2. Sample the data to obtain the measurement.
y = SamplingMat*x;

%% 3. Transform into sparse domain.  
%___THETA___
% NOTE: Avoid calculating TransformDomain (nxn) directly to avoid memory issues.
Theta = zeros(m,n);
for ii = 1:n
    ii;
    ek = zeros(1,n);
    ek(ii) = 1;
    TransformDomain = dct(ek)';
    Theta(:,ii) = SamplingMat*TransformDomain;
end

%___l2 NORM SOLUTION___ s2 = Theta\y; %s2 = pinv(Theta)*y
s2 = pinv(Theta)*y;

%___BP SOLUTION___
s1 = l1eq_pd(s2,Theta,Theta',y,5e-3,20); % L1-magic toolbox
%x = l1eq_pd(y,A,A',b,5e-3,32);

%___DISPLAY SOLUTIONS___
plot(s2,'b'), hold
plot(s1,'r.-')
legend('least squares','basis pursuit')
title('solution to y = \Theta s')

%___IMAGE RECONSTRUCTIONS___
x2 = zeros(n,1);
for ii = 1:n
    ii;
    ek = zeros(1,n);
    ek(ii) = 1;
    TransformDomain = idct(ek)';
    x2 = x2+TransformDomain*s2(ii);
end

x1 = zeros(n,1);
for ii = 1:n
    ii;
    ek = zeros(1,n);
    ek(ii) = 1;
    TransformDomain = idct(ek)';
    x1 = x1+TransformDomain*s1(ii);
end

figure('name','Compressive sensing image reconstructions')
subplot(2,2,1), imagesc(reshape(x,50,50)), xlabel('original'), axis image
subplot(2,2,2), imagesc(reshape(x2,50,50)), xlabel('least squares'), axis image
subplot(2,2,3), imagesc(reshape(x1,50,50)), xlabel('basis pursuit'), axis image
subplot(2,2,4), imshow(SamplingMat), xlabel('sampling pattern'), axis image
colormap gray




