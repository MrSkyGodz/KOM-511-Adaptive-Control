%init file
clear; clc;

modelName = "model";
sample_time = 0.01;
simTime = 20;

k0 = 2;
gamma = 1.15;

out = sim(modelName);