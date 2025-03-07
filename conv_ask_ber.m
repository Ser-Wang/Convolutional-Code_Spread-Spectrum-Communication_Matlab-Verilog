function [ber] = conv_ask_ber(L_length, ask_depth, EbNo_dB_vec, constraintLength, trellis, traceback_depth)
% 卷积码编译码仿真
% clc;
% clear;
% 变量命名说明：
% 信息比特：info_bits；卷积码编码后比特：x；调制后比特：x_ask_100等；加信道噪声后比特：y_noisy_ask_100

% Parameters
% codeRate = 1/2;         % 编码速率
% EbNo_dB_vec = 0:2:10;   % 比特能量与噪声功率谱密度比（dB）
% ask_depth = 1;
% info_length = 100000;   % 信息序列长度
% Trellis
% constraintLength = 3;       % 卷积码约束长度
% trellis = poly2trellis(constraintLength, [7 5]);    % 生成多项式为 [111, 101]，约束长度为 3

info_bits = randi([0, 1], L_length, 1); % 生成随机二进制信息序列

ASK_amplitude_0 = 1 - ask_depth;
ASK_amplitude_1 = 1;
hard_threshold = 1 - ask_depth / 2;

% Result storage
ber = zeros(size(EbNo_dB_vec));

%% Encode
x = convenc(info_bits, trellis);

% Modulation
x_modulated = zeros(size(x));     %预分配内存，变量会随i_x的迭代次数改变，与分配内存以提高运行速度
% ASK
for i_x = 1 : length(x)
    if x(i_x) == 1
        x_modulated(i_x) = ASK_amplitude_1; % 幅度为1
    else
        x_modulated(i_x) = ASK_amplitude_0; % 幅度为0
    end
end


% Noise
for i_ebno = 1 : length(EbNo_dB_vec)

%     noisePower = 1 / (2 * codeRate * 10^(EbNo_dB_vec(i_ebno)/10));
%     noisePower = 1 / (2 * 10^(EbNo_dB(i_ebno)/10)); 
%     noise = sqrt(noisePower) * randn(size(x)); 
%     y_noisy_ask_100 = x_ask_100 + noise;
    y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');

    % Demodulate - Hard
    y_demodulated = (y_noisy > hard_threshold);

    % Decode
    x_decoded = vitdec(y_demodulated, trellis, traceback_depth, 'trunc', 'hard');

%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [~ , ber(i_ebno)] = biterr(info_bits, x_decoded);
end

% figure;
% % semilogy(EbNo_dB_vec, ber_comp, 'o-', EbNo_dB_vec, ber, 's-', EbNo_dB_vec, ber_ask_100, '^-');
% semilogy(EbNo_dB_vec, ber, 's-');
% legend('ber');
% title('不同 ASK 调制深度下的误码率性能');
% xlabel('Eb/No (dB)');
% ylabel('误码率 (BER)');
% grid on;

end

