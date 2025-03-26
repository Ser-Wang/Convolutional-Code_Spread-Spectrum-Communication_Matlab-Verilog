function [ber_num, ber] = ber_man_conv(L_length, EbNo_dB_vec, modulation_cell, trellis, traceback_depth)
% 卷积码BER性能仿真：曼彻斯特+卷积码-调制-加噪-解调-译码

% Result storage
ber_num = zeros(size(EbNo_dB_vec));
ber = zeros(size(EbNo_dB_vec));

info_bits = randi([0, 1], L_length, 1);
x1 = manenc(info_bits);
x2 = convenc(x1, trellis);

x_modulated = modulate(modulation_cell, x2);

% Noise
for i_ebno = 1 : length(EbNo_dB_vec)
    % add noise
%     y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');
    y_noisy = noisy(x_modulated, EbNo_dB_vec(i_ebno), 0.5);
    % Demodulate - Hard
    y_demodulated = demodulate(modulation_cell, y_noisy);
    % Decode
    x_decoded1 = vitdec(y_demodulated, trellis, traceback_depth, 'trunc', 'hard');
    x_decoded2 = mandec(x_decoded1);
%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [ber_num(i_ebno), ber(i_ebno)] = biterr(info_bits, x_decoded2);
end

end

