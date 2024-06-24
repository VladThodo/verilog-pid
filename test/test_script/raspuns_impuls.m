load rasp_impuls9.mat
plot(t,y)
ylim([5, 20])
title('Offset = 1870 Kp = 50 Ki = 1 Kd = 50')
xlabel('Timp [s]')
ylabel('Distanța măsurată [inch]')
y = double(y)
stepinfo(y, t, 14, 'SettlingTimeThreshold', 0.1)
%% 
plot(t,i)
title('Evoluția în timp a componentei integrale')
xlabel('Timp [s]')
ylabel('Valoarea integralei')
xlim([0 1])
ylim([0 120])
%%
subplot 411
plot(t, out - 1800)
title('Valoare ieșire PID')
subplot 412
plot(t, i)
title('Valoarea componentei integrale')
subplot 413
plot(t, d * 50)
title('Valoarea componentei derivate')
subplot 414
plot(t, e * 60)
title('Valoarea componentei proporționale')
%% 
subplot 211
plot(t,e)
title('Eroarea măsurată')
xlabel('Timp [s]')
ylim([0 6])
subplot 212
plot(t,d, 'r')
ylim([0 2])
title('Valoarea derivatei')
xlabel('Timp [s]')
%% 
stepinfo(y, t, 14, 6)
title('Offset = 18000 Kp = 80 Ki= 1')
ylabel('Distanta măsurată de senzor')
subplot 211
plot(e)
ylim([0 6])
subplot 212
plot(d, 'r')
ylim([0 2])