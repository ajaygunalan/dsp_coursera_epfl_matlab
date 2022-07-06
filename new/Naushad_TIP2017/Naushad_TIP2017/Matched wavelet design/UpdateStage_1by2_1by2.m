function [s,hl,z_hl,fh,z_fh]=UpdateStage_1by2_1by2(x,t,hl,z_hl,hh,z_hh,fl,z_fl)

%% Approximate and detailed coefficients
[a,d]=myRWT2(x,hl,z_hl,hh,z_hh,1,1,2);

%% Design update stage filter
b1=a;
A11=d;
A12=myConv(d,[0 1],1);

b2=myUpsample2(b1,2);
A21=myUpsample2(A11,2);
A22=myUpsample2(A12,2);

b3=myConv(b2,fl,z_fl);
A31=myConv(A21,fl,z_fl);
A32=myConv(A22,fl,z_fl);

b=x-b3;
A=[A31 A32];

A=A(5:end-5,:);
b=b(5:end-5);
s=A\b;
hl=[-s(1)*t(2) s(1) 1-s(1)*t(1)-s(2)*t(2) s(2) -s(2)*t(1)]; z_hl=3;
fh=[-s(1)*t(2) -s(1) 1-s(1)*t(1)-s(2)*t(2) -s(2) -s(2)*t(1)];  z_fh=2;
