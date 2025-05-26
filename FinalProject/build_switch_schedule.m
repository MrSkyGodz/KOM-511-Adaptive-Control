function sched = build_switch_schedule_v3(params)
% params: struct (mu0,V0,Delta_e,Delta_w,alpha,gamma,sigma,theta_n,...
%                 c_gamma,c_w,c_e,eps_sw,lambda_P,zeta)

mu0  = params.mu0;  V0 = params.V0;    epsw = params.eps_sw;
Delta_e = params.Delta_e;  Delta_w = params.Delta_w;
alpha= params.alpha; sigma=params.sigma; gamma=params.gamma;
theta_n=params.theta_n;   c_gamma=params.c_gamma;
c_w  = params.c_w;        c_e    = params.c_e;    zeta=params.zeta;

rho  = c_e*mu0^2*Delta_e^2/V0;
Vinf = (c_gamma + c_w*Delta_w^2 + epsw)/(1 - rho);

Vi=V0;  mu=mu0;  ti=0;  i=0;
V  = Vi; MU = mu;
A  = alpha + gamma*mu^2*Delta_e^2*(sigma+1/theta_n);
T  = ti;

while Vi > Vinf + zeta
    i=i+1;
    Vi = c_gamma + c_w*Delta_w^2 + c_e*mu^2*Delta_e^2 + epsw;
    mu = mu0*sqrt(Vi/V0);
    ai = alpha + gamma*mu^2*Delta_e^2*(sigma+1/theta_n);
    ti = ti + (1/alpha)*log( ...
        (V(end)-c_gamma-c_w*Delta_w^2-c_e*MU(end)^2*Delta_e^2)/epsw );

    V(end+1)=Vi; MU(end+1)=mu; A(end+1)=ai; T(end+1)=ti;
    
    if i>1000, warning('>1000 switches – kontrol parametrelerini gözden geçir'); break; end
end

sched.t  = [T inf];
sched.mu = MU;
sched.a  = A;
sched.V  = V;
end
