%init file
clear; clc;

modelName = "model";
sample_time = 0.01;
simTime = 100;
is_normalize = 0;
loss_function_selector = 0;

b = 1;
gamma = 1;
sineAmp = 1; %incele

out = sim(modelName);