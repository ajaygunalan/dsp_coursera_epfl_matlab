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
%% 4.3 Filtering in Frequency Domain
% Filter without Padding
f = imread('square_original.tif');
figure, imshow(f);
[M, N] = size(f);
[f, revertClass] = tofloat(f);
F = fft2(f);
sig = 10;
H = lpfilter('gaussian', M, N, sig);
G = H.*F;
g = ifft2(G);
g = revertClass(g);
figure, imshow(g);
% Filter with Padding
PQ = paddedsize(size(f)); % f is floating point
Fp = fft2(f, PQ(1), PQ(2)); % Compute FFT with zero padding
Hp = lpfilter('gaussian', PQ(1), PQ(2), 2*sig);
Gp = Hp.*Fp;
gp = ifft2(Gp);
figure, imshow(gp);
gpc = gp(1:size(f,1),1:size(f,2));
gpc = revertClass(gpc);
figure, imshow(gpc);
%% 4.4 Obtaining Transfer Function from Spatial Kernels
%% Spatial Domain
f = imread('building.tif');
figure, imshow(f);
h = fspecial('sobel')'; % transpose fspecial('sobel') by '
figure, display(h);
gs = imfilter(f,h);
figure, imshow(gs,[]);
figure, imshow(abs(gs),[]);
figure, imshow(abs(gs)> 0.2*abs(max(gs(:))),[]);
%% Frequency Domain
f = imread('building.tif');
figure, imshow(f);
[f, revertClass] = tofloat(f);
F = fft2(f);
S = fftshift(log(1 + abs(F)));
figure, imshow(S, []); 
PQ = paddedsize(size(f));
h = fspecial('sobel')'; % from Spatial Domain
gs = imfilter(f,h); % from Spatial Domain
H = freqz2(h, PQ(1), PQ(2)); % Genereates Freq response from a sptail Kernel
H1 = ifftshift(H);
figure, imshow(abs(H),[]);
figure, imshow(abs(H1),[]);
gf = dftfilt(f,H1);
figure, imshow(gf,[]);
figure, imshow(abs(gf),[]);
figure, imshow(abs(gf)> 0.2*abs(max(gs(:))),[]);
% Difference between gs and gf
d = abs(gs-gf);
disp(max(d(:)));
%% 4.5  