function [ber] = ber_man_only(L_length, EbNo_dB_vec, modulation_cell)
% 卷积码BER性能仿真：曼彻斯特编码-调制-加噪-解调-译码

% Result storage
ber = zeros(size(EbNo_dB_vec));

info_bits = randi([0, 1], L_length, 1);
x = manenc(info_bits);

x_modulated = modulate(modulation_cell, x);

% Noise
for i_ebno = 1 : length(EbNo_dB_vec)
    % add noise
    y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');
    % Demodulate - Hard
    y_demodulated = demodulate(modulation_cell, y_noisy);
    % Decode
    x_decoded = mandec(y_demodulated);
%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [~ , ber(i_ebno)] = biterr(info_bits, x_decoded);
end

end

