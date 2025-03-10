function m_seq = mseq(n, taps, reg)

% n = 5;
% taps = [5 3 2];
%     reg = ones(1,n); % 寄存器初始化
%     reg = [1 0 0 0 0];

    m_seq = zeros(2^n-1,1);
    taps = taps(taps > 0); % 过滤无效抽头位置
    
    for i = 1:2^n-1
        m_seq(i) = reg(n); % 输出最后一位寄存器
        fb = mod(sum(reg(taps)),2); % 有效抽头求和
        reg = [fb reg(1:n-1)]; % 寄存器移位
    end
end  