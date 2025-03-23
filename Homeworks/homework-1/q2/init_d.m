%init file
clear; clc;

modelName = "model_d";
sample_time = 0.001;
simTime = 200;

b = 1;
gamma = 0.05;
sineAmp = 1;

out = sim(modelName);