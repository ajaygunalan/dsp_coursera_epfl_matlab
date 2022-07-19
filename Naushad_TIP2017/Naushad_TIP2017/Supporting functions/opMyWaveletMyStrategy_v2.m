function op = opMyWaveletMyStrategy_v2(hc,h1c,hr,h1r,n1,n2)

Wc=WaveletMatrix3L(n1,hc,h1c);
Wr=WaveletMatrix3L(n2,hr,h1r);

Wcin=inv(Wc);
Wrin=inv(Wr);

op = @(x,mode) opMyWaveletMyStrategy_v2_internel(Wcin,Wrin,n1,n2,x,mode);


function y = opMyWaveletMyStrategy_v2_internel(Wrin,Wcin,n1,n2,x,mode)
% checkDimensions(m,n,x,mode);
if mode == 0
   y = {n1*n2,n1*n2,[0,1,0,1],{'Restriction'}};
elseif mode==1
        temp1=reshape(x,n1,n2);
        y=Wcin*temp1*Wrin';
        
        y=y(:);
    else
        temp1=reshape(x,n1,n2);
        y=Wcin'*temp1*Wrin;
        y=y(:);
end
