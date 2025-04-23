%init file
clear; clc;

modelName = "model";
sample_time = 0.001;
simTime = 40;
b = 1;
is_normalize = 0;
loss_function_selector = 0;
start_gamma_val = 5;
sineAmp = 1;


gamma = start_gamma_val;
out = sim(modelName);
name = "gamma_" + gamma*1000;
data.(name).uc = out.uc;
data.(name).ym = out.ym;
data.(name).theta = out.theta;
data.(name).y = out.y;
plot_all_data(data)
