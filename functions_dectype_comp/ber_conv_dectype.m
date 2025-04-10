function [ber_num, ber] = ber_conv_dectype(L_length, EbNo_dB_vec, modulation_cell, trellis, traceback_depth, R_conv, num_comp)
% 卷积码BER性能仿真：编码-调制-加噪-解调-译码

% Result storage
ber_num = zeros(length(EbNo_dB_vec), num_comp);
ber = zeros(length(EbNo_dB_vec), num_comp);

%% Encode
info_bits = randi([0, 1], L_length, 1); % 生成随机二进制信息序列
x = convenc(info_bits, trellis);
x_modulated = modulate(modulation_cell, x);

% Noise
for i_ebno = 1 : length(EbNo_dB_vec)
    % add noise
    [y_noisy, sigma] = noisy_dectype(x_modulated, EbNo_dB_vec(i_ebno), R_conv);
    % Demodulate - Hard
    y_demodulated = demodulate(modulation_cell, y_noisy);
    % Quantize
    partition = [-1*(6*sigma+2)*3/8:(6*sigma+2)/8:(6*sigma+2)*3/8];    %设置等距量化区间，进行均匀量化
    codebook = [2^3-1:-1:0];      %设置比量化区间partition对应的信号量化值多一个向量
    [~,quants,~] = quantiz(y_noisy,partition,codebook);

    % Decode
    x_esti_hard = vitdec(y_demodulated, trellis, traceback_depth, 'trunc', 'hard');
    x_esti_unquant = vitdec(y_noisy, trellis, traceback_depth, 'trunc', 'unquant');
    x_esti_3bit = vitdec(quants,trellis,traceback_depth,'trunc','soft',3);
    x_esti_3bit_T = x_esti_3bit';
    [ber_num(i_ebno,1), ber(i_ebno,1)] = biterr(info_bits, x_esti_hard);
    [ber_num(i_ebno,2), ber(i_ebno,2)] = biterr(info_bits, x_esti_unquant);
    [ber_num(i_ebno,3), ber(i_ebno,3)] = biterr(info_bits, x_esti_3bit_T);
%     [ber_num(i_ebno,1), ber(i_ebno,1)] = biterr(info_bits, x_esti_3bit_T);
end

end


