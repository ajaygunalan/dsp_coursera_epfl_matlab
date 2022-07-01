%% 1. Generate data
clear all; clc;
rng('default');
Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = sin(2*pi*25*t) + randn(size(t))/10;
%x = sin(2*pi*25*t);

%% 2. Cosine Transform
y = dct(x);

%% 3. Thresholding
sigcoeff = abs(y) >= 1;
howmany = sum(sigcoeff);
y(~sigcoeff) = 0;
%% 4. Inverse Cosine Transform
z = idct(y);

%%  5. Plot the Result
subplot(3,1,1)
plot(t,x)
yl = ylim;
title('Original')

subplot(3,1,2)
plot(t,z)
ylim(yl)
title('Reconstructed')

subplot(3,1,3)
plot(y)
title('DCT Transform')