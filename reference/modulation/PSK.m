clear all;                 
close all;                 
clc;                        
%% 基本参数
% M=10;                       % 产生码元数 
% L=100;                      % 每码元复制L次,每个码元采样次数
% Ts=0.001;                   % 每个码元的宽度,即码元的持续时间
% Rb=1/Ts;                    % 码元速率1K
% dt=Ts/L;                    % 采样间隔
% TotalT=M*Ts;                % 总时间
% t=0:dt:TotalT-dt;           % 时间
% Fs=1/dt;                    % 采样间隔的倒数即采样频率
fc=13560000;    %13.56M
M=5;
L=512;          % 128*4
Rb=fc/128;      % 106k
Ts = 1/Rb;      % 码元宽度
dt = 1/(fc*4);
TotalT=M*Ts;                % 总时间
t=0:dt:TotalT-dt;           % 时间
Fs=1/dt;                    % 采样间隔的倒数即采样频率

%% 产生单极性波形
wave=randi([0,1],1,M);      % 产生二进制随机码,M为码元个数
fz=ones(1,L);               % 定义复制的次数L,L为每码元的采样点数
x1=wave(fz,:);              % 将原来wave的第一行复制L次，称为L*M的矩阵
jidai=reshape(x1,1,L*M);    % 产生单极性不归零矩形脉冲波形，将刚得到的L*M矩阵，按列重新排列形成1*(L*M)的矩阵

%% 单极性变为双极性
jidai = 2*jidai-1;
%% 2PSK调制
% fc=10000;  
% fc=10000000;    %10M
zb=sin(2*pi*fc*t);          % 载波
psk=jidai.*zb;              % 2PSK的模拟调制 
figure(1);                 
subplot(211);               
plot(t,jidai,'LineWidth',2);
title('基带信号波形');     
xlabel('时间/s');          
ylabel('幅度');            
axis([0,TotalT,-1.1,1.1])  

subplot(212)                 
plot(t,psk,'LineWidth',2);  
title('2PSK信号波形')  
axis([0,TotalT,-1.1,1.1]); 
xlabel('时间/s');           
ylabel('幅度');            
%% 信号经过高斯白噪声信道
tz=awgn(psk,20);            
figure(2);                  
subplot(211);               
plot(t,tz,'LineWidth',2);  
axis([0,TotalT,-1.5,1.5]); 
title('通过高斯白噪声信道后的信号');
xlabel('时间/s');          
ylabel('幅度');            
%% 解调部分
tz=tz.*zb;                  % 相干解调，乘以相干载波
subplot(212)               
plot(t,tz,'LineWidth',1)    
axis([0,TotalT,-1.5,1.5]); 
title("乘以相干载波后的信号")
xlabel('时间/s');          
ylabel('幅度');             
%% 加噪信号经过滤波器
% 低通滤波器设计
fp=2*Rb;                   
b=fir1(30, fp/Fs, boxcar(31));
[h,w]=freqz(b, 1,512);      % 生成fir滤波器的频率响应
lvbo=fftfilt(b,tz);         % 滤波
figure(3);                   
subplot(311);               
plot(w/pi*Fs/2,20*log(abs(h)),'LineWidth',2);
title('低通滤波器的频谱');  
xlabel('频率/Hz');          
ylabel('幅度/dB');          

subplot(312)                
plot(t,lvbo,'LineWidth',2); 
axis([0,TotalT,-1.1,1.1]); 
title("经过低通滤波器后的信号");
xlabel('时间/s');           
ylabel('幅度');             

%% 抽样判决
k=0;                        % 判决阈值
pdst=1*(lvbo>0);            
subplot(313)                
plot(t,pdst,'LineWidth',2)  
axis([0,TotalT,-0.1,1.1]);  
title("经过抽样判决后的信号")
xlabel('时间/s');           
ylabel('幅度');             

%% 绘制频谱
%% 2PSK信号频谱
T=t(end);                   % 时间
df=1/T;                     % 频谱分辨率
N=length(psk);              % 采样长度
f=(-N/2:N/2-1)*df;          % 频率范围
sf=fftshift(abs(fft(psk))); 
figure(4)                   
subplot(211)                
plot(f,sf,'LineWidth',2)    
title("2PSK信号频谱")     
xlabel('频率/Hz');          
ylabel('幅度');             

%% 信源频谱
mf=fftshift(abs(fft(jidai)));
subplot(212);               
plot(f,mf,'LineWidth',2);   
title("基带信号频谱");      
xlabel('频率/Hz');         
ylabel('幅度');             

%% 乘以相干载波后的频谱
mmf=fftshift(abs(fft(tz))); 
figure(5)                   
subplot(211);               
plot(f,mmf,'LineWidth',2)  
title("乘以相干载波后的频谱")
xlabel('频率/Hz');          
ylabel('幅度');             

%% 经过低通滤波后的频谱
dmf=fftshift(abs(fft(lvbo)));
subplot(212);               
plot(f,dmf,'LineWidth',2)   
title("经过低通滤波后的频谱");
xlabel('频率/Hz');         
ylabel('幅度');             