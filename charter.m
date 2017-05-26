close all
clear all
clc

T = 1/100;


realX = readFile('rzeczywiste_polozenie.csv');
mesX = readFile('zmierzone_polozenie.csv');
wyliczone = readFile('wyslac/polozenie_wyliczone.csv');
wyliczone(2000)=0;

czas = T:T:20;

plot(czas, mesX, 'r', czas, realX, 'b', czas, wyliczone, 'y')
title('Położenie');
legend('Zmierzone', 'Rzeczywiste', 'Estymowane');

function vec = readFile(name)
	vec = fscanf(fopen(name,'r'),'%f');
end




