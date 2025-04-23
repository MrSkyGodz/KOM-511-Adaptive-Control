% HW2_Q1
clc; clear;

%% PLANT
a = rand*10;
b = rand*10;

%% ADAPTATION PARAMETER
gamma = 1;

%% RUN SIMULATION
sampling_time = 0.01;

modelName = "hw2_1_mdl.slx";

simTime = 100;
inputMagnitude = 1;

sim(modelName);
