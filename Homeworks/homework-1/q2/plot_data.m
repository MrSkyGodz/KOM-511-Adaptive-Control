function  plot_data(data)
    figure(1);
    hold on;
    plot(data.ym,"DisplayName","Ym");
    plot(data.y,"DisplayName","Y");
    plot(data.uc,"DisplayName","Uc");
    legend()
    grid;

end

