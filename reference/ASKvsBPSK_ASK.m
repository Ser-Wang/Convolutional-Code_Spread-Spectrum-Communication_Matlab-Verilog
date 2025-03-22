%2ASK调制
%初始化定义
clc;
clear all;
n = 100000;%需要计算的数值
jungle = zeros(n,1);
ration = zeros(16,1);
%产生二进制信号源
source = randi([0,1],n,1);
EbN0_dB = 0:1:15;
EbN0 = 10.^(EbN0_dB/10);
for i=1:16
%添加高斯白噪声
Bit_Noise = awgn(source,EbN0_dB(i),'measured');
%判决
for j=1:n
    if(Bit_Noise(j)<0.5)
           jungle(j) = 0;
    else
           jungle(j) = 1;
    end  
end
%计算误码率
[number,ration(i)]=biterr(source,jungle);
end
%画出2ASK相干解调的理论值与实际值曲线
BER = 1/2.*erfc(sqrt(EbN0/4));
semilogy(EbN0_dB,BER,'-or',EbN0_dB,ration,'-*b')
grid on
ylabel('Pe')
xlabel('r/dB')
title('2ASK相干解调理论值曲线与实际值曲线')
legend('2ASK理论误码率曲线','2ASK实际误码率曲线')
 
 
 