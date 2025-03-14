close all; clear all; clc;
BW=500e3;                                   %CSS调制带宽
SF=6;                                       %CSS调制SF因子
samp_per_code=5;                          %CSS调制每个扩频code时间段内的采样点数
symbol_value=34;                            %当前待调试的符号值
N=2^SF;                                     %code 总数
T_symbol=N/BW                              %symbol占用时间
SampleRate=samp_per_code*BW;                %实际采样率
Npts=samp_per_code*N;                       %总采样点数
t=(0:Npts)/SampleRate;                      %CSS调制抽样时刻，需要的采样时刻序号应该为0：Npts-1，最后一个用于验证相位连续性
init_freq=symbol_value/N*BW;                %初始频率
k=BW/T_symbol;                              %频率增加斜率
%%Lora CSS 调制方法1
freq1=init_freq+k*t;                        %根据初始频率生成线性扫频
freq2=mod(freq1,BW);                        %将freq1限制在0~BW带宽内
freq3=freq2-BW/2;                           %将freq2中心频率设置为0
tmp=cumtrapz(t,freq3);                      %使用累计梯形数值积分函数，进行相位积分
phase_final1=tmp(end)                       %最后一个点用于观察相位连续性
Theta_Method1=tmp(1:end-1);                  %删除最后一个点
 
%%Lora CSS 调制方法2
Npts1=samp_per_code*(N-symbol_value);       %t1时间段对应总采样点数
t1=(0:Npts1)/SampleRate;                    %t1时间段实际相位采样时刻，需要的采样时刻序号应该为0：Npts1-1，最后一个点为第二段的起始相位
tmp=(init_freq-BW/2)*t1+1/2*k*t1.*t1;       %根据第一段相位公式计算
Theta1=tmp(1:end-1);                        %第一段相位取值
Theta_init=tmp(end);                         %第一段相位在t1时刻的取值
t2=(Npts1:Npts)/SampleRate;                 %第二段相位采样时刻
t2=t2-t1(end);                              
tmp=1/2*k*t2.*t2-BW/2*t2+Theta_init;        %根据第二段相位公式计算
phase_final2=tmp(end) 
Theta_Method2=[Theta1 tmp(1:end-1)];
figure('Name', 'CSS Phase','NumberTitle', 'off');
plot(t(1:end-1),Theta_Method1)
hold on
plot(t(1:end-1),Theta_Method2)
hold off         
s=exp(j*2*pi*Theta_Method2);
figure('Name', 'waveform','NumberTitle', 'off');
plot(real(s))
hold on
plot(imag(s))
hold off