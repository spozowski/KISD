%Identyfikacja modeli parametrycznych
%Układ dwuinercyjnyz opóźnieniem 

clc;clear all; close all;

%         10e^-3s          10e^-3s
% G(s) = -------------- = ---------------
%        (5s+1)(2s+1)     10s^2 + 7s + 1

%% ==========================
Td = 1; % krok czasowy

L = [0 0 10]; % licznik transmitancji
M = [10 7 1]; % mianownik transmitancji

T = 0:Td:100;  % wektor czasu

[m,n] = size(T);

Nd = 3; % opóźnienie

%% ===========================
%generacja sygnału wejściowego

% u = 4*idfun(T) + noise(T,0.8,0.1);
u=4*idfun(T)+noise(T,0.8,0.1); 
%% ===========================
% Symulacja odpowiedzi układu

[y,X] = lsim(L,M ,u,T);

%% ===========================
% Dodanie szumu
y=y'+noise(T,0.3,0.2);

%% ===========================
% Opóźnienie

y= [zeros(1,Nd), y(1:n-Nd)];

%% ===========================
% Wykresy


figure;
subplot(2,1,1)
plot(T,u)
grid on
title('sygnał wejściowy')
ylabel('u')

subplot(2,1,2)
plot(T,y)
grid on
title('wygnał wyjściowy')
xlabel('czas')
ylabel('y')

%% ===========================
% przygotowanie danych do identyfikacji 


% DAne wejscie-wyjscie
Dane = iddata(y',u',Td);
% Dane AR
Dane_AR = iddata(y',[],Td);

%% ===========================
% Model ARX

na = 2;
nb = 2;
nk = 3;

Model_ARX= arx(Dane,[na nb nk]);

disp('===========================');
disp('MODEL ARX')
disp('===========================');

Model_ARX

%% ===========================
% Model AR

rzadAR = 2;

Model_AR = ar(Dane_AR,rzadAR);

disp('===========================');
disp('MODEL AR')
disp('===========================');

Model_AR

%% ===========================
% Model ARMA

na_arma = 2;
nc_arma = 2;
Model_ARMA = armax(Dane_AR,[na_arma nc_arma]);

disp('===========================');
disp('MODEL ARMA')
disp('===========================');

Model_ARMA

%% ===========================
% Model ARMAX

na_armax = 2;
nb_armax = 2;
nc_armax = 2;
Model_ARMAX=armax(Dane,[na_armax nb_armax nc_armax nk]);

disp('===========================');
disp('MODEL ARMAX')
disp('===========================');

Model_ARMAX

%% ===========================
% Model BOX-JENKINS(BJ)

nb_bj = 2;
nc_bj = 2;
nd_bj = 2;
nf_bj = 2;

Model_BJ = bj(Dane, [nb_bj nc_bj nd_bj nf_bj nk]);

disp('===========================');
disp('MODEL BJ')
disp('===========================');
Model_BJ

%% ===========================
% Model OUTPUT ERROR (OE)

nb_oe = 2;
nf_oe = 2;

Model_OE = oe(Dane,[nb_oe nf_oe nk]);

disp('===========================');
disp('MODEL OE')
disp('===========================');
Model_OE

%% ===========================
% Porównanie modeli wejście-wyjście

figure;
compare(Dane,Model_ARX,Model_ARMAX,Model_BJ,Model_OE,Dane_AR,Model_AR,Model_ARMA);
grid on;

title('Porównanie modeli ARX, ARMA, ARMAX, BJ, OE, ')
%% ===========================
% Porównanie modeli bez wejścia

figure;
compare(Dane_AR,Model_AR,Model_ARMA)
grid on
title('porównanie modeli: AR i ARMA')

%% ===========================
%transmitancje modeli

disp('===========================');
disp('TANSMITANCJA ARX')
disp('===========================');
TF_ARX = tf(Model_ARX)
disp('===========================');
disp('TANSMITANCJA ARMAX')
disp('===========================');
TF_ARMAX = tf(Model_ARMAX)
disp('===========================');
disp('TANSMITANCJA BJ')
disp('===========================');
TF_BJ = tf(Model_BJ)
disp('===========================');
disp('TANSMITANCJA OE')
disp('===========================');
TF_OE = tf(Model_OE)

%% ===========================
% FUNKCJA NOISE()

function z = noise(t,v,F)

% Szum kolorowy

[m,n] = size(t);

z = zeros(1,n);
for i = 2:n
    z(i)=F*z(i-1)+randn(1)*sqrt(v);
end
end

%funkcja IDfun

function u = idfun(t)

u = 0.02*t.^3 ./ (exp(t*0.2 +1)-1);
end

%% ===========================
% FUNKCJA KOHERENCJI 

figure;
[coh, f] = mscohere(u, y, hamming(64), 32, 512, 1/Td);
% u, y - wektory wierszowe (tak jak w Twoim skrypcie)
plot(f, coh);
xlabel('Częstotliwość [Hz]');
ylabel('Koherencja');
title('Funkcja koherencji wejście-wyjście');
grid on;
ylim([0 1.05]);


%% ===========================
% THD (TEORETYCZNA TRANSMITANCJA DYSKRETNA) 


s = tf('s');
G_ciagla = 10 / ((5*s+1)*(2*s+1)) * exp(-3*s);   % opóźnienie 3 sekundy (Nd*Td)

Td = 1;
G_dyskretna = c2d(G_ciagla, Td, 'zoh');

disp('=== Teoretyczna transmitancja dyskretna (THD) ===');
G_dyskretna


% Porównanie odpowiedzi skokowych
figure;
step(G_dyskretna, 'b-', TF_ARX, 'r--', TF_OE, 'g-.', TF_BJ, 'm:');
legend('Teoretyczna (c2d)', 'ARX', 'OE', 'BJ');
title('Porównanie odpowiedzi skokowych');
grid on;