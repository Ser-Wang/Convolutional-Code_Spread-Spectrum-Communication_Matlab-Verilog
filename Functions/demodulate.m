function [y_demodulated] = demodulate(modulation_cell, y_noisy)
% 解调
% 后级可能为解扩，需要双极性序列；也可能为卷积译码，需要二进制序列。故采用二进制序列输出

switch lower(modulation_cell{1})
    case {'ask'}
        ask_depth = modulation_cell{2};
        hard_threshold_ask = 1 - ask_depth / 2;
        y_demodulated = (y_noisy > hard_threshold_ask);
    case {'bpsk'}
        y_demodulated = (y_noisy <= 0);
end
end

