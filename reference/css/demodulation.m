close all; clear all; clc;
BW=500e3;                                                                   %CSS调制带宽
SF=6;                                                                       %CSS调制SF因子
samp_per_code=20;                                                           %CSS调制每个扩频code时间段内的采样点数
symbol_value=60                                                             %当前待调试的符号值
N=2^SF;                                                                     %code 总数
T_symbol=N/BW                                                               %symbol占用时间
SampleRate=samp_per_code*BW                                                 %实际采样率
Npts=samp_per_code*N                                                        %总采样点数
t=(0:Npts)/SampleRate;                                                      %CSS调制抽样时刻，需要的采样时刻序号应该为0：Npts-1，最后一个用于验证相位连续性
init_freq=symbol_value/N*BW;                                                %初始频率
k=BW/T_symbol;                                                              %频率增加斜率
 
[s0,SampleRate]=LoRa_CSSModDemo(symbol_value, SF, BW, samp_per_code);       %CSS调制
s0=awgn(s0,20,'measured');                                                  %添加高斯白噪声   
 
freqin1=(symbol_value/N*BW)/1e3                                             %符号对应起始频率，单位kHz
freqin2=(symbol_value/N*BW-BW)/1e3                                          %符号对应起始频率减带宽，单位kHz
freq_res=SampleRate/Npts                                                    %fft频谱分辨率
BW_npts=BW/freq_res                                                         %频率为BW时对应的采样点数,数值上应该等于2^SF
[s1,SampleRate]=LoRa_DownChirpDemo(SF, BW, samp_per_code);                  %创建标准的down-chirp信号
 
ft=fft(s0.*s1)/Npts;                                                        %相乘后做FFT运算
fvalue=[-BW_npts+1:BW_npts-1]*freq_res/1e3;                                 %频率刻度，从-BW+fr至BW-fr
fftvalue=[ft(end-BW_npts+2:end) ft(1:BW_npts)];                             %根据FFT性质，抽取上述频率对应数组下标
figure('Name', 'CSS FFT Freq','NumberTitle', 'off')
plot(fvalue,abs(fftvalue))                                                  %作图
 
Codevalue=[-BW_npts+1:BW_npts-1];                                           %频率刻度，从-BW+fr至BW-fr
figure('Name', 'CSS FFT Code','NumberTitle', 'off')                         %频率幅度与码片对应关系
plot(Codevalue,abs(fftvalue))  
ft1=abs(ft(1:BW_npts));                                                     %获取正频率BW内信号分量
ft2=abs(ft(end-BW_npts+2:end));                                             %获取负频率BW内信号分量
ft2=[0 ft2];                                                                %补充直流分量，使得两个数组长度像等
ft_add=ft1+ft2;                                                             %直接幅度相加
[a b]=max(ft_add);                                                          %搜索最大值
symbol_value_DeMod=b-1



function [s,SampleRate]=LoRa_CSSModDemo(S_Value, SF, BW, samp_per_code)
%S_Value: 待调制的符号，取值0~2^SF-1
%SF;扩频因子
%BW：调制带宽
%samp_per_code：每个code的采样点数
NCode=2^SF;                                                                 %code 总数
T_symbol=NCode/BW;                                                          %symbol占用时间
SampleRate=samp_per_code*BW;                                                %实际采样率
Npts=samp_per_code*NCode;                                                   %总采样点数
init_freq=S_Value/NCode*BW;                                                 %初始频率
k=BW/T_symbol;                                                              %频率增加斜率
Npts1=samp_per_code*(NCode-S_Value);                                        %t1时间段对应总采样点数
 
 
t1=(0:Npts1)/SampleRate;                                                    %t1时间段实际相位采样时刻，需要的采样时刻序号应该为0：Npts1-1，最后一个点为第二段的起始相位
tmp=(init_freq-BW/2)*t1+1/2*k*t1.*t1;                                       %根据第一段相位公式计算
Theta1=tmp(1:end-1);                                                        %第一段相位取值
Theta_init=tmp(end);                                                        %第一段相位在t1时刻的取值
t2=(Npts1:Npts)/SampleRate;                                                 %第二段相位采样时刻
t2=t2-t1(end);                              
tmp=1/2*k*t2.*t2-BW/2*t2+Theta_init;                                        %根据第二段相位公式计算
Theta_All=[Theta1 tmp(1:end-1)];
s=exp(j*2*pi*Theta_All);
 
end


function [s,SampleRate]=LoRa_DownChirpDemo(SF, BW, samp_per_code)
%产生从BW/2至-BW/2的线性扫频
%SF;扩频因子
%BW：调制带宽
%samp_per_code：每个code的采样点数
N=2^SF;                                     %code 总数
T_symbol=N/BW;                              %symbol占用时间
SampleRate=samp_per_code*BW;                %实际采样率
k=BW/T_symbol;                              %频率增加斜率
Npts=samp_per_code*N;                       %总采样点数
t=(0:Npts-1)/SampleRate;
tmp=BW/2*t-1/2*k*t.*t;        %根据第二段相位公式计算
s=exp(j*2*pi*tmp);
 
end