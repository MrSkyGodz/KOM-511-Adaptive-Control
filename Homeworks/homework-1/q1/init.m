%init file
clear; clc;

modelName = "model";
sample_time = 0.01;
simTime = 20;

k0 = 2;
gamma = 0.25;

out = sim(modelName);

sys_theta = tf([1],[1 1 0.25]);
step(sys_theta)