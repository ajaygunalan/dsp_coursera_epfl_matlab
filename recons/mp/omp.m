%% Assume X is unkown;
clear all;
clc;
%x = [0; 1; 0; 2];
x = [0; 0; 0; 0];
phi =[1 2 3 4; 5 6 7 8;];
y = [10; 22];
a = [0; 0; 0; 0];
for i=1:4
    a(i,1) =dot(y,phi(:,i));
end
phiCol = zeros(2, 4);
phiCol(:,4) = phi(:,4) ;
b = y - phiCol*x;
