% https://blog.csdn.net/qq_40598185/article/details/90680704

%2PSK调制
%初始化定义
clc;
clear all;
n = 1000000;%需要计算的数值
source = zeros(n,1);
jungle = zeros(n,1);
ration = zeros(10,1);
%产生二进制信号源
a = randi([0,1],n,1);
%调制
for k=1:n
if(a(k) == 1)
    source(k) = -1;
elseif (a(k) == 0)
    source(k) = 1;
end
end
EbN0_dB = 0:1:9;
EbN0 = 10.^(EbN0_dB/10);
for i=1:10
Average_Power = sum(abs(source).^2)/n;
Sigma = sqrt(Average_Power*10^(-(i-1)/10));     % 噪声功率开方
Noise =(randn(n,1)+1i*randn(n,1))/sqrt(2);
Bit_Noise = source+Noise*Sigma;
%判决
    for j=1:n
        if (Bit_Noise(j)<0)
           jungle(j) = 1;
        else
           jungle(j) = 0;
        end  
    end
%计算误码率
[number,ration(i)]=biterr(a,jungle);
end
%画出理论2PSK相干解调的理论值与实际值曲线曲线
BER = 0.5.*erfc(sqrt(EbN0));
semilogy(EbN0_dB,BER,'-or',EbN0_dB,ration,'-*b')
grid on
ylabel('Pe')
xlabel('r/dB')
title('2PSK相干解调理论值曲线与实际值曲线')
legend('2PSK理论值曲线','2PSK实际值曲线')
 
 
 
 