clc; clear;

ts = 0.1;

% noise
noise_mean = 0;
noise_variance = 0.5;
noise_seed = round(rand*1e5);

A_des_s = [1 6 9];
B_des_s = 9;
gs = tf(B_des_s,A_des_s);
gz = c2d(gs, ts);
num = gz.Numerator;
num = num{1};
num = num(2:end);
den = gz.Denominator;
den = den{1};

Am = den;
Ao = [1 -0.15]; %faster pole than Am
X = [1 0.01]; %integral pole

theta_hat_init = [0.5 0.6 0.7 0.8];
% theta_hat_init = [1 1 1 1];
P0_init = eye(4)*1000;
lambda = 0.9;

sim("hw4_a_model.slx")