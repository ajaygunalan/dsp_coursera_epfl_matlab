function  dk=shrink_wavelet_PCA(x,alpha, height, width, depth)


% x1=abs(x);
% x2=x1-alpha;
% dk=(x./x1).*(x1+x2)./2;

%global Img;

	Xs = reshape(x,[height*width depth]);
	[COEFF,Xs_,latent,t2] = princomp(Xs);
	ALPHA = zeros(size(Xs));
	ALPHA(:,:,:) = alpha;
	X1   = abs(Xs_);
	X2   = X1-ALPHA; 
	DK   = (Xs_./X1).*(abs(X2)+X2)./2;
	Tem4 = bsxfun(@plus, DK*inv(COEFF),mean(Xs,1));
	dk   = Tem4(:);
 
return