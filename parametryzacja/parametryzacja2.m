%% ===========================
clc; clear all; close all; 

%% ===========================
% PARAMETRY UKŁADU

m = 1;
c = 2;
k = 100;

%% ===========================
% MODEL TRANSMITANCYJNY 

s = tf('s');

G=1/(m*s^2+c*s+k);

%% ===========================
% dyskretyzacja
Ts = 0.01;
Gd = c2d(G,Ts);

%% ===========================
% GENERACJA DANYCH

N = 3000;
T = (0:N-1)'*Ts;

% wymuszenie

u = rand(N,1);

% odpowiedz układu 

y = lsim(Gd,u,T);

% szum pomiarowy

noiseLevel = 0.02;
y = y +noiseLevel*randn(size(y));

%% ===========================
% WYKRESY
figure;
subplot(2,1,1)
plot(T,u)
grid on
title('SYGNAŁ WEJŚCIOWY')
xlabel('czas [s]')
ylabel('u(t)')
subplot(2,1,2)
plot(T,y)
grid on
title('WYGNAŁ WYJŚCIOWY')


%% ===========================
% PODZIAŁ DANYCH 

Ntrain = 2000;

u_est = u(1:Ntrain);
y_est = y(1:Ntrain);

u_val = u(Ntrain+1:end);
y_val = y(Ntrain+1:end);

%% ===========================
% DANE iddata
% dane wejście-wyjście
data_est = iddata(y_est,u_est,Ts);

data_val = iddata(y_val,u_val,Ts);

% dane tylko wyjściowe

data_ar = iddata(y_est,[],Ts);

%% ===========================
% IDENT. MODELU AR

na = 4; 
model_ar = ar(data_ar,na);

present(model_ar);

%% ===========================
% IDENT. MODELU ARMA

na = 4; 
nc = 3;
model_arma = armax(data_ar,[na nc]);

present(model_arma);

%% ===========================
% IDENT. MODELU BOX-JENKINS (BJ)

nb = 2;
nc_bj = 2;
nd = 2;
nf = 2;
nk = 1;
model_bj = bj(data_est,[nb nc_bj nd nf nk]);
present(model_bj)

%% ===========================
% porównanie modeli 

figure;
compare(data_val,model_bj)


%% ===========================
% symulacja modeli


y_ar = predict(model_ar,data_ar,1);

y_arma = predict(model_arma,data_ar,1);

y_bj = sim(model_bj,u_val);

%% ===========================
% KONWERSJA

y_ar = y_ar.OutputData;
y_arma = y_arma.OutputData;
y_bj = double(y_bj);

%% ===========================
% DOPASOWANIE DŁUGOŚCI

Nmin = min([length(y_val),length(y_ar),length(y_arma),length(y_bj)]);
y_ref = y_val(1:Nmin);
y_ar = y_ar(1:Nmin);
y_arma = y_arma(1:Nmin);
y_bj = y_bj(1:Nmin);

%% ===========================

e_ar = y_ref - y_ar;

e_arma = y_ref - y_arma;

e_bj = y_ref - y_bj;

%% ===========================
% MSE

mse_ar = mean(e_ar.^2);

mse_arma = mean(e_arma.^2);

mse_bj = mean(e_bj.^2);

%% ===========================
% MSE

rmse_ar = sqrt(mse_ar);

rmse_arma = sqrt(mse_arma);

rmse_bj = sqrt(mse_bj);

%% ===========================
% MAE

mae_ar = mean(abs(e_ar));

mae_arma = mean(abs(e_arma));

mae_bj = mean(abs(e_bj));

%% ===========================
% 

fit_ar = 100*(1 - norm(e_ar)/norm(y_ref-mean(y_ref)));

fit_arma = 100*(1 - norm(e_arma)/norm(y_ref-mean(y_ref)));

fit_bj = 100*(1 - norm(e_bj)/norm(y_ref-mean(y_ref)));

%% ===========================
% AIC

aic_ar = aic(model_ar);

aic_arma = aic(model_arma);

aic_bj = aic(model_bj);

%% ===========================
% BIC

Ndata = length(y_ref);

k_ar = length(model_ar.Report.Parameters.ParVector);

k_arma = length(model_arma.Report.Parameters.ParVector);

k_bj = length(model_bj.Report.Parameters.ParVector);

bic_ar = Ndata*log(mse_ar) + k_ar*log(Ndata);

bic_arma = Ndata*log(mse_arma) + k_arma*log(Ndata);

bic_bj = Ndata*log(mse_bj) + k_bj*log(Ndata);

%% ===========================
% FPE

fpe_ar = mse_ar*((Ndata+k_ar)/(Ndata-k_ar));

fpe_arma = mse_arma*((Ndata+k_arma)/(Ndata-k_arma));

fpe_bj = mse_bj*((Ndata+k_bj)/(Ndata-k_bj));


%% ===========================
% WIZUALIZACJA WYNIKÓW

% 1. Porównanie odpowiedzi modeli z rzeczywistym przebiegiem
t_val = T(Ntrain+1 : Ntrain+Nmin);
figure;
plot(t_val, y_ref, 'k-', 'LineWidth', 1.5); hold on;
plot(t_val, y_ar,   'b--', 'LineWidth', 1);
plot(t_val, y_arma, 'r-.', 'LineWidth', 1);
plot(t_val, y_bj,   'g:',  'LineWidth', 1.5);
hold off; grid on;
xlabel('Czas [s]'); ylabel('y(t)');
title('Porównanie odpowiedzi modeli na danych walidacyjnych');
legend('Rzeczywiste','AR','ARMA','BJ','Location','best');

% 2. Błędy predykcji
figure;
plot(t_val, e_ar, 'b', 'LineWidth', 1); hold on;
plot(t_val, e_arma, 'r', 'LineWidth', 1);
plot(t_val, e_bj, 'g', 'LineWidth', 1);
hold off; grid on;
xlabel('Czas [s]'); ylabel('e(t)');
title('Błędy dopasowania');
legend('AR','ARMA','BJ');

% 3. Słupkowe porównanie MSE, RMSE, MAE
metrics = [mse_ar, mse_arma, mse_bj;
           rmse_ar, rmse_arma, rmse_bj;
           mse_ar, mae_arma, mae_bj];
figure;
bar(metrics);
set(gca, 'XTickLabel', {'MSE','RMSE','MAE'});
ylabel('Wartość błędu');
title('Metryki błędów');
legend({'AR','ARMA','BJ'}, 'Location','northwest');
grid on;

% 4. Procentowe dopasowanie (Fit)
fitVals = [fit_ar, fit_arma, fit_bj];
figure;
bar(fitVals);
set(gca, 'XTickLabel', {'AR','ARMA','BJ'});
ylabel('Fit [%]');
title('Procentowe dopasowanie modeli');
grid on; ylim([0 100]);
for i = 1:3
    text(i, fitVals(i)+1, sprintf('%.2f%%', fitVals(i)), ...
        'HorizontalAlignment','center', 'FontWeight','bold');
end

% 6. Koherencja
figure;
plot(f, coh, 'b-', 'LineWidth', 1.5);
xlabel('Częstotliwość [Hz]');
ylabel('Koherencja');
title('Funkcja koherencji wejście–wyjście (dane estymacyjne)');
grid on; ylim([0 1.05]);

% 7. Porównanie za pomocą wbudowanej funkcji compare
figure;
compare(data_val, model_ar, model_arma, model_bj);
grid on;
title('Porównanie modeli (compare) na danych walidacyjnych');

% 8. Porównanie odpowiedzi skokowych – THD vs zidentyfikowane modele
% (jeśli modele mają postać wejście-wyjście; AR/ARMA nie mają wejścia,
%  więc porównujemy tylko BJ, który ma strukturę OE/BJ)
figure;
step(Gd, 'k-', model_bj, 'g--');
legend('THD (c2d)', 'BJ', 'Location','best');
title('Odpowiedzi skokowe – teoretyczna i zidentyfikowana (BJ)');
grid on;