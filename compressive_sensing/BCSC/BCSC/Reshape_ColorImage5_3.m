function [Img_MS] = Reshape_ColorImage5_3(X,height,width,depth)
    
	L =3;
	h = daubcqf(8,'min');
	
    Img_MS = zeros(height, width, depth);
	for iBand=1:depth
		Img1 = X(:,iBand);    
		Img_MS(:,:,iBand)=reshape(Img1,[height width]);
		Img_MS(:,:,iBand)=abs(midwt(Img_MS(:,:,iBand),h,L));
	end  




    
