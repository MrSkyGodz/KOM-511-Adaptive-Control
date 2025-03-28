%init file
clear; clc;

modelName = "model";

sample_time = 0.01;
simTime = 30;
iter = 1;
k0 = 2;
gamma_start_val = 0.25;


for i = 1:iter
    gamma = gamma_start_val*2^(i-1)/2;
    
    out = sim(modelName);
    
    name = "gamma_" + gamma*1000;
    
    data.(name).uc = out.uc;
    data.(name).ym = out.ym;
    data.(name).theta = out.theta;
    data.(name).y = out.y;
    
    sys_theta = tf([4*gamma,4*gamma],[1 1 2*gamma]); %5.12
    
    [temp_data,time]= step(sys_theta);
    data.(name).model = timeseries(temp_data,time);
end

% plot_data(data.(name));
% plot_all_data(data);


