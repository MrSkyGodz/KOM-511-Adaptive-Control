% HW2_Q2
clc; clear;

%% PLANT
a = rand*10;
b = rand*10;

A = [0 1;
     0 -a];
B = [0; b];
C = [1 0;
     0 1];
D = [0; 0];

sys = ss(A,B,C,D);

%% MODEL
Am = [0 1;
     -5 -5];
Bm = [0; 5];
Cm = [1 0;
     0 1];
Dm = [0; 0];

sys_m = ss(Am,Bm,Cm,Dm);

%% ADAPTATION PARAMETERS
gamma1 = 1;
gamma2 = 1;

%% RUN SIMULATION
sampling_time = 0.01;

modelName = "hw2_2_mdl.slx";

simTime = 100;
inputMagnitude = 1;

sim(modelName);
