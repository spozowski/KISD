% clear; clc;
global omega  FM A
f0 = 2.9058; %rezonans
f1 = 1; % podrezonansowa
m = 15; %kg
k = 5000; %N/m
c = 15; %Ns/m
% c = 80;
f = 6; %Hz nadrezonans
Amp = 1000;
% t_p = 0;
% t_k = 10;
t = 0:0.001:10;

% omega1 = [2*pi*f;2*pi*f0;2*pi*f1];
omega = 2*pi*f0;


FM = Amp/m;
x0 = zeros(2,1);

A = zeros(2,2);
A(1,2) = 1;
A(2,1) = -k/m;
A(2,2) = -c/m;

    [t,x] = ode45('dane1', t, x0);

    x1 = x(:,1);
    v1 = x(:,2);
    t1 = t(:,1);



% for i = 1:1:3
%     omega = omega1(i,:);
%     [t,x] = ode45('dane1', [t_p t_k], x0);
% 
%     x1 = x(:,1);
%     v1 = x(:,2);
%     t1 = t(:,1);
% 
%     figure(i)
%     subplot(2,1,1)
%     plot(t1,x1, 'r')
%     xlabel('Czas')
%     ylabel('Przemieszczenie')
%     grid on;
%     subplot(2,1,2)
%     plot(t1,v1, 'b')
%     xlabel('Czas')
%     ylabel('Prędkość')
%     grid on;
% end


