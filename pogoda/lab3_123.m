clear;clc;
P_wiatru = [3.17 3.37 2.67 1.08 1.31 1.29 1.61 1.5 1.84 3.15 2.02 0.87 1.14 1.15 1.83 1.91 1.42 0.74 0.7 0.65 1.02 1.89 1.96 1.86 0.97 0.67 1.29 2.51 3.04 3.46 2.87 2.7 2.38 1.87 2.1 1.18 0.88 1.39 2.67 1.07 0.81 1.25 2.06 1.63 2.97 2 0.9 1.21 1.86 2.21 1.16 1.4 2.13 2.35 1.6 0.9 0.62 0.72 1.18 0.93 0.79 1.34 1.04 0.97 0.96 1.56 0.97 1.42 1.17 1.12 1.23];


t = 1:length(P_wiatru);

uchwyt1 = fopen('c:\MATLAB\Odczyt-pm10.txt','r');
pm = fscanf(uchwyt1, '%f\n',[1 Inf]);
fclose('all');

uchwyt1 = fopen('c:\MATLAB\temperatura.txt','r');
temp = fscanf(uchwyt1, '%f\n',[1 Inf]);
fclose('all');

z = [t;temp;P_wiatru;pm];

uchwyt = fopen('c:\MATLAB\dane1.bin','w');
fwrite(uchwyt,z,'float');
fclose('all');

% figure(1)
% subplot(2,1,1)
% plot(z(1,:),z(2,:), 'r')
% grid on
% subplot(2,1,2)
% plot(z(1,:),z(3,:), 'b')
% grid on

clear all;




uchwyt1 = fopen('c:\MATLAB\dane1.bin','r');
z1 = fread(uchwyt1,[4 Inf],'float');
fclose('all');

t = z1(1,:);
y1 = z1(2,:);
y2 = z1(3,:);
y3 = z1(4,:);

n = length(t);


breaks = [1,11,21,31,41,51,61,71];


figure; hold on;
plot(t,y1, 'r')
title('Temperatura')
xlabel('Dzien roku')
grid on;

for i = 1:length(breaks)-1
    idx = breaks(i):breaks(i+1);
    xi = t(idx);
    yi = y1(idx);

    p = polyfit(xi,yi, 8);
    y_fit = polyval(p,xi);

    plot(xi, y_fit, 'b')
end
hold off;
figure(2); hold on;
plot(t,y2, 'r')
title('Temperatura')
xlabel('Dzien roku')
grid on;

for i = 1:length(breaks)-1
    idx = breaks(i):breaks(i+1);
    xi = t(idx);
    y22 = y2(idx);

    p2 = polyfit(xi,y22, 8);
    y_fit2 = polyval(p2,xi);

    plot(xi, y_fit2, 'b')
end
hold off;
figure(3); hold on;
plot(t,y3, 'r')
title('Temperatura')
xlabel('Dzien roku')
grid on;

for i = 1:length(breaks)-1
    idx = breaks(i):breaks(i+1);
    xi = t(idx);
    y33 = y3(idx);

    p3 = polyfit(xi,y33, 8);
    y_fit3 = polyval(p3,xi);

    plot(xi, y_fit3, 'b')
end
hold off;
% [w1,S1] = polyfit(t,y1,20);
% a1 = polyval(w1,t);
% [w2,S2] = polyfit(t,y2,20);
% a2 = polyval(w2,t);
% [w3,S3] = polyfit(t,y3,20);
% a3 = polyval(w3,t);

% figure(2)
% subplot(3,1,1)
% plot(t,y1, 'r',t,a1, 'b')
% title('Temperatura')
% xlabel('Dzien roku')
% ylabel('Temperatura *C')
% grid on
% subplot(3,1,2)
% plot(t,y2, 'b',t,a2,'r')
% title('Predkosc wiatru')
% xlabel('Dzien roku')
% ylabel('m/s')
% grid on
% subplot(3,1,3)
% plot(t,y3, 'r',t,a3,'b')
% title('PM10')
% xlabel('Dzien roku')
% ylabel('???')
% grid on;







% E_y1 = sum(y1.^2);
% E_y2 = sum(y2.^2);
% E_y3 = sum(y3.^2);
% 
% M_y1 = E_y1/n;
% M_y2 = E_y2/n;
% M_y3 = E_y3/n;
% 
% y1_sk = sqrt(M_y1);
% y2_sk = sqrt(M_y2);
% y3_sk = sqrt(M_y3);
% 
% w_sr = sum(t)/(t(n)-t(1));
% 
% %min, max
% y1_min = min(y1);
% y1_max = max(y1);
% y2_min = min(y2);
% y2_max = max(y2);
% y3_min = min(y3);
% y3_max = max(y3);
% 
% %odchylenie standardowe
% 
% y1_os = std(y1);
% y2_os = std(y2);
% y3_os = std(y3);
% 
% Energia = [E_y1;E_y2;E_y3];
% Moc = [M_y1;M_y2;M_y3];
% Wartosc_skuteczna = [y1_sk;y2_sk;y3_sk];
% Wartosc_maksymalne = [y1_max;y2_max;y3_max];
% Wartosc_minimalne = [y1_min;y2_min;y3_min];
% Odchylenie_standardowe = [y1_os;y2_os;y3_os];
% 
% T = table(Moc,Energia,Wartosc_skuteczna,Wartosc_maksymalne,Wartosc_minimalne,Odchylenie_standardowe)