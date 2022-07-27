%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author                 Zhang Cheng, Yang Hairong
%%Modified time          2010/07/23
%%function               Code for Backtracking Itetative Hard Thresholding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
close all

%%
N	= 512; 
M	= 256;  
K	= 50;   
s0              = zeros(N,1);
RANP            = randperm(N);
s0(RANP(1:K))   = sign(randn(K,1));
% s0(RANP(1:K))   = randn(K,1);
tol = 1e-6;
A   = randn(M,N);
y   = A*s0;

mu  = 0.01;
sol = BIHT(A,K,y,mu);

%%
subplot(211)    
plot(s0)
subplot(212)
plot(sol)