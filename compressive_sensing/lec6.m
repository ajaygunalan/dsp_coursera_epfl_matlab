clear all, close all, clc;

%% Solve y = theta * s for "s"
n = 1000;   % dimension for S
p = 200;    % number of measurments, dim(y)
Theta = randn(p, n);    % Normally distributed random matrix of size p, n
y = randn(p,1);

%% L1 mini norm solution s_L1
cvx_begin;
    variable s_L1(n); % n is the dimension of s
    minimize (norm(s_L1,1));
    subject to
        Theta*s_L1 == y;
cvx_end;

%% L2 mini norm solution s_L2
s_L2 = pinv(Theta)*y;

%% Plot
figure
subplot(3,2,1);
plot(s_L1, 'r', 'LineWidth', 1.5)
title('L1 solution', 'Color', 'k', 'FontSize', 24)
ylim([-.2 .2]), grid on

subplot(3,2,2);
plot(s_L2, 'c', 'LineWidth', 1.5)
title('L2 solution', 'Color', 'k', 'FontSize', 24)
ylim([-.2 .2]), grid on

% Histogram
subplot(3,2,[3 5]);
[hc,h] = hist(s_L1, [-0.1:0.01:0.1]);
bar(h, hc, 'r');
axis([-0.1 0.1 -50 1000]);

subplot(3, 2, [4 6]);
[hc,h] = hist(s_L2, [-0.1:0.01:0.1]);
bar(h, hc, 'c');
axis([-0.1 0.1 -20 400]);
% set(gcf, 'Position', [1500 100 1800 1000]);