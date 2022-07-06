function op = opBernoulli(m,n)

idx=randperm(m*n);
idx=idx(1:m*n/2);
B=ones(m,n);
B(idx)=-1;
% B=B/(m*n);
op   = @(x,mode) opBernoulli_intrnl(B,m,n,x,mode);



function y = opBernoulli_intrnl(B,m,n,x,mode)

if mode == 0
   y = {m,n,[0,1,0,1],{'Bernoulli'}};
elseif mode == 1
    y=B*x;
else
   y=B'*x;
end
