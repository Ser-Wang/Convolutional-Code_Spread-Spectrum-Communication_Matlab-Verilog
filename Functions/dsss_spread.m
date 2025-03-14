function [spread] = dsss_spread(data, m_seq)
% 扩频
% 输入：data为二进制序列，需转为双极性序列；m_seq在mseq函数已转为双极性序列输出
% 输出：输出扩频后序列已转换为二进制序列
    data_bip = 2 * data - 1;    % 扩频前信号应处理为双极性序列
    spread = repelem(data_bip, length(m_seq)) .* repmat(m_seq, length(data), 1);
    spread(spread == -1) = 0;
end

    % 知识沉淀笔记：
    % repelem函数是将data中的每个元素依次重复数次，如1010→11001100.
    % repmat函数是将整个m_seq重复数次，如1010→10101010.
    % repmat函数可以用于矩阵的拓展，相当于第一输入参数作为子矩阵，拓展为m行*n列个子矩阵的大矩阵。