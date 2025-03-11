function m_seq = mseq(dsss_cell)
% n = 5;
% taps = [5 3 2];
% reg = ones(1,n); % 寄存器初始化
% reg = [1 0 0 0 0];

n = dsss_cell{1};
taps = dsss_cell{2};
reg = dsss_cell{3};

m_seq = zeros(2^n-1,1);
taps = taps(taps > 0); % 过滤无效抽头位置
for i = 1:2^n-1
    m_seq(i) = 2 * reg(n) - 1;  % 输出最后一位寄存器，转换为双极性
    fb = mod(sum(reg(taps)),2); % 有效抽头求和
    reg = [fb reg(1:n-1)];      % 寄存器移位
end
end