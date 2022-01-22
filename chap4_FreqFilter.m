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
%% 4.5 Generating Filter Transfer Fucntion in Frequency Domian
[U V] = dftuv(8,5);
DSQ = hypot(U,V).^2;
round(DSQ)
fftshift(DSQ)
%% Low Pass Filter
f = imread('testPattern.tif');
figure, imshow(f);
PQ = paddedsize(size(f));
D0 = 50;
ILP = lpfilter('ideal', PQ(1), PQ(2), D0);
gLP = dftfilt(f, ILP, 'symmetric');
figure, imshow(gLP);
%% 4.6 Highpass Filtering in the Frequency Domain
f = imread('testPattern.tif');
figure, imshow(f);
PQ = paddedsize(size(f));
D0 = 50;
HLPG = hpfilter('Gaussian', PQ(1), PQ(2), D0);
gLPG = dftfilt(f, HLPG, 'symmetric');
figure, imshow(gLPG);
gLPGS = intensityScaling(gLPG);
figure, imshow(gLPGS);
%%
f = imread('chest_xray.tif');
figure, imshow(f);
PQ = paddedsize(size(f));
D0 = round(0.05*PQ(1));
H = hpfilter('butterworth', PQ(1), PQ(2), D0, 2);
ghp = dftfilt(f, H, 'symmetric');
ghps = intensityScaling(ghp);
figure, imshow(ghps);
Hemp = 0.5 + 2.0*H;
gemp = dftfilt(f, Hemp, 'Symmetric');
gemps = intensityScaling(gemp);
figure, imshow(gemps);
geq = histeq(gemp, 256);
figure, imshow(geq);
%% 4.7 Bandreject, Bandpass, Notchreject, Notchpass Filtering
f = rgb2gray(imread('zoneplateCh4.jpg'));
[M,N] = size(f);
HLP = lpfilter('butterworth', M, N, 15,3);
gLP = dftfilt(f, HLP,'zeros');
figure, imshow(gLP);
HBR = bandfilter('butterworth', 'reject',M, N, 30,8,3);
gBR = intensityScaling(dftfilt(f, HBR,'zeros'));
figure, imshow(gBR);
%% Notch
f = tofloat(imread('car4.tif'));
figure, imshow(f);
[M, N] = size(f);
F = fft2(f);
% Obtain the specturm and show it as a scaled image
S = intensityScaling(log(1+abs(fftshift(F))));
figure, imshow(S);
% Use function impixelinfo to obatain the cordinates of the spikes interactively.
% Keep in mind the coordinates in impixelinfo are (col,row) coordinates, but we use
% (row, col) coordinates in cnotch
C1 = [99 154; 128 163];
% Generate the notch transfer fucntion
H1 = cnotch('gaussian','reject',M,N,C1,5);
% Compute the specturm of the filtered transform and show it as an Image
S1 = intensityScaling(fftshift(H1).*(tofloat(S)));
figure, imshow(S1);
% Filter the image and show the result
f1 = dftfilt(f, H1);
figure, imshow(f1);
% Repeat with the following C2 to reduce the higher frequency interference
% Components
C2 = [99 154;128 163;49 160;133 233;55 132;108 225;112 74];
H2 = cnotch('gaussian', 'reject', M,N,C2,5);
% Compute the specturm of the filtered transform and show it as an image
P2 = intensityScaling(fftshift(H2).*(tofloat(S)));
figure, imshow(P2);
% Filter the image and display the result
f2 = dftfilt(f, H2);
figure, imshow(f2);
f1r = imresize(f1, 1.5);
f2r = imresize(f2, 1.5);
figure, imshow(f1r);
figure, imshow(f2r);
%%
g = tofloat(imread('cassini.tif'));
figure, imshow(g);
[M,N] = size(g);
F = fft2(g);
S = intensityScaling(log(1+abs(fftshift(F))));
figure, imshow(S);
H = recnotch('reject','vertical',M,N,3,15);
figure, imshow(fftshift(H));
f = dftfilt(g, H);
figure, imshow(f);