function [despread_hard, despread_unquant] = despread_dectype(m_seq, sig_hard, sig_unquant)
% 解扩
% 前级输入信号为解调后的二进制序列，需转为双极性序列
% 输出为二进制序列
    sig_hard_bip = 2 * sig_hard - 1;
    L = length(m_seq);
    signal_re = reshape(sig_hard_bip, L, [])';
    y1 = signal_re * m_seq;
    despread_hard = y1 > 0;

    sig_unquant = -1 * sig_unquant;
    sig_unquant_re = reshape(sig_unquant, L, [])';
    y2 = sig_unquant_re * m_seq;
    despread_unquant = -1 * y2;
end