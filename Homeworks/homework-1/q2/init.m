%init file
clear; clc;

modelName = "model";
sample_time = 0.01;
simTime = 20;

b = 1;
gamma = 6;
a_m = 1;

out = sim(modelName);