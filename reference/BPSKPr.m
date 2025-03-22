clc;clear all;close all;
num=100000;
for SNR=0:10
    data_bpsk=randsrc(1,num,[1,-1]);
    snr=1/(10^(SNR/10));
    noise=sqrt(snr/2)*(randn(1,num));
    receive=data_bpsk+noise;
    pe(SNR+1)=0;
    for(i=1:num)
        if (receive(i)>=0)
            r_data(i)=1;
        else r_data(i)=-1;
        end
    end
    pe(SNR+1)=(sum(abs((r_data-data_bpsk)/2)))/num;
    peb(SNR+1)=0.5*erfc(sqrt(10^(SNR/10)));
end
r=0:10;
semilogy(r,peb,'b-v',r,pe,'m-x');%对y取底为10对数
grid on;legend('理论误码率曲线','仿真误码率曲线');