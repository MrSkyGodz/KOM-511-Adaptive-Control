%init file
clear; clc;

modelName = "model_a";
sample_time = 0.01;
simTime = 100;

b = 1;
gamma = 1;
sineAmp = 1; %incele

out = sim(modelName);