%Demonstrates compressively sampling and D-AMP recovery of an image.


%Parameters
denoiser2='fast-BM3D'; %Available options are NLM, Gauss, Bilateral, BLS-GSM, BM3D, fast-BM3D, and BM3D-SAPCA 
iters=30;
%%
% Paramters for Spiral
dSpirals = 30;
nSpirals = 20;
CompresRatio = 0.4; 
InputImage = imread('barbara.png');
[height width] = size(InputImage);
N = height*width;
m = round(0.3*N);
nPoints = sqrt(m);
theta = linspace(0,360*nSpirals, nPoints);
% Define Spiral
x = round((width/2) +(theta/dSpirals).*cosd(theta));
y = round((height/2) +(theta/dSpirals).*sind(theta));
plot(x,y);
axis([0 width 0 height]);
grid on;
Measure = InputImage(x,y);
%%

%Compressively sample the image
y=Measure;

%Recover Signal using D-AMP algorithms
% x_hat1 = DAMP(y,iters,height,width,denoiser1,Sampler);
x_hat2 = DAMP(y,iters,height,width,denoiser2,Sampler);

%D-AMP Recovery Performance
% performance1=PSNR(x_0,x_hat1);
performance2=PSNR(x_0,x_hat2);
% [num2str(SamplingRate*100),'% Sampling ', denoiser1, '-AMP Reconstruction PSNR=',num2str(performance1)]
[num2str(SamplingRate*100),'% Sampling ', denoiser2, '-AMP Reconstruction PSNR=',num2str(performance2)]

%Plot Recovered Signals
subplot(1,2,1);
imshow(uint8(x_0));title('Original Image');
% subplot(1,3,2);
% imshow(uint8(x_hat1));title([denoiser1, '-AMP']);
subplot(1,2,2);
imshow(uint8(x_hat2));title([denoiser2, '-AMP']);
