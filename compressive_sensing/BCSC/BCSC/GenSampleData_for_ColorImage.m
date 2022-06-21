function [M, Y, groups, X0] = GenSampleData_for_ColorImage(image,sparsity,sigma)

% To make it fast, the sampling Matrix is sparse.
% Y=M*R*X, here X is the coefficents of the Img, X=DWT*Img
% M is a randn matrix, R is IDWT which is the inverse DWT transform matrix.
% wroted by Liu, Peng, ceode, 2013.
% Changed by Jingbo Wei, Nanchang University, Nov. 2014

groups = []; 
L =3; 
h = daubcqf(8,'min');

[height width depth]=size(image);
X0 = reshape(double(image), [], depth);

wavelet_coefficent=[];
for iBand=1:depth
	wavelet_coefficent{iBand} = mdwt(double(image(:,:,iBand)),h,L);	%dwt using the Mallat algorithm
end

% Constrcuting sampling matrx M1,M2,M3 and sensing matrix MR.
N = round(height*width*sparsity);	%Number of valid pixels
K = 50;%min(4*N, N-1);					
for iBand=1:depth	
	%random sparsely observation matrix
	M1=sprand(N, height*width, K/height/width);
	M1(M1>0)=randn(1);
	
	MR{iBand} = @(z) A_IDWT(z,height,width,M1);		% MR equal to inverse wavelet transform
	MRt{iBand} = @(z) DWT_At(z,height,width,M1);		% MRt = DWT?
end

M.MR = MR;
M.MRt = MRt;

% 
Y=[];
for iBand=1:depth
	mr = M.MR{iBand};
	y = mr(wavelet_coefficent{iBand});
	y = y + sigma*randn(size(y));
	Y = [Y y(:)];
end
% figure, imshow(reshape(uint8(Y), height, width, depth))
return


function y=A_IDWT(z,nx,ny,B)
%%
L =3; 
h = daubcqf(8,'min');
x=midwt(reshape(z,nx,ny),h,L);
y=B*x(:);
% y=B(:).*x(:);
return


function y=DWT_At(z,nx,ny,B)
%%
L =3; 
h = daubcqf(8,'min');
x=B'*z(:);
% x=B(:).*z(:);
y=mdwt(reshape(x,nx,ny),h,L);
y=y(:);
return
