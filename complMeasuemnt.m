%% Init
clear all;
clc;
nMax = 256*256;
mMax = nMax*0.5;
m = 0.5
% nPoints = linspace(1, nMax);
% mPoints = linspace(1, mMax);
%% BasisPursuit
ComplBasisPursuit = @(n) n.^3;
yCBP = ComplBasisPursuit(nMax);
ComplVector = [yCBP];
%% OMP
ComplOMP = @(n, m) n*m;
yOMP = ComplOMP(nMax, mMax);
ComplVector(end+1) = yOMP;
%%