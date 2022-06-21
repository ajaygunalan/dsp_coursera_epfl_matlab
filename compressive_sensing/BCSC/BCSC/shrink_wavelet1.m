function  [dk, alpha]=shrink_wavelet1(x, height, width, depth)

	Xs = reshape(x, height, width, depth); 
	
	LH1 = Xs(end/2+1:end/1, 1:end/2);
	HL1 = Xs(1:end/2, end/2+1:end/1);
	LH=[LH1(:)' HL1(:)']';
	ALPHA=sqrt(median(abs(LH))/0.6745);
	
	ALPHA = ones(size(Xs))*ALPHA;
	alpha   =    1./ALPHA(:);
	X1      =    abs(Xs);
	X2      =    X1-ALPHA;
	DK      =    (Xs./X1).*(abs(X2)+X2)./2;
	dk      =    DK(:);
 
return
