clear all; close all; clc
%% 1. Load data
imdata = rgb2gray(imread('cameraman.jpg'));

%% 2. Get Fourier Transform of an image
F = fft2(imdata);
S = abs(F);

%% 3. get the centered spectrum
Fsh = fftshift(F);

%% 4. Apply log transform
S2 = log(1+abs(Fsh));

%reconstruct the Image
F = ifftshift(Fsh);
f = ifft2(F);


%%  5. Plot the Result
subplot(2,3,1)
imshow(imdata)
title('image')

subplot(2,3,2)
imshow(S, []);
title('Fourier transform of an image')

subplot(2,3,3)
imshow(abs(Fsh),[]);
title('Centered fourier transform of Image')

subplot(2,3,4)
imshow(S2,[]);
title('log transformed Image')

subplot(2,3,5)
imshow(f,[]),
title('reconstructed Image')