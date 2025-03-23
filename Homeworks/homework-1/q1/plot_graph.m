function  plot_graph(data)

    
    figure(1);
    hold on;
    plot(data.ym,"DisplayName","Ym");
    plot(data.y,"DisplayName","Y");
    legend()
    grid;
    figure(2);
    hold on;
    plot(data.model,"DisplayName","Model Theta");
    plot(data.theta,"DisplayName","Simulink Theta");
    legend()
    grid;
end

