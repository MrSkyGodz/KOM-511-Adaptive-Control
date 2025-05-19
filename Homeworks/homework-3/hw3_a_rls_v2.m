clear; clc;

sample_time = 1;     

a = -0.8;
b = 0.5;
c = 0;
% c = -0.5;

% noise
noise_mean = 0;
noise_variance = 0.5;
noise_seed = round(rand*1e5);

sim_time = 3000;
if c==0
    phi_0 = zeros(2,1);
    P_0 = eye(2,2) * 100;
    Theta_0 = [0;0];
    sim("hw3_a_rls_model_c0");
    % sim("hw3_a_RLS_lambda_model_c0");
    % sim("hw3_a_LMS_model_c0");
    % sim("hw3_a_PA_model_c0");
    % sim("hw3_a_SA_model_c0");
else
    phi_0 = zeros(3,1);
    P_0 = eye(3,3) * 100;
    Theta_0 = [0;0;0];
    % sim("hw3_a_ELS_model_c05");
    % sim("hw3_a_rls_model_c5");
    % sim("hw3_a_ELS_model_extended_c05");
end
