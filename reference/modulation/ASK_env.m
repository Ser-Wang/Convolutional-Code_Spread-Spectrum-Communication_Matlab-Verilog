clear all;                 
close all;                 
clc;                        

%% 基本参数（保持不变）
M = 10;                     % 产生码元数    
L = 100;                    % 每码元复制L次
Ts = 0.001;                 % 码元宽度
Rb = 1/Ts;                  % 码元速率1K
dt = Ts/L;                  % 采样间隔
TotalT = M*Ts;              % 总时间
t = 0:dt:TotalT-dt;         % 时间向量
Fs = 1/dt;                  % 采样频率

%% 生成基带信号（保持不变）
wave = randi([0,1], 1, M);  % 随机二进制序列
fz = ones(1, L);            % 复制L次
x1 = wave(fz, :);           % 扩展矩阵
jidai = reshape(x1, 1, L*M);% 单极性不归零波形

%% 2ASK调制（保持不变）
fc = 10000;                 % 载波频率10kHz
zb = cos(2*pi*fc*t);        % 载波信号
ask2 = jidai .* zb;         % 2ASK调制信号

% 绘制基带和调制信号
figure(1);
subplot(311);
plot(t, jidai, 'LineWidth', 2);
title('基带信号波形');
xlabel('时间/s');
ylabel('幅度');
axis([0, TotalT, -0.1, 1.1]);

subplot(312);
plot(t, ask2, 'LineWidth', 2);
title('2ASK信号波形');
axis([0, TotalT, -1.1, 1.1]);
xlabel('时间/s');
ylabel('幅度');

%% 通过高斯白噪声信道（保持不变）
SNR_dB = 20;                % 信噪比20dB
tz = awgn(ask2, SNR_dB);     % 加噪信号

figure(1);
subplot(313);
plot(t, tz, 'LineWidth', 2);
title('通过高斯白噪声信道后的信号');
axis([0, TotalT, -1.5, 1.5]);
xlabel('时间/s');
ylabel('幅度');

%% 包络检波及滤波
squared_tz = tz .^ 2;       %平方运算提取包络
fp_env = 4 * Rb;            % 低通滤波器截止频率设为4*Rb
b_env = fir1(30, fp_env/(Fs/2), 'low', boxcar(31)); 
[h_env, w_env] = freqz(b_env, 1, 512); % 频率响应
lvbo = fftfilt(b_env, squared_tz);  %滤波

figure(2);
subplot(311);
plot(w_env/pi*(Fs/2), 20*log10(abs(h_env)), 'LineWidth', 2);
title('包络检波低通滤波器频谱');
xlabel('频率/Hz');
ylabel('幅度/dB');

subplot(312);
plot(t, lvbo, 'LineWidth', 2);
axis([0, TotalT, -0.1, 1.1]);
title('包络检波后信号');
xlabel('时间/s');
ylabel('幅度');

k = 0.25;                   % 判决阈值
pdst = 1 * (lvbo > k);      

subplot(313);
plot(t, pdst, 'LineWidth', 2);
axis([0, TotalT, -0.1, 1.1]);
title('抽样判决后信号');
xlabel('时间/s');
ylabel('幅度');

%% 频谱分析
% 2ASK信号频谱
N = length(ask2);
df = 1 / TotalT;            % 频率分辨率
f = (-N/2:N/2-1) * df;      % 频率轴
sf = fftshift(abs(fft(ask2)));

figure(3);
subplot(211);
plot(f, sf, 'LineWidth', 2);
title('2ASK信号频谱');
xlabel('频率/Hz');
ylabel('幅度');

% 基带信号频谱
mf = fftshift(abs(fft(jidai)));
subplot(212);
plot(f, mf, 'LineWidth', 2);
title('基带信号频谱');
xlabel('频率/Hz');
ylabel('幅度');

% 平方后信号频谱
mmf = fftshift(abs(fft(squared_tz)));
figure(4);
subplot(211);
plot(f, mmf, 'LineWidth', 2);
title('平方后信号频谱');
xlabel('频率/Hz');
ylabel('幅度');

% 包络检波后频谱
dmf = fftshift(abs(fft(lvbo)));
subplot(212);
plot(f, dmf, 'LineWidth', 2);
title('包络检波后频谱');
xlabel('频率/Hz');
ylabel('幅度');