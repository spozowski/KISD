m = 15; %kg
k = 5000; %N/m
c = 15; %Ns/m
% f = 6; %Hz nadrezonans
f = 2.9058; %rezonans
out = sim(stopien_swobody,"Solver","ode45","StopTime","10");


y = out.simout.signals.values;
y1 = out.simout1.signals.values;
y2 = out.simout2.signals.values;
y3 = out.simout3.signals.values;
t = out.tout;

%%
blad_x = x1 - y2;
blad_v = v1 - y1;

figure(1)
subplot(4,1,1)
plot(t,x1,'r',t,blad_x,'b')
subplot(4,1,2)
plot(t,y2,'r',t, blad_x,'b')
subplot(4,1,3)
plot(t,v1,'r',t,blad_v,'b')
subplot(4,1,4)
plot(t,y1,'r',t, blad_v,'b')