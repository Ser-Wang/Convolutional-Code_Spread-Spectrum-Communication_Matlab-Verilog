function [ber] = test_conv_ask_ber(info_bits, ask_depth, EbNo_dB_vec)
% 卷积码编译码仿真
% clc;
clear;
% 变量命名说明：
% 信息比特：info_bits；卷积码编码后比特：x；调制后比特：x_ask_100等；加信道噪声后比特：y_noisy_ask_100

% Parameters
codeRate = 1/2;         % 编码速率
EbNo_dB_vec = 0:2:10;   % 比特能量与噪声功率谱密度比（dB）
ask_depth = 1;

info_length = 100000;   % 信息序列长度
info_bits = randi([0, 1], info_length, 1); % 生成随机二进制信息序列

ASK_Amplitudes_100 = [0, 1];    % ASK 调制幅度（二进制 ASK）

ASK_amplitude_0 = 1 - ask_depth;
ASK_amplitude_1 = 1;

% Result storage
ber = zeros(size(EbNo_dB_vec));
ber_ask_100 = zeros(size(EbNo_dB_vec));

% Encode
constraintLength = 3;       % 卷积码约束长度
trellis = poly2trellis(constraintLength, [7 5]);    % 生成多项式为 [111, 101]，约束长度为 3

x = convenc(info_bits, trellis);

% ASK调制
x_ask = zeros(size(x));     %预分配内存，变量会随i_x的迭代次数改变，与分配内存以提高运行速度
x_ask100 = zeros(size(x));

for i_x = 1 : length(x)
    if x(i_x) == 1
        x_ask(i_x) = ASK_amplitude_1; % 幅度为1
        x_ask100(i_x) = ASK_Amplitudes_100(2);

    else
        x_ask(i_x) = ASK_amplitude_0; % 幅度为0
        x_ask100(i_x) = ASK_Amplitudes_100(1);
    end
end


% Noise
for i_ebno = 1 : length(EbNo_dB_vec)

%     noisePower = 1 / (2 * codeRate * 10^(EbNo_dB_vec(i_ebno)/10));
%     noisePower = 1 / (2 * 10^(EbNo_dB(i_ebno)/10)); 
%     noise = sqrt(noisePower) * randn(size(x)); 
%     y_noisy_ask_100 = x_ask_100 + noise;
%     y_noisy_ask_80 = x_ask_80 + noise;
%     y_noisy_ask_30 = x_ask_30 + noise;

    y_noisy = awgn(x_ask,EbNo_dB_vec(i_ebno),'measured');
    noise = y_noisy - x_ask;
    y_noisy_ask100 = x_ask100 + noise;
%     y_noisy_ask100 = awgn(x_ask100,EbNo_dB_vec(i_ebno),'measured');
    % Demodulate - Hard
    
    hard_threshold = 1 - ask_depth / 2;
    demodulated_y = (y_noisy > hard_threshold);
    demodulated_y_ask_100 = (y_noisy_ask100 > 0.5);

    % Decode
    x_decoded = vitdec(demodulated_y, trellis, 5*constraintLength, 'trunc', 'hard');
    decoded_ask_100 = vitdec(demodulated_y_ask_100, trellis, 5*constraintLength, 'trunc', 'hard');

%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [~ , ber(i_ebno)] = biterr(info_bits, x_decoded);
    [~ , ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [~ , ber_comp(i_ebno)] = biterr(x_decoded, decoded_ask_100);

end

figure;
semilogy(EbNo_dB_vec, ber_comp, 'o-', EbNo_dB_vec, ber, 's-', EbNo_dB_vec, ber_ask_100, '^-');
legend('ASK 调制深度 30%', 'ASK 调制深度 80%', 'ASK 调制深度 100%');
title('不同 ASK 调制深度下的误码率性能');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;

end

