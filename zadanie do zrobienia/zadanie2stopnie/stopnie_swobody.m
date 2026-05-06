clear; clc;
%%
global omega  FM A
f = 10;
m1 = 10;
m2 = 15;
k1 = 5000;
k2 = 3000;
c1 = 10;
c2 = 15;
Amp = 1000;

omega= 2*pi*f;

FM = Amp/m1;
t_p = 0;
t_k = 10;

t = 0:0.001:t_k;


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

% Jedno wejście – siła na m1
B = [0; 1/m1; 0; 0];

% Wyjścia: x1 i x2
C = [1, 0, 0, 0;
     0, 0, 1, 0];
D = [0; 0];


%% dla jednej częstości 

    [t,x] = ode45('dane1', t, x0);

    x1 = x(:,1);
    v1 = x(:,2);
    x2 = x(:,3);
    v2 = x(:,4);
    t1 = t(:,1);
%% Laplace    

sys_ss = ss(A, B, C, D);
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