clear all, close all, clc
A = imread('data/lena.tif');
% B = rgb2gray(A);
B = A;
% imshow(A);
%% Wavelet decomposition (2 level)
n = 2; w = 'db1'; [C,S] = wavedec2(B,n,w);

% LEVEL 1
[H1 V1 D1] = detcoef2('a',C,S,1); % Details
A1 = appcoef2(C,S,w,1); % Approximation
V1img = wcodemat(V1,128);
H1img = wcodemat(H1,128);
D1img = wcodemat(D1,128);
A1img = wcodemat(A1,128);
%% LEVEL 2

[H2 V2 D2] = detcoef2('a',C,S,2); % Details
A2 = appcoef2(C,S,w,2); % Approximation
A2img = wcodemat(A2,128);
H2img = wcodemat(H2,128);
V2img = wcodemat(V2,128);
D2img = wcodemat(D2,128);

dec2 = [A2img H2img; V2img D2img];
dec1 = [imresize(dec2,size(H1img)) H1img ; V1img D1img];
imagesc(dec1);
colormap pink(255)
colorbar
axis off, axis tight
set(gcf,'Position',[100 100 600 800])