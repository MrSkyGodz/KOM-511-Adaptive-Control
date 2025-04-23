function  plot_all_data(data)
    
    keys = fields(data);

    figure(1);
    hold on;
    legend()
    grid;
    plot(data.(string(keys(1))).uc,"DisplayName","Uc");
    plot(data.(string(keys(1))).ym,"DisplayName","Ym");

    figure(2);
    hold on;
    legend()
    grid;
    for i = 1:length(keys)
       
        key = string(keys(i));
        s = split(key,"_");
        n = str2double(s(2))/1000;
        plot(data.(key).y,"DisplayName","Y gamma = " + n);
    end

    figure(3);
    hold on;
    legend()
    grid;
    for i = 1:length(keys)
       
        key = string(keys(i));
        s = split(key,"_");
        n = str2double(s(2))/1000;

        plot(data.(key).theta,"DisplayName","Theta gamma = " + n);
    end


  
end

