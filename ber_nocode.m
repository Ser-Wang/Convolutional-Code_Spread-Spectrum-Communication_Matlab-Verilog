function [ber] = ber_nocode(L_length, EbNo_dB_vec, ask_depth)
% 卷积码BER性能仿真：无编码-调制-加噪-解调

% Result storage
ber = zeros(size(EbNo_dB_vec));

info_bits = randi([0, 1], L_length, 1);
x = info_bits;

x_modulated = modulate(ask_depth, x);

% Noise
for i_ebno = 1 : length(EbNo_dB_vec)
    % add noise
    y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');
    % Demodulate - Hard
    y_demodulated = demodulate(ask_depth,y_noisy);
    % Decode
    x_decoded = y_demodulated;
%     [numErrors_ask_100, ber_ask_100(i_ebno)] = biterr(info_bits, decoded_ask_100);
    [~ , ber(i_ebno)] = biterr(info_bits, x_decoded);
end

end

