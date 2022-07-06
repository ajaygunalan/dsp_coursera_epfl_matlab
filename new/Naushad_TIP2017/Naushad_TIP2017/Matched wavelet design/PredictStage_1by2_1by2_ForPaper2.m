function [t,hh,z_hh,fl,z_fl]=PredictStage_1by2_1by2_ForPaper2(x,hl,z_hl,hh,z_hh,d1)

%% Approximate and detailed coefficients
[a,d]=myRWT2(x,hl,z_hl,hh,z_hh,1,1,2);

%% Design t
A11=a;
A12=myConv(a,[1 0],2);

A1=[A11 A12];

b=d-d1;
A=A1(5:end-5,:);
b=b(5:end-5);

t=A\b;

hh=[-t(2) 1 -t(1)];   z_hh=3;
fl=[t(2) 1 t(1)];  z_fl=2;