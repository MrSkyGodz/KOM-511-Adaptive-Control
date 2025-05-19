function out = integralAction(in)
    
    in = in';
    R0 = in(1:2);
    S0 = in(3:4);
    theta_hat = in(5:8);
    X = in(9:10);

    A = [1 theta_hat(1:2)];
    B = theta_hat(3:4);

    Y = -( (1 + X(2)) * sum(R0) ) / (sum(B));
    Rnew = conv(X,R0) + [0 conv(Y,B)];
    Snew = conv(X,S0) - conv(Y,A);

    out = [Rnew, Snew];
end
