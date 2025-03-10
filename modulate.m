function [x_modulated] = modulate(ask_depth, x)


ASK_amplitude_0 = 1 - ask_depth;
ASK_amplitude_1 = 1;


x_modulated = zeros(size(x));     %预分配内存，变量会随i_x的迭代次数改变，与分配内存以提高运行速度

% ASK
for i_x = 1 : length(x)
    if x(i_x) == 1
        x_modulated(i_x) = ASK_amplitude_1; % 幅度为1
    else
        x_modulated(i_x) = ASK_amplitude_0; % 幅度为0
    end
end



end

