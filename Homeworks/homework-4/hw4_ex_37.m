clear; clc;
%% Bitki ve model katsayıları
Ts   = 0.5;
a1   = -1.6065;  a2   = 0.6065;
b0   =  0.1065;  b1   = 0.0902;

am1  = -1.3205;  am2  = 0.4966;
t0   = 1 + am1 + am2;     % 0.1761

%% Simülasyon ayarları
N     = 200;              % 100 saniye / 0.5 s
u     = zeros(1,N);  y  = zeros(1,N);
uf    = zeros(1,N); yf = zeros(1,N);
theta = zeros(4,1);       % [r0 r1 s0 s1]'
P     = 1e4*eye(4);       % RLS kovaryans
lam   = 0.995;            % Unutma faktörü

%% Referans işareti uc (Şekil 3.10 ile aynı)
uc = zeros(1,N);
uc( 1:50)  =  1;
uc(51:100)  = -1;
uc(101:150)  = 1;
uc(151:200) =  -1;

%% Ana döngü
for k = 3:N-1           % k==t/Ts
    % --- Prefiltre ---
    uf(k) = u(k-1) - am1*uf(k-1) - am2*uf(k-2);
    yf(k) = y(k-1) - am1*yf(k-1) - am2*yf(k-2);

    % --- Regresyon vektörü ---
    phi = [uf(k) uf(k-1) yf(k) yf(k-1)]';

    % --- RLS güncellemesi ---
    K   = P*phi/(lam + phi'*P*phi);
    eps = y(k) - phi'*theta;
    theta = theta + K*eps;
    P = (P - K*phi'*P)/lam;

    % --- Kontrol yasası ---
    r0 = max(theta(1),  1e-2);   % r0 ≠ 0 garanti
    r1 = theta(2);  s0 = theta(3);  s1 = theta(4);

    u(k) = ( t0*uc(k) - s0*y(k) - s1*y(k-1) - r1*u(k-1) ) / r0;

    % --- Bitki dinamiği ---
    y(k+1) = -a1*y(k) - a2*y(k-1) + b0*u(k) + b1*u(k-1);
end

%% Grafik
figure(2)
t = (0:N-1)*Ts;
subplot(2,1,1), plot(t, uc, '--', t, y), xlabel('Time [s]'), ylabel('y, u_c')
legend('u_c', 'y'), grid on
subplot(2,1,2), stairs(t, u), xlabel('Time [s]'), ylabel('u'), grid on
