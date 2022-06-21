% shrink the wavelet coefficients of multi-channle image
% by exploring the similarity of detail coefficients.

% Note: This function will be revised in future version.

function  [dk, alpha]=shrink_wavelet3(x, height, width, depth)

	Xs         =     reshape(x, height, width, depth); 

% 	HH1_1      =     Xs(end/2+1:end/1,end/2+1:end/1,1);
% 	HH1_2      =     Xs(end/2+1:end/1,end/2+1:end/1,2);
% 	HH1_3      =     Xs(end/2+1:end/1,end/2+1:end/1,3);

% 	HH2_1      =     Xs(end/4+1:end/2,end/4+1:end/2,1);
% 	HH2_2      =     Xs(end/4+1:end/2,end/4+1:end/2,2);
% 	HH2_3      =     Xs(end/4+1:end/2,end/4+1:end/2,3);
% 
% 	HH3_1      =     Xs(end/8+1:end/4,end/8+1:end/4,1);
% 	HH3_2      =     Xs(end/8+1:end/4,end/8+1:end/4,2);
% 	HH3_3      =     Xs(end/8+1:end/4,end/8+1:end/4,3);
	
	for iBand=1:depth
		HH1_{iBand} = Xs(end/2+1:end/1,end/2+1:end/1, iBand);
		HH2_{iBand} = Xs(end/4+1:end/2,end/4+1:end/2, iBand);
		HH3_{iBand} = Xs(end/8+1:end/4,end/8+1:end/4, iBand);
	end

	HH1 = zeros(2, 2); HH2 = HH1; HH3 = HH2;
	for i=1:depth
		for j=i+1:depth
			HH1 = HH1 + cov(HH1_{i}(:), HH1_{j}(:));
			HH2 = HH2 + cov(HH2_{i}(:), HH2_{j}(:));
			HH3 = HH3 + cov(HH3_{i}(:), HH3_{j}(:));
		end
	end
	
% 	HH1         =     cov(HH1_1(:),HH1_2(:))+cov(HH1_1(:),HH1_3(:))+cov(HH1_2(:),HH1_3(:));
	alpha1      =     ((min(HH1(1,1),HH1(2,2))-HH1(1,2))/3).^0.5;
% 	HH2         =     cov(HH2_1(:),HH2_2(:))+cov(HH2_1(:),HH2_3(:))+cov(HH2_2(:),HH2_3(:));
	alpha2      =     ((min(HH2(1,1),HH2(2,2))-HH2(1,2))/3).^0.5; 
% 	HH3         =     cov(HH3_1(:),HH3_2(:))+cov(HH3_1(:),HH3_3(:))+cov(HH3_2(:),HH3_3(:));
	alpha3      =      ((min(HH3(1,1),HH3(2,2))-HH3(1,2))/3).^0.5;

	ALPHA   =    zeros(size(Xs));
	ALPHA(:,:,1)   =    alpha1; 
	ALPHA(:,:,2)   =    alpha2; 
	ALPHA(:,:,3)   =    alpha3; 
	
	alpha   =    1./ALPHA(:);
	X1      =    abs(Xs);
	X2      =    X1-ALPHA;
	DK      =    (Xs./X1).*(abs(X2)+X2)./2;
	dk      =    DK(:);
 
return
