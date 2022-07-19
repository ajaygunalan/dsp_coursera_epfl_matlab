function W=WaveletMatrix3L(N,varargin)

if ischar(varargin{1})
    [h,h1,~,~]=wfilters(varargin{1});
    W1=WaveletMatrix1L(N,varargin{1});
    W2=eye(N);
    W2(1:N/2,1:N/2)=WaveletMatrix1L(N/2,varargin{1});
    W3=eye(N);
    W3(1:N/4,1:N/4)=WaveletMatrix1L(N/4,varargin{1});
    W=W3*W2*W1;
else
    h=varargin{1};    h1=varargin{2};
    W1=WaveletMatrix1L(N,h,h1);
    W2=eye(N);
    W2(1:N/2,1:N/2)=WaveletMatrix1L(N/2,h,h1);
    W3=eye(N);
    W3(1:N/4,1:N/4)=WaveletMatrix1L(N/4,h,h1);
    W=W3*W2*W1;
end
