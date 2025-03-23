%init file
clear; clc;

modelName = "model_b";
sample_time = 0.01;
simTime = 100;

b = 10*rand(1)
gamma = 1;
sineAmp = 1;

out = sim(modelName);