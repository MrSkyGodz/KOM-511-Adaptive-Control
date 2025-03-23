%init file
clear; clc;

modelName = "model";
sample_time = 0.01;
simTime = 100;
is_normalize = 1;
loss_function_selector = 0;
b = 1;
gamma = 1;
sineAmp = 1000;

out = sim(modelName);