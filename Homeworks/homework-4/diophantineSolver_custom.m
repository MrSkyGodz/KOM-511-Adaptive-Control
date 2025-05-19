function out = diophantineSolver_custom(in)

    theta_hat = in(1:4);
    A = [1, theta_hat(1), theta_hat(2)]; 
    B = [theta_hat(3), theta_hat(4)];
    Am = in(5:7);
    Ao = in(8:9);

    B_roots = real(roots(B));
    B_plus_roots = B_roots(abs(B_roots) < 1);   % Stable zeros
    B_minus_roots = B_roots(abs(B_roots) >= 1); % Unstable zeros
    B_plus = poly(B_plus_roots);                % Monic B+
    B_minus = poly(B_minus_roots) * B(1);       % B- with gain
    
    beta = (sum(Am)) / (sum(B_minus));
    
    am1 = Am(2);
    am2 = Am(3);
    b0 = B(1);
    b1 = B(2);
    ao = Ao(2);
    a1 = A(2);
    a2 = A(3);
    
    r1 = (ao*am2*b0^2 + (a2 - am2 - ao*am1)*b0*b1 + (ao + am1 - a1)*b1^2) / ...
        (b1^2 - a1*b0*b1 + a2*b0^2);
    R = [1 r1];
    
    s0 = (b1*(ao*am1 - a2 - am1*a1 + a1^2 + am2 - a1*ao)) / ...
        (b1^2 - a1*b0*b1 + a2*b0^2) +...
        (b0*(am1*a2 - a1*a2 - ao*am2 + ao*a2)) /...
        (b1^2 - a1*b0*b1 + a2*b0^2);
    
    s1 = (b1*(a1*a2 - am1*a2 + ao*am2 - ao*a2)) / ...
        (b1^2 - a1*b0*b1 + a2*b0^2) + ...
        (b0*(a2*am2 - a2^2 - ao*am2*a1 + ao*a2*am1)) / ...
        (b1^2 - a1*b0*b1 + a2*b0^2);
    S = [s0 s1];

    T = beta*Ao;
    
    out = [R, S, T];
end