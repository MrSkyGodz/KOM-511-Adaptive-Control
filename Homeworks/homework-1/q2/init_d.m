%init file
clear; clc;

modelName = "model";
sample_time = 0.001;
simTime = 40;
b = 1;

is_normalize = 1;
loss_function_selector = 0;

gamma = 5;
sineAmp = 1;

iter = 12;

for i = 1:iter
    % gamma = 0.1*2^(i-1)/2;
    sineAmp = 0.1*2^(i-1)/2;
    
    out = sim(modelName);
    
    name = "amplitude_" + sineAmp*1000;
    
    data.(name).uc = out.uc;
    data.(name).ym = out.ym;
    data.(name).theta = out.theta;
    data.(name).y = out.y;

end
plot_all_data(data)