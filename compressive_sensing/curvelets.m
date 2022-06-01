% https://www.numerical-tours.com/matlab/denoisingwav_6_curvelets/#1
clear all, close all, clc
name = 'data\lena';
M = rescale(load_image(name, 256));
options.null = 0;
options.finest = 1;
options.nbscales = 4;
options.nbangles_coarse = 16;
options.is_real = 1;
options.n = 256;
MW = perform_curvelet_transform(M, options);
clf;
plot_curvelet(MW, options);
% disp = fdct_wrapping_dispcoef(MW);
% imshow(disp);
%% https://www.section.io/engineering-education/how-to-denoise-images-using-curvelet-transform-in-matlab/#curvelet-toolbox
clear all, close all, clc
img = double(imread('data\lena.tif'));
optReal = 0;
optFinest = 1;

% fwd transform
fprintf("True");
C = fdct_wrapping(img, optReal, optFinest);
disp = fdct_wrapping_dispcoef(C);
imshow(disp);


%%
cA = C{1, 1}{1, 1}; %Extracting approximation coefficients.
cAd = 225.*(cA./max(cA));  %Normalizing coefficients for display only.
figure(1)
imshow((cAd), []);   % Showing approximation coefficients.

%% Showing all the detailed coefficients at scale 2.
figure(2)
for k=1:16
    x=C{1, 2}{1, k};
    xr=imresize(x, [512, 512]);
    imshow(uint8(xr), []);
    pause(1);
end

