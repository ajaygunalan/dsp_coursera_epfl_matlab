function [a,d]=myRWT2(x,hl,z_hl,hh,z_hh,q1,q2,M)

%% This function finds the approximate and detailed coefficients when input 
% signal is passed through the rational filterbank
% Output
% a- approximate coefficients
% d- detailed cooefficients
% Input
% x- input signal
% hl,hh- lowpass and highpass filters'
% q1,q2- Upsampling factor on analysis side
% M- downsampling factor on analysis side( as per TSP paper)

a1 = myUpsample2(x,q1);
a2 = myConv(a1,hl,z_hl);
a = myDownsample2(a2,M);

d1 = myUpsample2(x,q2);
d2 = myConv(d1,hh,z_hh);
d = myDownsample2(d2,M);
