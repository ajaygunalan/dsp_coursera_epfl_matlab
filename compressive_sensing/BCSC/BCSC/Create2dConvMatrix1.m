function sameConvMat = Create2dConvMatrix1(J, imageSize)
% get the left multiplying matrix sameConvMat such that B=conv(A,h) => B=sameConvMat*A
% J: 2-D convolution kernel matrix.
% mirrored center of J: [M/2,N/2]. not changed when mirroring.
% imageSize: the image size for J being spanned.

if (length(imageSize)>2)
	error('Error:: image size must be 2-D!');
	return
end

M1=imageSize(1);
N1=imageSize(2);
[M2, N2]=size(J);
M3=M1+M2-1;			%size of full convolution matrix
N3=N1;

% get mirrored matrix
JINV=J(:);
JINV=JINV(end:-1:1);
JINV=reshape(JINV, M2, N2);	%mirror kernel

% extended convolution matrix
fullConvMat = sparse(M3*N3, M3*N3);

%JINV(:,1) zeros(M1-M2+1,1) JINV(:,2) zeros(M1-M2+1,2) JINV(:3)
%convolution in vector form
filterVector = JINV(:,1)';
for k=2:N2
	filterVector = [filterVector zeros(1, M3-M2) JINV(:,k)'];
end	
lenFilter=length(filterVector);
filterVector = sparse(filterVector);
center_y = ceil(M2/2);	%center of convolution kernel
center_x = ceil(N2/2);
center = (center_x-1)*M3+center_y;
% center = lenFilter-center;

%前部分显示行
for iPixel=1:center
	fullConvMat(iPixel, 1:lenFilter-center+iPixel) = filterVector(center-iPixel+1:lenFilter);
end

% normal case
for iPixel=center:M3*N3-center
	fullConvMat(iPixel, iPixel-center+1:iPixel-center+lenFilter) = filterVector;
end

% remove extended rows and columns
validRow=false(M3, N3);
validRow(1:M1, 1:N1) = 1;
sameConvMat = fullConvMat(validRow, :);
sameConvMat = sameConvMat(:, validRow);

