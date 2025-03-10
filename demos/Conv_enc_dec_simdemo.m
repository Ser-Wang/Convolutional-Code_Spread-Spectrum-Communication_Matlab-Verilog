
clc;
clear;

% 变量命名说明：
% 信息比特：info_bits；卷积码编码后比特：x；调制后比特：x_ask_100等；加信道噪声后比特：y_noisy_ask_100

% Parameters
info_length = 100000; % 信息序列长度
codeRate = 1/2; % 编码速率
EbNo_dB_vec = 0:2:10; % 比特能量与噪声功率谱密度比（dB）
% EbNo_dB = 5;

ASK_Amplitudes_100 = [0, 1]; % ASK 调制幅度（二进制 ASK）
ASK_Amplitudes_80 = [0.2, 1];
ASK_Amplitudes_30 = [0.7, 1];

% Result storage
ber_ask_30  = zeros(size(EbNo_dB_vec));
ber_ask_80  = zeros(size(EbNo_dB_vec));
ber_ask_100 = zeros(size(EbNo_dB_vec));

% Encode
info_bits = randi([0, 1], info_length, 1); % 生成随机二进制信息序列

constraintLength = 3; % 卷积码约束长度
trellis = poly2trellis(constraintLength, [7 5]); % 生成多项式为 [111, 101]，约束长度为 3

x = convenc(info_bits, trellis);

% ASK调制
x_ask_100 = zeros(size(x)); %预分配内存，变量会随i_x的迭代次数改变，与分配内存以提高运行速度
x_ask_80 = zeros(size(x));
x_ask_30 = zeros(size(x));
for i_x = 1 : length(x)
    if x(i_x) == 1
        x_ask_100(i_x) = ASK_Amplitudes_100(2); % 幅度为1
        x_ask_80(i_x) = ASK_Amplitudes_80(2);   % 幅度为1
        x_ask_30(i_x) = ASK_Amplitudes_30(2);   % 幅度为1
    else
        x_ask_100(i_x) = ASK_Amplitudes_100(1); % 幅度为0
        x_ask_80(i_x) = ASK_Amplitudes_80(1);   % 幅度为0.2
        x_ask_30(i_x) = ASK_Amplitudes_30(1);   % 幅度为0.7
    end
end


% Noise
for i_ebno = 1 : length(EbNo_dB_vec)

    noisePower = 1 / (2 * codeRate * 10^(EbNo_dB_vec(i_ebno)/10)); 
%     noisePower = 1 / (2 * 10^(EbNo_dB(i_ebno)/10)); 
%     noise = sqrt(noisePower) * randn(size(x)); 

%     y_noisy_ask_100 = x_ask_100 + noise;
%     y_noisy_ask_80 = x_ask_80 + noise;
%     y_noisy_ask_30 = x_ask_30 + noise;

    y_noisy_ask_100 = awgn(x_ask_100,EbNo_dB_vec(i_ebno),'measured');
    y_noisy_ask_80 = awgn(x_ask_80,EbNo_dB_vec(i_ebno),'measured');
    y_noisy_ask_30 = awgn(x_ask_30,EbNo_dB_vec(i_ebno),'measured');

    
    % Demodulate - Hard
    demodulated_y_ask_100 = (y_noisy_ask_100 > 0.5);
    demodulated_y_ask_80 = (y_noisy_ask_80 > 0.6);
    demodulated_y_ask_30 = (y_noisy_ask_30 > 0.85);

    % Decode
    decoded_ask_100 = vitdec(demodulated_y_ask_100, trellis, 5*constraintLength, 'trunc', 'hard');
    decoded_ask_80 = vitdec(demodulated_y_ask_80, trellis, 5*constraintLength, 'trunc', 'hard');
    decoded_ask_30 = vitdec(demodulated_y_ask_30, trellis, 5*constraintLength, 'trunc', 'hard');

%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [~ , ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [~ , ber_ask_80(i_ebno)] = biterr(info_bits, decoded_ask_80);
    [~ , ber_ask_30(i_ebno)] = biterr(info_bits, decoded_ask_30);

end

figure;
semilogy(EbNo_dB_vec, ber_ask_30, 'o-', EbNo_dB_vec, ber_ask_80, 's-', EbNo_dB_vec, ber_ask_100, '^-');
legend('ASK 调制深度 30%', 'ASK 调制深度 80%', 'ASK 调制深度 100%');
title('不同 ASK 调制深度下的误码率性能');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;

% % 编码调制噪声结果可视化
% figure;
% subplot(4,1,1);
% stem(info_bits, 'filled'); title('原始信息序列');
% subplot(4,1,2);
% plot(x_ask_30); title('ASK 调制信号');
% subplot(4,1,3);
% plot(noise); title('噪声信号');
% subplot(4,1,4);
% plot(y_noisy_ask_30); title('加入噪声的调制后信号');


