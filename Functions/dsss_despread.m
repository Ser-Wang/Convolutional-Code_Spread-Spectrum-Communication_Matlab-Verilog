function [despread] = dsss_despread(signal, m_seq)
% 解扩
% 前级输入信号为解调后的二进制序列，需转为双极性序列
    signal_bip = 2 * signal - 1;
    L = length(m_seq);
    signal_re = reshape(signal_bip, L, [])';
    y1 = signal_re * m_seq;
    despread = y1 > 0;
end