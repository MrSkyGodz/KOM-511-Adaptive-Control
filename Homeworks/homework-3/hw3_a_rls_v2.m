clear; clc;

sample_time = 1;     

a = -0.8;
b = 0.5;
% c = 0;
c = -0.5;

% noise
noise_mean = 0;
noise_variance = 0.5;
noise_seed = round(rand*1e5);

sim_time = 1000;
if c==0
    P_0 = eye(2,2) * 100;
    Theta_0 = [0;0];
    sim("hw3_a_rls_model_c0");
else
    P_0 = eye(3,3) * 100;
    Theta_0 = [0;0;0];
    sim("hw3_a_rls_model_c05"); 
end
