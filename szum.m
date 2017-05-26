close all
clear all
clc

T = 1/100;

realX = readFile('rzeczywiste_polozenie.csv');
mesX = readFile('zmierzone_polozenie.csv');
mesV = readFile('zmierzone_polozenie.csv');

czas = T:T:20;
kalmanX = zeros(1, 2000);
kalmanV = zeros(1, 2000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Odchylenie standardowe pomiaru
std_dev = 6.35;

% Macierze kowariancji szumow
V = 1*std_dev*T;
W = std_dev*std_dev;

A = 1;
C = 1.00;

%początek
x0 = 0;
P0 = 1;
xpri = x0;
Ppri = P0;
xpost = x0;
Ppost = P0;

for i = 2:size(mesX)
    
	% aktualizacja czasu
    xpri = xpost;
    Ppri = Ppost + V;
        
    % aktualizacja pomiarow
    hej = mesX(i) - xpri;
    S = Ppri + W;
    K = Ppri*S^(-1);
    xpost = xpri + K*hej;
    Ppost = Ppri - K*S*K';
        
    kalmanX(i) = xpost;
    
end

disp(['Poziom odchylenia po pierszym: ', num2str(sum((abs(realX-kalmanX'))./realX)/2000*100), '%']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(czas, mesX, 'r', czas, realX, 'b', czas, kalmanX, 'g')

%figure;
%plot(czas, mesV, 'r', czas, realV, 'b', czas, kalmanV, 'g')





function vec = readFile(name)
	vec = fscanf(fopen(name,'r'),'%f');
end











