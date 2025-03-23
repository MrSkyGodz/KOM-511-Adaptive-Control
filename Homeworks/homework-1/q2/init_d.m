%init file
clear; clc;

modelName = "model_d";
sample_time = 0.001;
simTime = 200;

b = 1;
gamma = 1;
sineAmp = 1000;

out = sim(modelName);