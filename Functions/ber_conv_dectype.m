function [ber_num, ber] = ber_conv_dectype(L_length, EbNo_dB_vec, modulation_cell, trellis, traceback_depth, R_conv)
% 卷积码BER性能仿真：编码-调制-加噪-解调-译码

% Result storage
ber_num = zeros(size(EbNo_dB_vec));
ber = zeros(size(EbNo_dB_vec));

%% Encode
info_bits = randi([0, 1], L_length, 1); % 生成随机二进制信息序列
x = convenc(info_bits, trellis);
x_modulated = modulate(modulation_cell, x);

% Noise
for i_ebno = 1 : length(EbNo_dB_vec)
    % add noise
%     y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');
    y_noisy = noisy(x_modulated, EbNo_dB_vec(i_ebno), 2);
    % Demodulate - Hard
    y_demodulated = demodulate(modulation_cell, y_noisy);
    % Decode
    x_decoded = vitdec(y_demodulated, trellis, traceback_depth, 'trunc', 'hard');
%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [ber_num(i_ebno), ber(i_ebno)] = biterr(info_bits, x_decoded);
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


