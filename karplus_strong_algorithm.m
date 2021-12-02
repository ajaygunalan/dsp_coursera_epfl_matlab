clc
clear all
close all
x=rand(1,100);
x=[x zeros(1,5000)];
num=[1];
den=[1 zeros(1,99) -0.5 -0.5];
y=filter(num,den,x);
sound(y,44100)
% You can change the random sequence range and according to that change the no. of zeros in denominator of the filter and play ---
% clc
% clear all
% close all
% x=rand(1,500);
% x=[x zeros(1,10000)];
% num=[1];
% den=[1 zeros(1,499) -0.5 -0.5];
% y=filter(num,den,x);
% sound(y,44100)