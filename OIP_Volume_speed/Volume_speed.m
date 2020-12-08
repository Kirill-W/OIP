%% Считывание данных

tmp_data = importdata('air.txt',',');
airRaw = tmp_data.data;
tmp_data = importdata('breath.txt',',');
breathRaw = tmp_data.data;
tmp_data = importdata('samplingFrequency.txt',',');
sF = tmp_data.data;
tmp_data = importdata('temperature.txt',',');
te = tmp_data.data;
tmp_data = importdata('totalTime.txt',',');
ti = tmp_data.data;
tmp_data = importdata('volumeFractionWater.txt',',');
vFW = tmp_data.data;
[s1, s2] = size(airRaw);
ttRaw = linspace(0, ti, s1);
ttRaw = transpose(ttRaw);

%% Нормировка

windowSize = 5;
b = (1 / windowSize) * ones(1, windowSize);
a = 1;

airFiltered = filter(b, a, airRaw());
breathFiltered = filter(b, a, breathRaw());

start = 30;

airFiltered = airFiltered(start:end, :);
breathFiltered = breathFiltered(start:end, :);
tt = ttRaw(start:end);

cAir = polyfit(tt, airFiltered(:, 1), 3);
cBreath = polyfit(tt, breathFiltered(:, 1), 3);

air = airFiltered - polyval(cAir, tt);
airNorm = air ./ max(air);

breath = breathFiltered - polyval(cBreath, tt);
breathNorm = breath ./ max(breath);

%% Первый график (воздух)

% subplot(131);
plot(tt, airNorm);
title('Относительное изменение давления у микрофонов в воздухе');
xlabel('Время, с');
ylabel('Отсчёты АЦП');
legend('Микрофон №1', 'Микрофон №2');
grid on;

%% Второй график (лёгкие)

% subplot(132);
plot(tt, breathNorm);
title('Относительное изменение давления у микрофонов в воздухе из лёгких');
xlabel('Время, с');
ylabel('Отсчёты АЦП');
legend('Микрофон №1', 'Микрофон №2');
grid on;

%% Подсчёт необходимых значений

m1 = find(airNorm == max(airNorm));
m2 = find(breathNorm == max(breathNorm));
t1 = tt(m1(1));
t2 = tt(m1(2) - 995);
t3 = tt(m2(1));
t4 = tt(m2(2) - 995);

v1 = 1.158/(t4 - t3);
v2 = 1.158/(t2 - t1);

T = te + 273.14;
R = 8.314;

x_CO2 = linspace(0, 0.02);
q = 1 - vFW - x_CO2;

mu = 28.97.*q + 18.01*vFW + 44.01.*x_CO2;
g = (28.97*1.0036.*q + 18.01*1.863*vFW + 44.01*0.838.*x_CO2)./(28.97*0.7166.*q + 18.01*1.403*vFW + 44.01*0.649.*x_CO2);

v = sqrt(1000 * R .* g * T ./ mu);
v11 = ones(100) * v1;

%% Третий график (результат)

% subplot(133);
plot(x_CO2, v, 'b', x_CO2, v11, 'r');
grid on;
hold on;

eee = 0.00916502979156563; % Получено из программы на Python
plot(eee, v1, '*');
title('Зависимость скорости звука от объёмной доли CO_{2}');
xlabel('Доля CO_{2}');
ylabel('Скорость звука, м/с');
legend('Скорость звука в зависимости от содержания CO_{2} при H_{2}O = 0.018, t = 22,4 °C', 'Рассчитанная экспериментальная скорость звука в воздухе из лёгких');
grid on;