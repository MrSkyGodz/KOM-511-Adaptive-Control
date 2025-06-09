clear; clc; clf;

a22 = 1.3;
b1  = 19/15;
b2  = 19;

a11_range = linspace(0.1, 1.5, 15);
a21_range = linspace(25, 40, 15);

figure(1) ; hold on ; grid on;
xlabel('Real') ; ylabel('Imaginary') ; title('Köklerin Değişimi');

for i = 1:length(a11_range)
    for j = 1:length(a21_range)
        zeros = roots([b2, (b1*a21_range(j)-b2*a11_range(i)+b2), (b1*a21_range(j)-b2*a11_range(i))]);
        plot(real(zeros), imag(zeros), 'o'); % Karmaşık kökleri düzgün çizmek için
        drawnow; % Anında görselleştirme
    end
end

% ---------- 3) Yüksek-frekans kazancı pozitif mi? ---------------
B = [b1;b2;0];
C = [0 1 0; 0 0 1];
g   = sqrt(2)/2 * [1;1];
hfGain = g.'*C*B;            % aslında pay/ payda baş katsayı oranı da >0
gainPos = (hfGain > 0);
