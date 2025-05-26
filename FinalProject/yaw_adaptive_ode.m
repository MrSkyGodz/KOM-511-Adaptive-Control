%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------------ local function: system dynamics ---------------------------
function dst = yaw_adaptive_ode(t,s,A,B,C,g,P,...
                                 t_sw,mu_v,a_v,quantize,w_fun,gamma,De,M)

% unpack combined state
x     = s(1:3);
theta = s(4:5);

% determine active switching index
k = find(t >= t_sw, 1, 'last');    % piecewise-constant μ and a
mu = mu_v(k);
a  = a_v(k);

% output, quantized measurement
y_full = C*x;                 % 2×1
y_q    = quantize(y_full,mu); % quantizer

% control input
u = -theta.' * y_q;

% disturbance
w = w_fun(t);

% plant dynamics
dx = A*x + B*u + w;

% adaptation law
dtheta = gamma * ( y_q * (y_q.'*g) ) - a*theta;

dst = [dx ; dtheta];
end
