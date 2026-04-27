clear; clc;
global omega  FM A
%Czestosci
fr1 = 22.3607/(2*pi);
fr2 = 14.1421/(2*pi);
fpod = 1;
fmied = 3;
f = 10;

m1 = 10;
m2 = 15;
k1 = 5000;
k2 = 3000;
% c1 = 10;
% c2 = 15;
c1 = 0;
c2 = 0;
Amp = 1000;
omega1 = [2*pi*fpod;2*pi*fr2;2*pi*fmied;2*pi*fr1;2*pi*f];
FM = Amp/m1;
t_p = 0;
t_k = 5;
x0 = zeros(4,1);

A = zeros(4,4);
A(1,2) = 1;
A(3,4) = 1;
A(2,1) = -k1/m1;
A(2,2) = -c1/m1;
A(2,3) = k1/m1;
A(2,4) = c1/m1;
A(4,1) = k1/m2;
A(4,2) = c1/m2;
A(4,3) = -(k1+k2)/m2;
A(4,4) = -(c1+c2)/m2;

for i = 1:1:5
    omega = omega1(i,1);
    [t,x] = ode45('dane1', [t_p t_k], x0);

    x1 = x(:,1);
v1 = x(:,2);
x2 = x(:,3);
v2 = x(:,4);
t1 = t(:,1);

figure(i)
subplot(4,1,1)
plot(t1,x1, 'r')
title('Przemieszczenie masy 1')
xlabel('Czas')
ylabel('Przemieszczenie')
grid on;
subplot(4,1,2)
plot(t1,v1, 'r')
title('Prędkość masy 1')
xlabel('Czas')
ylabel('Predkosc')
grid on;
subplot(4,1,3)
plot(t1,x2, 'r')
title('Przemieszczenie masy 2')
xlabel('Czas')
ylabel('Przemieszczenie')
grid on;
subplot(4,1,4)
plot(t1,v2, 'r')
title('Prędkość masy 2')
xlabel('Czas')
ylabel('Predkosc')
grid on;


end
% x1 = x(:,1);
% v1 = x(:,2);
% x2 = x(:,3);
% v2 = x(:,4);
% t1 = t(:,1);
% 
% figure(1)
% subplot(4,1,1)
% plot(t1,x1, 'r')
% title('Przemieszczenie masy 1')
% xlabel('Czas')
% ylabel('Przemieszczenie')
% grid on;
% subplot(4,1,2)
% plot(t1,v1, 'r')
% title('Prędkość masy 1')
% xlabel('Czas')
% ylabel('Predkosc')
% grid on;
% subplot(4,1,3)
% plot(t1,x2, 'r')
% title('Przemieszczenie masy 2')
% xlabel('Czas')
% ylabel('Przemieszczenie')
% grid on;
% subplot(4,1,4)
% plot(t1,v2, 'r')
% title('Prędkość masy 2')
% xlabel('Czas')
% ylabel('Predkosc')
% grid on;