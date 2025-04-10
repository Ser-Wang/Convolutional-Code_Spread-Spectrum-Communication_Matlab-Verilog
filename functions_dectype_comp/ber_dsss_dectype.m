function [ber_num, ber] = ber_dsss_dectype(L_length, EbNo_dB_vec, modulation_cell, trellis, traceback_depth, R_conv, dsss_cell, num_comp)
% 卷积码BER性能仿真：编码-扩频-调制-加噪-解调-解扩-译码

% Result storage
ber_num = zeros(length(EbNo_dB_vec), num_comp);
ber = zeros(length(EbNo_dB_vec), num_comp);

m_seq = mseq(dsss_cell);    % 双极性形式的m序列
L_mseq = length(m_seq);
%% Encode
info_bits = randi([0, 1], L_length, 1); % 生成随机二进制信息序列
x = convenc(info_bits, trellis);
spread_x = dsss_spread(x, m_seq);       % 输出为二进制序列
x_modulated = modulate(modulation_cell, spread_x);

% Noise
for i_ebno = 1 : length(EbNo_dB_vec)
    % add noise
%     y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');
    [y_noisy, sigma] = noisy_dectype(x_modulated, EbNo_dB_vec(i_ebno), R_conv);
    % Demodulate - Hard
    y_demodulated = demodulate(modulation_cell, y_noisy);
    % 解扩
    [despread_hard, despread_unquant] = despread_dectype(m_seq, y_demodulated, y_noisy);



    % Quantize
    partition = [-1*L_mseq*(6*sigma+2)*3/8:L_mseq*(6*sigma+2)/8:L_mseq*(6*sigma+2)*3/8];    %设置等距量化区间，进行均匀量化
    codebook = [2^3-1:-1:0];      %设置比量化区间partition对应的信号量化值多一个向量
    [~,quants,~] = quantiz(despread_unquant,partition,codebook);

    % Decode
%     x_esti_hard = vitdec(despread_hard, trellis, traceback_depth, 'trunc', 'hard');
    % x_esti_unquant = vitdec(despread_unquant, trellis, traceback_depth, 'trunc', 'unquant');
    x_esti_3bit = vitdec(quants,trellis,traceback_depth,'trunc','soft',3);
    x_esti_3bit_T = x_esti_3bit';
%     [ber_num(i_ebno,1), ber(i_ebno,1)] = biterr(info_bits, x_esti_hard);
    % [ber_num(i_ebno,2), ber(i_ebno,2)] = biterr(info_bits, x_esti_unquant);
    % [ber_num(i_ebno,3), ber(i_ebno,3)] = biterr(info_bits, x_esti_3bit_T);
    [ber_num(i_ebno,1), ber(i_ebno,1)] = biterr(info_bits, x_esti_3bit_T);
end

end




