function [x_modulated] = modulate(modulation_cell, x)
% 调制，支持ASK, BPSK
% 输入可能为扩频后的双极性序列，也可能为未扩频仅编码的二进制序列



x_modulated = zeros(size(x));

switch lower(modulation_cell{1})
    case {'ask'}
        ask_depth = modulation_cell{2};
        ASK_amplitude_0 = 1 - ask_depth;
        ASK_amplitude_1 = 1;
        for i_x = 1 : length(x)
            if x(i_x) == 1
                x_modulated(i_x) = ASK_amplitude_1; % 幅度为1
            else    % 二进制0或双极性-1均可
                x_modulated(i_x) = ASK_amplitude_0; % 幅度为0
            end
        end
    case {'bpsk'}
            x_modulated = 1 - 2 * x;
end
end

