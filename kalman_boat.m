function kalman_boat(duration, step, measnoise, accelnoise, acceleration) 
  
%Funkcja kamlan_boat(duration, T, measnoise ) 
%duration - czas trwania symulacji [s] 
%step - krok symulacji [s] 
%measnoise &#8211; wspolczynnik szumu pomiaru 
%accelnoise - wspolczynnik szumu przyspieszenia 
%acceleration - przyspieszenie lodki [m/s*s] 
  
T = step; 
R = measnoise^2;   %Wyznaczenie kowariancji szumu pomiaru 
Q = accelnoise^2 * [(T^2/2)^2 (T^2/2)*T; (T^2/2)*T T^2];  %Kowariancja szumu procesu 
A = [1 T; 0 1];         %Macierz przejscia stanu poprzedniego do obecnego 
B = [T^2 / 2; T ];     %Macierz przejscia dla wejscia ( w tym przypadku przyspieszenie ) 
H = [1 0];                %Macierz przejscia dla mierzonej wielkosci 
  
%Inicjalizacja 
I = [ 1 0; 0 1 ];        %Macierz jednostkowa 
P = Q;                     %Poczatkowa macierz kowariancji P 
x = [0; 0];                %Stan poczatkowy 
xhat = x;                  %Wartosc poczatkowa x 
u = acceleration;    %Przyspieszenie lodki 
  
%Przygotowanie miejsca na dane 
pos = [];                 %Prawdziwa pozycja 
poshat = [];            %Pozycja estymowana filtrem kalmana 
posmeas = [];        %Pozycja mierzona 
  
%Rozpoczecie symulacji 
for t = 0:T:duration, 
    %Symulacja naszego stystemu liniowego, dodajemy szum przyspieszenia 
    x = A * x + B * u + accelnoise * [(T^2/2)*randn; T * randn]; 
    %Symulacja zaszumionego pomiaru 
    z = H * x + measnoise * randn; 
    %Faza Predykcji 
    xhat = A * xhat + B * u; 
    P = A*P*A' + Q; %'
    %Faza Korekcji 
    K = P * H' * inv( H * P * H' + R); 
    xhat = xhat + K*(z - H*xhat); 
    P = ( I - K*H)*P; 
    %Uaktualnienie danych 
    pos = [pos; x(1)];                  %Pozycja rzeczywista 
    posmeas = [posmeas; z];     %Pozycja mierzona GPS 
    poshat = [poshat; xhat(1)];  %Pozycja estymowana filtrem kalmana 
end; 
  
close all; 
t = 0:step:duration; 
figure; 
plot(t, pos, t, posmeas, t, poshat); 
grid; 
xlabel('Czas [s]'); 
ylabel('Pozycja [m]'); 
legend('prawdziwa', 'mierzona', 'estymowana'); 
title('Pozycja lodki');