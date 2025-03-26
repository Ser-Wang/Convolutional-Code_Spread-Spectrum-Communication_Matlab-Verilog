function [ber_num, ber] = ber_conv_dsss(L_length, EbNo_dB_vec, modulation_cell, trellis, traceback_depth, dsss_cell)
% 卷积码BER性能仿真：编码-扩频-调制-加噪-解调-解扩-译码

% Result storage
ber_num = zeros(size(EbNo_dB_vec));
ber = zeros(size(EbNo_dB_vec));

m_seq = mseq(dsss_cell);    % 双极性形式的m序列

%% Encode
info_bits = randi([0, 1], L_length, 1); % 生成随机二进制信息序列
x = convenc(info_bits, trellis);
spread_x = dsss_spread(x, m_seq);       % 输出为二进制序列
x_modulated = modulate(modulation_cell, spread_x);


% Noise
for i_ebno = 1 : length(EbNo_dB_vec)
    % add noise
%     y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');
    y_noisy = noisy(x_modulated, EbNo_dB_vec(i_ebno), 0.5);
    % Demodulate - Hard
    y_demodulated = demodulate(modulation_cell, y_noisy);
    % 解扩
    y_despread = dsss_despread(y_demodulated, m_seq);
    % Decode
    x_decoded = vitdec(y_despread, trellis, traceback_depth, 'trunc', 'hard');
%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [ber_num(i_ebno), ber(i_ebno)] = biterr(info_bits, x_decoded);
end

end

