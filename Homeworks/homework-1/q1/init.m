%init file
clear; clc;

modelName = "model";
sample_time = 0.01;
simTime = 20;

k0 = 2;
gamma = 0.5;

out = sim(modelName);

name = "gamma_" + gamma*1000;

data.(name).ym = out.ym;
data.(name).theta = out.theta;
data.(name).y = out.y;

sys_theta = tf([4*gamma,4*gamma],[1 1 2*gamma]); %5.12

[temp_data,time]= step(sys_theta);
data.(name).model = timeseries(temp_data,time);



