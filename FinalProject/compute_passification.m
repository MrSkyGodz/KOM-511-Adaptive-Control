function [P,theta_star,eps_used, k_star] = compute_passification_v3(A,B,C,g)
% Automatic passification search   (lineer SDP)
% Returns P > 0, theta_star = k*g, and chosen eps_used

n = size(A,1);

% k_grid   = logspace(-3,3,120);       % 0.001 … 1000
% k_grid   = logspace(0,1,100);
k_grid   = 5.3;
% eps_grid = [0.02 0.05 0.1 0.2 0.5];  % candidate ε values
% eps_grid = [1 2 5 8 10];  % candidate ε values
eps_grid = [0.25 0.3 0.4 0.5 0.6];  % candidate ε values

P = []; theta_star = []; eps_used = [];

for k = k_grid
    theta = k*g;
    Abar  = A - B*theta'*C;

    for epsc = eps_grid
        Pvar = sdpvar(n,n,'symmetric');
        F    = Pvar*Abar + Abar'*Pvar + epsc*Pvar;

        Cstr = [Pvar >= 1e-6*eye(n), ...
                F    <= -1e-6*eye(n), ...
                Pvar*B == C'*g];

        opt  = sdpsettings('solver','sedumi','verbose',0);
        diagnostics = optimize(Cstr,[],opt);

        % <<== değişen satır: artık struct kontrolü
        if diagnostics.problem == 0
            P          = value(Pvar);
            theta_star = theta;
            eps_used   = epsc;
            k_star     = k;
            return
        end
    end
end
error('Passification infeasible on given grids; change g or enlarge grids.');
end
