clear all;
m = 15; %kg
k = 5000; %N/m
c = 15; %Ns/m
f = 10; %Hz nadrezonans
% f = 2.9058; %rezonans
L = [ 1 ];
M = [m c k];

y = tf(L,M)

out = sim(stopien_swobody,"Solver","ode45","StopTime","10");

[A,B,C,D] = linmod('stopien_swobody');
[L1,M1] = ss2tf(A,B,C,D);

y = tf(L1,M1)
figure(1)
stepplot(y)
grid on;

figure(2)
bode(L1,M1)

figure(3)
impulse(L1,M1)
figure(4)
nyquist(y)
figure(5)
nichols(y)