%MEGHNA GUPTA
%2016056
%PS-ASSIGNMENT 2
% https://github.com/gupta-meghna64/Orthogonal-Matching-Pursuit-Algorithm/blob/master/algo_omp.m
%FUNCTION algo_omp solves y = Ax, takes the input parameters y, A, k where
%y is the output field, A is the dataset field and k is the sparsity. It
%return the solution of x.
% watch this video
% https://www.youtube.com/watch?v=ZG0PCzsA4XY&t=483s
function  x = algo_omp(k, A, y)
    xbeg = zeros(size(A,2),1);
    support=[];
    temp=y;
    count = 1;
    while count < k+1
        ST = abs(A' * temp);
        [a, b] = max(ST);
        %support is colum that has max projection 
        support = [support b];
        % https://in.mathworks.com/help/matlab/ref/mldivide.html
        % x = A\B solves Ax=B
        xfinal = A(:, support)\y;
        % The above line is equal to inv(A1'*A1)*A1'*y where A1 = A(:,support);
        temp = y-A(:,support) * xfinal;
        count = count + 1;
    end
    x = xbeg; 
    t = support';
    x(t) = xfinal;
end