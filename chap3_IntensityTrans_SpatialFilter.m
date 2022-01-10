%% 3.2 Intensity Transformation Function
%% imadjust
f = imread('breastXray.tif');
g1 = imadjust(f, [0 1], [1 0]);
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [], [], 2);
figure, imshow(g3);
%% stretchlim
g4 = imadjust(f, stretchlim(f), []);
g5 = imadjust(f, stretchlim(f), [1 0]);
figure, imshow(f);
figure, imshow(g4);
figure, imshow(g5);
%% Lograthmic Transformation
f = imread('fourier_transform.tif');
figure, imshow(f);
logf = log(1 + double(f));
g = im2uint8(mat2gray(logf));
figure, imshow(g);
%% Specifying Arbitrary Intensity Transformations
r = linspace(0, 1, 16);
f = imread('lunar-shadows.tif');
fdoub = im2double(f);
figure, imshow(f);
T = r.^2;
g = interp1(r, T, fdoub);
figure, imshow(g);
%% Custom Functions for Manipulating Image Intensities
f = imread('bonescan.tif');
fdouble = im2double(f);
m = mean2(fdouble);
E = 0.9;
figure, imshow(fdouble);
g = intensityTransformations(fdouble, 'stretch', m, E);
figure, imshow(g);
r = 0:1/255:1;
T = 1./(1 + m./r).^E;
figure, plot(T);
%% A function for Intensity Scaling
X = [1 2 3 ;4 5 6;7 8 9];
idx = find(X >= 3 & X < 6);
[r, c] = find(X >= 3 & X < 6);
disp([r,c]);
intensityScaling
%% 3.3 Histogram Processing
f = imread('liver_cells.jpg');
f = rgb2gray(f);
%figure, imshow(f);
h = imhist(f, 30)/numel(f)
horz = linspace(0, 255, 30);
figure, bar(horz, h, 'FaceColor', [0 106 78]/255, 'EdgeColor', [0 212 156]/255, 'LineWidth', 0.75);
ax = gca;
ax.Color = [190 228 223]/255;
ax.YTick = 0:max(h(:))/4:max(h(:));
ax.FontName = 'Times Ten';
ax.FontSize = 8;
%% Histogram Equalization
f = imread('flower.jpeg');
figure, imshow(f);
g = histeq(f, 256);
figure, imshow(g);
figure, imhist(f);
figure, imhist(g);
hnorm = imhist(f)/numel(f);
cdf = cumsum(hnorm);
r = linspace(0,1,256);
figure, plot(r, cdf);
%% Histogram Matching
f = im2double(imread('chestXray.jpg'));
figure, imshow(f);
load goldenChestXrayHistogram
figure, plot(f, goldenChestXrayHistogram);
%% Adaptive Histogram Equalization
f = imread('hidden-symbols.tif');
figure, imshow(f); 
fe = histeq(f, 100);
figure, imshow(fe);
g = adapthisteq(f,'ClipLimit',0.4,'Distribution','exponential','NumTiles',[12 12]);
figure, imshow(g);
%% 3.4 Linear Spatial Filtering
f = im2double(rgb2gray(imread('four-squares.jpg')));
figure, imshow(f);
w = ones(31);
gd = imfilter(f, w);
figure, imshow(gd, []);
gr = imfilter(f, w, 'replicate');
figure, imshow(gr, []);
gs = imfilter(f, w, 'symmetric');
figure, imshow(gs, []);
gc = imfilter(f, w, 'circular');
figure, imshow(gc, []);
f8 = im2uint8(f);
g8r = imfilter(f8,w,'replicate');
figure, imshow(g8r, []);
%% Fspecial and Imfilter for image smoothing
f = imread('test_pattern.tif');
figure, imshow(f);
[M N] = size(f);
sig = 0.01*M;
r = ceil(6*sig);
r = r -1;
w1 = fspecial('gaussian',r,sig);
g1 = imfilter(f, w1, 'replicate');
figure, imshow(g1);
%% Using functions Fspecial and imfilter for image sharpening
w = fspecial('laplacian',0);
f = imread('moon-blurry.tif');
figure, imshow(f);
g1 = imfilter(f ,w, 'replicate');
figure, imshow(g1, []);
f2 =im2double(f);
g2 = imfilter(f2, w, 'replicate');
figure, imshow(g2, []);
g = f2 - g2;
figure, imshow(g);
%% Manually Specifying Kernels and Compare Enhancement Techniques
f = im2double(imread('moon-blurry.tif'));
figure, imshow(f);
w4 = fspecial('laplacian',0);
w8 = [1 1 1; 1 -8 1;1 1 1];
g4 = f - imfilter(f, w4, 'replicate');
g8 = f - imfilter(f, w8, 'replicate');
figure, imshow(g4);
figure, imshow(g8);
%% Highpass filters from lowpass filters.
lp1d = fir1(128,0.1);
figure, plot(lp1d);
w1LP2d = (lp1d')*lp1d;
w2LP2d = ftrans2(lp1d);
figure, mesh(w1LP2d(1:2:end, 1:2:end));
figure, mesh(w2LP2d(1:2:end, 1:2:end));
f = rgb2gray(im2double(imread('zoneplate.jpg')));
figure, imshow(f);
gLP1 = imfilter(f, w1LP2d, 'replicate');
gLP2 = imfilter(f, w2LP2d, 'replicate');
figure, imshow(gLP1);
figure, imshow(gLP2);
%% Unsharp Masking Filters
f = rgb2gray(imread('blurryImage.jpg'));
figure, imshow(f);
g1 = imsharpen(f);
%figure, imshow(g1);
g2 = imsharpen(f, 'Radius', 5);
%figure, imshow(g2);
g3 = imsharpen(f, 'Radius', 5, 'Amount', 2, 'Threshold', 0.05);
figure, imshow(g3);
%% 3.5 Nonlinear Spatial Filtering
f = rgb2gray(imread('pepper_noise1.png'));
figure, imshow(f);

% Construct the max filter
maxfilt = @(A) max(A,[],1);

% Neighnorhood Size
m = 2; n =2;

% Manually Pad the Input Image
fp = padarray(f, [m n], 'replicate');

% Apply the max filter to the padded image.
g = colfilt(fp, [m n], 'sliding', maxfilt);

% Remove Padding
[M, N] = size(f);
g = g(1:M - 2*m, 1:N -2*n);

% Display the result
figure, imshow(g);
%% Median Filtering Using function medfilt2
f = imread('circuitboard.tif');
fn = imnoise(f, 'salt & pepper', 0.2);
figure, imshow(f);
figure, imshow(fn);
gm = medfilt2(fn);
gms = medfilt2(fn, 'symmetric');
figure, imshow(gm);
figure, imshow(gms);
%% 3.6 Using Fuzzy Sets for Intensity Transformations and Spatial Filtering
f1 = makecounter(0);
f2 = makecounter(20);
g = @(x) 1./x;
f = @sin;
h = compose12(f, g);
fplot(h, [-1 1], 20);
triangmf();
%% Generating handles for the input membership functions
ulow = @(z) 1 - sigmamf(z, 0.27, 0.47);
umid = @(z) triangmf(z, 0.24, 0.50, 0.74);
uhigh = @(z) sigmamf(z, 0.53, 0.73);
fplot(ulow, [0 1]);
hold on
fplot(umid, [0 1], '-.');
fplot(uhigh, [0 1], '--');
hold off;
title('Input Memebership fucntions of Example 3.18');
unorm = @(z) 1 - sigmamf(z, 0.18, 0.33);
umarg = @(z) triangmf(z, 0.23, 0.35, 0.53, 0.69);
ufail = @(z) sigmamf(z, 0.59, 0.78);
rules = {ulow, umid, uhigh};
L = lambdafcns(rules);
z = 0.7;
outputmfs = {unorm, umarg, ufail};
Q = implfcns(L, outputmfs, z);
Qa = aggfcn(Q);
F = fuzzysysfcn(rules, outputmfs, [0 1]);
final_result = defuzzify(Qa,[0 1]);
%% Using Fuzzy Sets for Intensity Transformations
% Specify the input memebership functions
udark = @(z) 1 - sigmamf(z, 0.35, 0.5);
ugray = @(z) triangmf(z, 0.35, 0.5, 0.65);
ubright = @(z) sigmamf(z, 0.5, 0.65);

% Plot the input memberhsip functions
fplot(udark, [0 1], 20)
hold on
fplot(ugray, [0 1])
fplot(ubright, [0 1])
hold off

% Specify the output memebership functions
udarker = @(z) bellmf(z, 0.0, 0.1);
umidgray = @(z) bellmf(z, 0.4, 0.5);
ubrighter = @(z) bellmf(z, 0.8, 0.9);

% Obtain the fuzzy system response function
rules = {udark; ugray; ubright};
outmf = {udarker; umidgray; ubrighter};
F = fuzzysysfcn(rules, outmf, [0 1 ]);

% Use F to construct an intensity transformation fucntion
z = linspace(0, 1 , 256);
T = F(z);

% Transform the intensities of f using T
f = imread('einstein.tif');
figure,imshow(f);
g = intensityTransformations(f, 'specified', T);
figure, imshow(g);
%% Using Fuzzy Sets for Spatial Filtering

% Input membership functions
zero = @(z) bellmf(z, -0.3, 0);
not_used = @(z) onemf(z);

% Output memberhsip fucntions
black = @(z) triangmf(z, 0, 0, 0.75);
white = @(z) triangmf(z, 0.25, 1, 1);

% There are four rules and four inputs, so the inmf matrix is 4*4. Each
% row of the inmf matrrix corresponds to one rule
inmf = {zero, not_used, zero, not_used
    not_used, not_used, zero, zero
    not_used, zero, not_used, zero
    zero, zero, not_used, not_used}

% Specify cell array of output memberhsip functons, OUTMF (see function
% IMPLFCNS). There are four IF-THEN rules in this problems, all resultingù
% in WHITE, and one ELSE rule resulting in BLACK. (see Fig. 3.40)
outmf = {white, white, white, white, black};

% Inputs to the output membership fuctions are in the range [0, 1]
vrange = [0, 1];

F = fuzzysysfcn(inmf, outmf, vrange);

% Compute a lookup-table-based approximation to the fuzzy system
%  function. Each of four inouts is in the range [-1 1].
G = approxfcn(F, [-1 1;-1 1;-1 1;-1 1]);

save fuzzyedgesys G

fuzzyfilt
%% 
f = imread('head.tif');
figure, imshow(f);
g = fuzzyfilt(f);
figure, imshow(g);