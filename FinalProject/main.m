%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adaptive_yaw_quantized.m
%
%  Adaptive control of a lateral–yaw model with quantized measurements
%  Reproduces Fig. 1 (state-norm & Lyapunov-function trajectories)
%
%  Selivanov-Fradkov-Liberzon (Sys.&Contr.Lett. 88, 2016) – Example, Sec. 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

addpath(genpath("yalmip")); yalmip('clear');
addpath(genpath("sedumi"))

%% ---------- 1) plant parameters & uncertainty choice  ---------------
a22 = 1.3;   b1 = 19/15;   b2 = 19;

a11 = 0.75;                    % choose one point in [0.1,1.5]
a21 = 33;                      % choose one point in [25,40]

A = [ a11  1  0 ;
      a21 a22 0 ;
       0   1  0 ];

B = [ b1 ; 
      b2 ; 
      0  ];

C = [ 0 1 0 ;
      0 0 1 ];         % 2-output case

%% ---------- 2) passification via LMI -------------------
g = sqrt(2)/2 * [1;1];         % ‖g‖ = 1

[P,theta_star,eps_val,k_star] = compute_passification(A,B,C,g); % k_grid and eps_grid selection CRITICAL !!!

fprintf('Passification successful:\n  eps = %.4f\n  theta_star = [%g %g]^T\n  k_star = %.4f\n', ...
         eps_val, theta_star, k_star);
P

lambda_P = min(eig(P));
Lambda_P = max(eig(P));
Lambda_C = norm(C);

eps_sw  = 0.01;            % makalede "ε": küçük pozitif tasarım sabiti
theta_n = norm(theta_star);

%% ---------- 3) quantizer parameters ----------------------------------
Delta_e = 0.01;     % base quantization error bound
M       = 1;        % base range (|y|<=M means inside range)

% helper: uniform mid-rise quantizer with range μM and err ≤ μΔe
quantize = @(y,mu) min( max(y, -mu*M),  mu*M ) ...
                  + mu*Delta_e * round( (y - min(max(y,-mu*M),mu*M)) ...
                                        /(mu*Delta_e) );

%% ---------- 4) switching schedule (Table 1) --------------------------
V0       = 1e3;                        % başlangıç ellipsoidi
mu0      = 1;                          % başlangıç zoom
delta    = 2;                          % Thm-2 deki δ
zeta     = 0.05;                       % Vi < V_inf+ζ durdurma toleransı
gamma = 1e3;                           % high adaptation gain (paper)
Delta_w = 0.1;                         % disturbance bound

% --- Sigma (σ) ve ν, α, c_γ, c_e, c_w hesapla  ------------------------
sigma = (Lambda_C/(mu0*Delta_e*theta_n))*sqrt(V0/lambda_P);
alpha   = eps_val/2 + theta_n*mu0^2*Delta_e^2/V0;
nu    = eps_val/2 ...
      - (Lambda_C^2)/(sigma*lambda_P) ...
      - (theta_n + theta_n^2*sigma)*mu0^2*Delta_e^2/V0;
assert(nu>0,'ν≤0 → ε’yi büyüt veya parametreleri değiştir');

c_gamma = theta_n^2 / gamma;
c_w     = Lambda_P / (alpha*nu);
c_e     = 2/alpha*(theta_n + theta_n^2*sigma);

rho = c_e*mu0^2*Delta_e^2/V0;
assert(rho<1,'(16) bozuk: ρ≥1 → μ0,Δe,V0,σ ayarlarını değiştir');

% --- Switch takvimi otomatik üret  ------------------------------------
p.mu0=mu0; p.V0=V0; p.Delta_e=Delta_e; p.Delta_w=Delta_w;
p.alpha=alpha; p.gamma=gamma; p.sigma=sigma; p.theta_n=theta_n;
p.c_gamma=c_gamma; p.c_w=c_w; p.c_e=c_e; p.eps_sw=eps_sw;
p.lambda_P=lambda_P; p.zeta=zeta;

sched = build_switch_schedule(p);

fprintf('# of switches found: %d (0..%d)\n',length(sched.mu)-1,length(sched.mu)-1);

t_switch = round(sched.t, 3);
mu_vec = round(sched.mu, 3);
V_vec  = round(sched.V, 3);
a_vec = round(sched.a, 3);

% Kompakt tablo oluştur
switch_table = table((0:length(mu_vec)-1)', t_switch(1:end-1)', V_vec', mu_vec', a_vec', ...
    'VariableNames', {'i','t_i','V_i','mu_i','a_i'})

% t_switch = [  0     91.826  156.238 193.311 inf];
% mu_vec   = [  1     0.185   0.052   0.042];
% a_vec    = [300 49.029 4.056 2.595];
% 
% t_switch = [  0     91.826  120     156.238 175     193.311 inf];
% mu_vec   = [  1     0.185   0.12    0.052   0.045   0.042];
% a_vec    = [311     49.029 15      4.056   3       2.595];
% 
% t_switch = [  0     90.85   165.98  225.38  269.08  297.27  inf ];
% mu_vec   = [  1     0.38    0.158   0.09    0.076   0.074          ];
% a_vec    = [ 311.67 45.19   7.88    2.66    1.92    1.82           ];

%% ---------- 5) simulation setup --------------------------------------
tspan = [0 311];                       % seconds
x0 = [ 3 ;  2 ;  0 ];                  % pick any IC s.t. V<1000
theta0 = [0;0];                        % initial gain estimate
IC = [x0 ; theta0];                    % total state vector

% disturbance (bounded by Delta_w)
w_fun = @(t) Delta_w * [ sin(0.5*t) ; 0 ; 0 ];

% main ODE
odefun = @(t,state) yaw_adaptive_ode(t,state,A,B,C,g,P,...
                                     t_switch,mu_vec,a_vec,...
                                     quantize,w_fun,gamma,Delta_e,M);

opts = odeset('RelTol',1e-7,'AbsTol',1e-9);
[t,y] = ode45(odefun,tspan,IC,opts);

%% ---------- 6) post-processing ---------------------------------------
nx = 3;  nt = numel(t);
x = y(:,1:nx);
theta = y(:,nx+1:end);

% Lyapunov function V = x'Px + 1/gamma · ‖θ-θ*‖^2
V = zeros(nt,1);
for k=1:nt
    V(k) = x(k,:)*P*x(k,:).' + (norm(theta(k,:)'-theta_star)^2)/gamma;
end

%% ---------- 7) plotting (replicates Fig. 1) ---------------------------
figure(1); clf;
subplot(2,1,1);
plot(t, vecnorm(x,2,2),'LineWidth',1.2);
xlabel('t [s]'); ylabel('‖x(t)‖_2');
title('(a) state-vector norm');
ylim([0 0.7]); xlim([0 311]);
grid on;

subplot(2,1,2);
plot(t, V,'LineWidth',1.2);
xlabel('t [s]'); ylabel('V(x,\theta)');
title('(b) Lyapunov function');
ylim([0 1.5]); xlim([0 311]);
grid on;
