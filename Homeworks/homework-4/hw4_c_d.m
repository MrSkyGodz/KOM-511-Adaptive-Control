clear; clc;
z=tf('z',0.1);
Gz=0.5*(z+1)/(z^2-1.7*z+0.8);
figure(11)
step(Gz)

%% Plant ve model katsayıları
Ts   = 0.1;
a1   = -1.7;  a2   = 0.8;
b0   =  0.5;  b1   = 0.5;

am1  = -1.4816;  am2  = 0.5488;
t0   = 1 + am1 + am2;

%% Simülasyon ayarları
N     = 400;
u     = zeros(1,N);  y  = zeros(1,N);
uf    = zeros(1,N); yf = zeros(1,N);
e_int = zeros(1,N);     % Hata integrali

theta = zeros(5,1);       % [r0 r1 s0 s1 Ki]'
P     = 1e4*eye(5);
lam   = 1;

%% Referans işareti
uc = zeros(1,N);
uc( 1:50)   =  1;
uc(51:100)  = -1;
uc(101:150) =  1;
uc(151:200) = -1;
uc(201:250) =  1;
uc(251:300) = -1;
uc(301:350) =  1;
uc(351:400) = -1;


%% Main döngü
for k = 3:N-1
    % Prefiltre
    uf(k) = u(k-1) - am1*uf(k-1) - am2*uf(k-2);
    yf(k) = y(k-1) - am1*yf(k-1) - am2*yf(k-2);

    % Hata ve integral terimi
    e      = uc(k) - y(k);
    e_int(k) = e_int(k-1) + e*Ts;

    % Regresyon vektörü
    phi = [uf(k) uf(k-1) yf(k) yf(k-1) e_int(k)]';

    % RLS güncellemesi
    K     = P*phi/(lam + phi'*P*phi);
    eps   = y(k) - phi'*theta;
    theta = theta + K*eps;
    P     = (P - K*phi'*P)/lam;

    % Kontrol yasası
    r0 = max(theta(1)/0.9,  1e-1);  % Safety
    r1 = theta(2)/1.1;  s0 = theta(3);  s1 = theta(4);  Ki = theta(5);
    r0_array(k)=r0;
    r1_array(k)=r1;
    s0_array(k)=s0;
    s1_array(k)=s1;
    Ki_array(k)=Ki;
   
    u(k) = ( t0*uc(k) - s0*y(k) - s1*y(k-1) - r1*u(k-1) - Ki*e_int(k) ) / (r0);

    disturbance = 0;
    if (k*Ts >= 15)
        disturbance = 0.05;  % 15. saniyeden itibaren sabit bozucu
    end
    y(k+1) = -a1*y(k) - a2*y(k-1) + b0*u(k) + b1*u(k-1) + disturbance;

    
end

%% Grafik
figure(1);
t = (0:N-1)*Ts;
subplot(2,1,1), plot(t, uc, '--', t, y), xlabel('Time [s]'), ylabel('y, u_c')
legend('u_c', 'y'), grid on
subplot(2,1,2), stairs(t, u), xlabel('Time [s]'), ylabel('u'), grid on
% figure(2)
% plot(t(2:end),r0_array,'--')
% figure(3)
% plot(t(2:end),r1_array,'--')
% figure(4)
% plot(t(2:end),s0_array,'--')
% figure(5)
% plot(t(2:end),s1_array,'--')
% figure(6)
% plot(t(2:end),Ki_array,'--')
% figure(7)
% plot(t,uc,'--')
% figure(8)
% plot(t,y,'--')
% figure(9)
% plot(t,u,'--')
% figure(10)
% plot(t,e_int,'--')