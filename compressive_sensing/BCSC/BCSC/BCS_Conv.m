% Compressed Sensing to reconstuct images.
% Bregman Split iteration for L1 is employed.

% Written by Jingbo Wei, Nanchang University, Nov. 2014. gfoe@qq.com
% Original Version was written by Liu, Peng, ceode, 2013. This version required that band number equals to 3.
% Reference: in review

function [msData, maxPSNR, reconImage]=BCS_Conv(filename, alpha0, lambda0, sparsity, sigma, convMatrix, msData)

close all;

% set parameters
if (nargin<2)
	alpha0 = 0.3;
end
if (nargin<3)
	lambda0 = 0.1;
end
if (nargin<4)
	sparsity = 0.10;
end
if (nargin<5)
	sigma =	0;
end

L =3;					% scaling level of Daubechies Wavelet
h = daubcqf(8,'min');	% scaling filters of Daubechies Wavelet

% read image file
% filename = 'lena-color-256.tif';
file_path=[pwd '/images/' filename];
[file_dir, file_name, file_ext] = fileparts(file_path);
Img = imread(file_path);

[height,width,depth]=size(Img);

% build sparse convolution multiplication matrix from existing FoE kernel. -- an example
if (nargin<6)			%~exist('convMatrix')
% 	J=[];
% 	J{1} = [-1 1];
% 	J{2} = [1 -1]';		% kernel - total variation
	load FoE_Kernel;	% FoE fitering kernel
	J=FoE_J;
	convMatrix=cell(length(J));
	for k=1:length(J)
		convMatrix{k} = Create2dConvMatrix1(J{k}, [height,width]);
	end
end

K = length(convMatrix);		% number of filters
JtJ = cell(K);
for k=1:K
	JtJ{k} = convMatrix{k}'*convMatrix{k};
end

if ~exist('msData')
	[MR, Y, groups, X0]   =	GenSampleData_for_ColorImage(Img,sparsity,sigma);
	msData.M = MR;
	msData.Y = Y;
	msData.groups = groups;
	msData.X0 = X0;
	msData.Img = Img;
	msData.sparsity = sparsity;
	msData.ImageName = filename;
else
	MR = msData.M;
	Y = msData.Y;
	groups = msData.groups;
	X0 = msData.X0;
	Img = msData.Img;
end

%MR.MR: inverse wavelet transform
%MR.MRt: forward wavelet transform

%
MRtMR_X = [];
MRt_Y = [];
for iBand=1:depth
	mr = MR.MR{iBand};
	mrt = MR.MRt{iBand};
	MRtMR_X = [MRtMR_X mrt(mr(ones(height,width)))];
	MRt_Y = [MRt_Y mrt(Y(:, iBand))];
end

% CG parameter
max_cg_iter = 20;		
cg_steptol	= 1e-5;
cg_residtol = 1e-5;
cg_out_flag = 0;

%initialize all parameters of Bregman split algorithm to zero
X=zeros(height*width, depth);
D_X=zeros(size(X(:)));
B_X=zeros(size(X(:)));
D_k=cell(K);
B_k=cell(K);
for k=1:K
	D_k{k}=zeros(size(X(:)));
	B_k{k}=zeros(size(X(:)));
end

alpha=alpha0.*ones(size(X(:)));		% standard deviation for basic compressed sensing regulation
lambda_0 = alpha0;					% regulation parameters for basic compressed sensing constraint
lambda_k = lambda0*ones(K, 1);		% regulation parameters for other filtering constraint.

nIters=ceil(480/K);
PSNR_BS_Img=zeros(nIters, 1);
MSE_BS_Img=ones(nIters, 1)*256;
for iter=1:nIters
	%left side of Eq.
	RX = I_DWT(X(:), height, width, depth);		%size:[height*width,depth]
	RtHtH_RX = zeros(height*width*depth, 1);
	for k=1:K
		tmp = ConvMul(RX(:), JtJ{k}, height, width, depth);
		RtHtH_RX = RtHtH_RX + lambda_k(k)*tmp;
	end
	RtHtH_RX = F_DWT(RtHtH_RX, height, width, depth) + alpha.*X(:);

	%right side of Eq.
	RtHt=zeros(height*width*depth, 1);
	for k=1:K
		RtHt = RtHt +lambda_k(k)*ConvMul(D_k{k}-B_k{k}, convMatrix{k}', height, width, depth);
	end
	RtHt = F_DWT(RtHt, height, width, depth);
	RtHt = RtHt + alpha.*(D_X-B_X);		

	%  using CG to solve.
	G = MRtMR_X(:) + RtHtH_RX - MRt_Y(:) - RtHt;
	[DeltaX, residnormvec, stepnormvec, cgiter] = ...
		Conjunction_Gradient_Test2(MR, L, alpha, -G, height, width, depth, JtJ, lambda_0, lambda_k, max_cg_iter,cg_steptol,cg_residtol);
	Delta_X = reshape(DeltaX, size(X));
	X = X + Delta_X;

	MRtMR_X = [];
	for iBand=1:depth
		mr = MR.MR{iBand};
		mrt = MR.MRt{iBand};
		MRtMR_X = [MRtMR_X mrt(mr(X(:, iBand)))];
	end

	if (depth==3)
		D_X = shrink_wavelet3(X(:)+B_X, height, width, depth);
	else
		D_X = shrink_wavelet1(X(:)+B_X, height, width, depth);
	end
	B_X = B_X+X(:)-D_X;

	for k=1:K
		HRX = ConvMul(I_DWT(X(:), height, width, depth), convMatrix{k}, height, width, depth);
		D_k{k} = shrink_wavelet_PCA(HRX(:) + B_k{k}, 1/lambda_k(k), height, width, depth);
		B_k{k} = B_k{k} + HRX - D_k{k};
	end

	lambda_k = lambda0*ones(K, 1)*(1-0.8*iter/nIters);
		
	reconImage	= Reshape_ColorImage5_3(X,height,width, depth);
	PSNR_BS_Img(iter) = Test_PSNR(double(Img), double(reconImage),255);
	MSE_BS_Img(iter) = mean(abs(reconImage(:)-double(Img(:))));
	fprintf('%d(%.4fdB) ', iter, PSNR_BS_Img(iter));
	if (iter>2 && PSNR_BS_Img(iter)<PSNR_BS_Img(iter-1))
		break;
	end
end

[maxPSNR, maxPos] = max(PSNR_BS_Img);
fprintf('\n  best result in %d: MSE %.4f, PSNR %.4f \n',maxPos , min(MSE_BS_Img), maxPSNR);
figure;
subplot(1,2,1),imshow(uint8(Img));title('original image');
subplot(1,2,2),imshow(uint8(reconImage));title('Bregman CS');
% reconImage=ImgManifest_LeftDown(reconImage, 'manifest of result image', 80,150,20,20); %80,90,20,20);google

return


%% convolution in form of multiplication
function J_X = ConvMul(X, convMulMatrix, height, width, depth)
% convMulMatrix: convolution multiplication maxtrix
sizeX = size(X);
X = reshape(X, height*width, depth);
J_X = zeros(height*width, depth);
for ib=1:depth
	J_X(:, ib) = convMulMatrix*X(:, ib);
end
J_X = reshape(J_X, sizeX);
return;


%% forward wavelet tranform
function F=F_DWT(f, height, width, depth)
I=reshape(f, height, width, depth);
L =3;
h = daubcqf(8,'min');

for iBand = 1:depth
	[F(:,:,iBand),lv1] = mdwt(double(I(:,:,iBand)),h,L);
end
F=reshape(F,size(f));
return


%% inverse wavelet tranform
function F=I_DWT(f, height, width, depth)
I=reshape(f,height, width, depth);
L =3;	
h = daubcqf(8,'min');

for iBand = 1:depth
	[F(:,:,iBand),lv1] = midwt(double(I(:,:,iBand)),h,L);
end
F=reshape(F,size(f));
return


%% conjunction gradient solving linear equation
function [x,residnormvec,stepnormvec,cgiter] = ...
      Conjunction_Gradient_Test2(MR, L, alpha, r, height, width, depth, JtJ, lambda_0, lambda_k, max_cg_iter,cg_steptol,cg_residtol)
% Conjunction_Gradient_Test(MR,L,alpha,r,max_cg_iter,cg_steptol,cg_residtol)
% Solve linear system (K'*K + alpha*L)x = r using conjugate gradient iteration. 
K=length(JtJ);

cg_out_flag = 0;
nsq = max(size(r));
n = sqrt(nsq);
x = zeros(nsq,1);
resid = r(:);
residnormvec = norm(resid);
stepnormvec = [];
cgiter = 0;
stop_flag = 0;

%  CG iteration.

while stop_flag == 0
	cgiter = cgiter + 1;	
	dh = resid;	
	
	%  Compute conjugate direction p.	
	rd = resid'*dh;
	if cgiter == 1
		ph = dh;
	else
		betak = rd / rdlast;
		ph    = dh + betak * ph;
	end
	
	% Form product (K'*K + alpha*L)*ph.
	
	% KstarKp  =    integral_op(reshape(ph,n,n),k_hat_sq,n,n);
	% KstarKp  =    Mt_M(:).*ph;
	My_N    = size(ph,1)/depth;
%	KstarKp = [MR.MR1t(MR.MR1(ph(1:My_N)))' MR.MR2t(MR.MR2(ph(My_N+1:2*My_N)))' MR.MR3t(MR.MR3(ph(2*My_N+1:3*My_N)))' ];
%	Ahph    = KstarKp(:) + L(ph);

	ph = reshape(ph, [], depth);
	KstarKp = [];
	for iBand=1:depth
		mr = MR.MR{iBand};
		mrt = MR.MRt{iBand};
		KstarKp = [KstarKp mrt(mr(ph(:, iBand)))'];
	end
	ph = reshape(ph, [], 1);

	RX = I_DWT(ph, height, width, depth);		%size:[height*width,depth]
	RtHtH_RX = zeros(size(ph));
	for k=1:K
		tmp = ConvMul(RX(:), JtJ{k}, height, width, depth);
		RtHtH_RX = RtHtH_RX + lambda_k(k)*tmp;
	end
	RtHtH_RX = F_DWT(RtHtH_RX, height, width, depth) + alpha.*ph;
	Ahph = KstarKp(:) + RtHtH_RX;
	
	%  Update Delta_f and residual.    
	alphak = rd / (ph'*Ahph);
	x      = x + alphak*ph;
	resid  = resid - alphak*Ahph;
	rdlast = rd;
	
	residnorm = norm(resid(:));
	stepnorm = abs(alphak)*norm(ph)/norm(x);
	residnormvec = [residnormvec; residnorm];
	stepnormvec = [stepnormvec; stepnorm];
	
	%  Check stopping criteria.
	
	if cgiter >= max_cg_iter
		stop_flag = 1;
	elseif stepnorm < cg_steptol
		stop_flag = 2;
	elseif residnorm / residnormvec(1) < cg_residtol
		stop_flag = 3;
	end
	
	%  Display CG convergence information.
	
	if cg_out_flag == 1
		fprintf('   CG iter%3.0f, ||resid||=%6.4e, ||step||=%6.4e \n', ... 
			cgiter, residnormvec(cgiter), stepnormvec(cgiter))
		figure(1)
		subplot(221)
		semilogy(residnormvec/residnormvec(1),'o')
		title('CG Residual Norm')
		subplot(222)
		semilogy(stepnormvec,'o')
		title('CG Step Norm')
	end
	
  end %end for CG
    
    