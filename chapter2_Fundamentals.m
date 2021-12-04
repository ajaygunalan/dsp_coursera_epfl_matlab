%% 2.2 Reading Images 
f = imread('cameraman.jpg');
size(f, 1);
whos f;
%% 2.3 Displaying Images
%imshow(f), figure, 
%imshow(f, []), figure,
%imtool(f)
%% 2.4 Writing Images
imwrite(f, 'camNew.jpg')
%% 2.5 Data Classes
s = class(f);
%% 2.6 Image types
A = [1, 0; 0, 1];
islogical(A);
B = logical(A);
islogical(B);
%% 2.7 Converting between data classes
%c = double(f);
%class(c);
%f = [-0.5, 0.5; 0.75, 1.5];
%g = im2uint8(f);
%h = uint8([25 50; 128 200]);
%g = im2double(h);
g = imbinarize(f);
g1 = g(:,:,1);
%show(g1);
isa(g1,'uint8');
[fp, revertClass] = tofloat(f);
savedClass = str2func(class(f));
%% 2.8 Array Indexing
v = [1 3 5 7 9];
size(v);
w = v.';
size(w);
v(1:2:end);
w(1:2:end);
v(end:-2:1);
a = linspace(1, 5, 6);
A = [1 2 3;4 5 6; 7 8 9];
T2 = A([1 2], [1 2 3]);
T2 = A(1:2, 1:3);
E = A([1 3],[3 2]);
C3 = A(:,3);
R2 = A(2,:);
B = A;
B(:,3)=0;
A(end, end);
A(end, end-2);
A(2:end, end:-2:1); 
T2;
v = T2(:);
colSums = sum(A);
totalSum = sum(colSums);
totalSum = sum(A(:));
D = logical([1 0 0;0 0 1;0 0 0]);
A(D);
A(D) = [30 40];
A(D) = 100;
H = hilb(4);
H(2, 4);
H([2, 4]);
r = [1 2 4];
c = [3 4 3];
H([1 2],[3 4]); %Extracts a sub-image
M = size(H, 1);
linearIndices = M*(c-1)+r;
H(linearIndices);
linearIndices = sub2ind(size(H), r, c);
[r c] = ind2sub(size(H), linearIndices);
f = imread('rose1024.tif');
%imshow(f);
%A = [1 0 1 0; 0 1 0 1; 1 0 1 0]
%Ap = A(2,:)
fp = f(end:-1:1,:);
%imshow(fp);
fc = f(1:10:end, 1:10:end);
%imshow(fc);
fd = f(234:578,234:578);
fv = f*0.9;
%imshow(fv);
%plot(f(987,:))
R(1:3,1:3,1:3) = ones(1, "uint8");
R(:);
%plot(f(size(f,1)/2,:));
A = [1 0 0;0 3 4;0 2 0];
S = sparse(A);
Original = full(S)
%% 2.9 Intro to MATLAB
A = 5*ones(3,3,'uint8');
magic(3);
B = randn(256,256);
A = [1 2; 3 4];
B = [-1 10;-2 16];
C=A+B;
b=10;
C=A+b;
A = [1 2;3 4;5 6;7 8];
B = [10; 20; 30; 40];
C = A+B;
A = [5; 10];
B = [1 2 3];
C = A+B;
max(A);
max(A, B);
f = [1 2; 3 4];
g = [1 2;2 1];
[s,smax,smin] = imblend(f,g);
a = uint16(100);
b = uint16(200);
w = imlincomb(0.5,a,0.5,b);
A = [1 2 3;4 5 6;7 8 9];
B = [0 2 4;3 5 6;3 4 9];
A == B;
A >= B;
get(0,'Format');
format short;
A = [1 2; 8 9;11 12];
numel(A);
h = @sin;
h(pi/4);
g = @(x) x.^2;
r = @(x,y) sqrt(x.^2 + y.^2);
g(3);
r(3, 4);
h = @(x) exp(-x.^2).*log(x).^2;
q = integral(h,0,Inf);
M = 1200;
A = rand(M);
B = rand(M);
h = @() A + B;
timeit(h)
%% 2.10 Plotting
%% 2.11 Interactive I/O