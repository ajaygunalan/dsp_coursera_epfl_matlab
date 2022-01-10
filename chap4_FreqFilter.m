%% Computing and Visulaizing 2D DFT in MATLAB
f = imread('rectangle.tif');
figure, imshow(f);
F = fft2(f);
% S = abs(F);
% figure, imshow(S, []);
Fc = fftshift(F);
figure, imshow(abs(Fc), []);
%  Convert Fc into log scale for better display
S2 = log(1+abs(Fc));
figure, imshow(S2, []);
% Computing the phase angle of the DFT
phi = atan2(imag(F), real(F));
phi = angle(F);
figure, imshow(phi, []);
% F = S.*exp(1i*phi);