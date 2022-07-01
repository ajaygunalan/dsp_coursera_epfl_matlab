% tveq_phantom_example.m
%
% Phantom reconstruction from samples on 22 radial lines in the Fourier
% plane.
%
% Written by: Justin Romberg, Caltech
% Email: jrom@acm.caltech.edu
% Created: October 2005
%
%% 0. Load the image
clear all; clc;
path(path, './Optimization');
path(path, './Measurements');
path(path, './Data');

% Phantom 
n = 256;
N = n*n;
X = phantom(n);
imwrite(X,'phantom.png');
x = X(:);

%% 1. Design Sampler
% number of radial lines in the Fourier domain
L = 22;
% LineMask creates the starshaped pattern consisting of L lines through the origin.
[M,Mh,mh,mhi] = LineMask(L,n);
% The vector OMEGA contains the locations of the frequencies used in the sampling pattern.
OMEGA = mhi;
Sampler = @(data) A_fhp(data, OMEGA);
%% 2. Sample the data x to obtain the measurement y.
y = Sampler(x);

%% 3. min l2 reconstruction (backprojection)
At = @(data) At_fhp(data, OMEGA, n);
xbp = At(y);
Xbp = reshape(xbp,n,n);
%% 4. Reconstruct the image
xp = tveq_logbarrier(xbp, Sampler, At, y, 1e-1, 2, 1e-8, 600);
Xtv = reshape(xp, n, n);
%% 5. Display the result
figure('name','Compressive sensing image reconstructions')
subplot(2,2,1), imshow(X), xlabel('original'), axis image
subplot(2,2,2), imshow(Xbp), xlabel('least squares'), axis image
subplot(2,2,3), imshow(Xtv), xlabel('basis pursuit'), axis image
subplot(2,2,4), imshow(Xtv), xlabel('sampling pattern'), axis image
colormap gray

