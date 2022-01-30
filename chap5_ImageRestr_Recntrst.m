%% 5.1 A Model of the Image Restoration
%% 5.2 Noise Models
M = 512;
N = 512;
Ca = [4 4];
[ra,~,Sa] = imnoise3(M,N,Ca);
ra = mat2gray(ra); % Scale to the [0,1] range
Sa = imdilate(Sa,ones()); % Dilate the single impulse dots. (SEE Chapter 10 regarding dilations)
imshow(Sa);
figure, imshow(ra);
Cb = [4 4;-12 12];
Ab = [1,1.5];
[rb,~,Sb]= imnoise3(M,N,Cb,Ab);
rb = mat2gray(rb); % Scale to the [0 1] range
Sb = imdilate(Sb, ones(3));
figure, imshow(rb);
% Estimate noise param from ROI
f = imread('ckt-board-gauss-var.tif');
[B,c,r] = roipoly(f);
figure, imshow(B);
c = round(c);
r = round(r);
[h, npix] = histroi(f,c,r);
figure, bar(h, 1);
[v ,unv] = statmoments(h,2);
disp(v);
disp(unv);
%% 5.3 Restoration in the presence of Noise - Spatial Filtering
fp = imread('circuit-board-pepper-prob-pt1.tif');
fs = imread('circuit-board-salt-prob-pt1.tif');
figure, imshow(fp);
figure, imshow(fs);
gp = spfilt(fp, 'chmean', 3,3,1.5);
gs = spfilt(fs, 'chmean', 3,3,-1.5);
figure, imshow(gp);
figure, imshow(gs);
%% Adaptive Spatial Denoising Filter
f = imread('ckt-board-orig.tif');
g = imnoise(f,'salt & pepper',0.25);
figure, imshow(g);
stdFltr = medfilt2(g,[7,7],'symmetric');
adpFltr = adpmedian(g,7);
figure, imshow(stdFltr);
figure, imshow(adpFltr);
%% 5.4 Modeling the Degradation 
%% 5.6 Restoration based on Wiener Filtering
f = rgb2gray(imread('watch.PNG'));
figure, imshow(f);
% Generate an aggressive motion-blurring PSF
len = 50; % Approximately 10% of the image height/width
theta = 45;
PSF = fspecial('motion',len,theta);
%Blur the image.
blurred = imfilter(f, PSF, 'conv', 'circular');
figure, imshow(blurred);

% Add Gaussian Noise
mean = 0.0;
var = 0.0001;
blurred_noisy = imnoise(blurred, 'gaussian', mean, var);

% The noise pattern id the difference between the preceding two images
noise = blurred_noisy - blurred;

% Display the noise pattern and the burred noisy image
figure, imshow(intensityScaling(noise));
figure, imshow(blurred_noisy);
%% 5.5 Direct Inverse Filtering
% When you assume no noise
R = 0;
frest1 = deconvwnr(blurred_noisy, PSF, R);
figure, imshow(frest1);
Sn = abs(fft2(noise)).^2;
nA = sum(Sn(:))/numel(noise);
Sf = abs(fft2(f)).^2;
fA = sum(Sf(:))/numel(f);
R = nA/fA;
% Restore and display result
frest2 = deconvwnr(blurred_noisy, PSF, R);
figure, imshow(frest2);
% Step 3
NCORR = fftshift(ifft2(Sn));
ICORR = fftshift(ifft2(Sf));
frest3 = deconvwnr(blurred_noisy, PSF, NCORR, ICORR);
figure, imshow(frest3);
%% 5.7 Constarined Least Squared Filtering
%% 5.8 Iterative Non linear Restoration using Lucy-Richardson Algo
%% 5.9 Blind Deconvolution
%% 5.10 Image Reconstruction from Projections
