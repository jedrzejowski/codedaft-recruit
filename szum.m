close all
clear all
clc

T = 1/100;

realX = readFile('rzeczywiste_polozenie.csv');
mesX = readFile('zmierzone_polozenie.csv');
mesV = readFile('zmierzona_predkosc.csv');

czas = T:T:20;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Q = 0.9;
R = 775;

x = 0;
P = 0;

kalmanX1(1) = 0;

for i = 2:size(mesX)
    
	
    P = P + Q;
    K = P * inv(P + R); 
    x = x + K * (mesX(i-1) - x); 
    P = ( 1 - K ) * P;
        
    kalmanX1(i) = x;
    
end



R = 500;
Q = 5;

x = 0;
P = 0;

kalmanX2(1) = 0;

for i = 2:size(mesX)
    
	
    P = P + Q;
    K = P * inv(P + R); 
    x = x + K * (kalmanX1(i-1) - x); 
    P = ( 1 - K ) * P;
        
    kalmanX2(i) = x;
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
%plot(czas, mesX, 'r', czas, realX, 'b', czas, kalmanX1, 'g')
%legend('Zmierzony', 'Rzeczywisty', 'Filtr Kalman')

%%predkosc

realV(1) = 0;
for i = 2:size(mesX)-1
    realV(i) = (realX(i+1) - realX(i-1))./(2*T);
end
realV(2000)=0;

Q = 1;
R = 775;

x = 0;
P = 0;

kalmanV1(1) = 0;

for i = 2:size(mesX)
    
	
    P = P + Q;
    K = P * inv(P + R); 
    x = x + K * (mesV(i-1) - x) - 0.004; 

    P = ( 1 - K ) * P;
        
    kalmanV1(i) = x;
    
end
kalmanV1(2000)=0;



%dodatawnie predkosci

kalmanX3(1) = 0;
for i = 2:size(mesX)
    kalmanX3(i) = (sum(kalmanV1(1:i))*T + kalmanX2(i) + kalmanX2(i-1) + kalmanV1(i-1)*T)/3;
end





plot(czas, mesX, 'r', czas, realX, 'b', czas, kalmanX3, 'g')


function vec = readFile(name)
	vec = fscanf(fopen(name,'r'),'%f');
end











