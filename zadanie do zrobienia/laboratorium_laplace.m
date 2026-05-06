clc;clear;
m = 15; %kg
k = 5000; %N/m
c = 15; %Ns/m
f = 10;
L = [ 1 ];
M = [m c k];

y = tf(L,M)



%% wykresy
figure(1)
stepplot(y)
grid on;

figure(2)
bode(L,M)

figure(3)
impulse(L,M)
figure(4)
nyquist(y)
figure(5)
nichols(y)
