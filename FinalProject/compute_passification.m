function [P,theta_star,eps_used, k_star] = compute_passification(A,B,C,g,k_grid,eps_grid)
% Automatic passification search   (lineer SDP)
% Returns P > 0, theta_star = k*g, and chosen eps_used

n = size(A,1);

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
