clear all;
%%
f = 10;
m1 = 10;
m2 = 15;
k1 = 5000;
k2 = 3000;
c1 = 10;
c2 = 15;
Amp = 1000;

out = sim(simulink2stopnie,"Solver","ode45","StopTime","10");

[A1,B1,C1,D1] = linmod('simulink2stopnie');
[L1,M1] = ss2tf(A1,B1,C1,D1);


sys_ss = ss(A1, B1, C1, D1);
y = tf(sys_ss)
% figure(1)
% stepplot(y)
% grid on;
% 
% figure(2)
% bode(sys_ss)
% 
% figure(3)
% impulse(sys_ss)
% figure(4)
% nyquist(y)
% figure(5)
% nichols(y)