%% NFC协议改进性能仿真（ASK调制版）
clear; clc;

%% 参数设置
data_length = 1000;       % 每次传输比特数
num_trials = 20;          % 仿真次数
SNR_range = -10:2:20;     % 信噪比范围
m_seq_length = 31;        % m序列长度
trellis = poly2trellis(7, [171 133]); % 标准卷积码

% 预生成m序列（双极性码）
m_seq = 2*mseq(5, [5 3 2])-1;  % 生成31位m序列

% 初始化误码率
ber_original = zeros(size(SNR_range));
ber_improved = zeros(size(SNR_range));

%% 主仿真循环
for snr_idx = 1:length(SNR_range)
    SNR = SNR_range(snr_idx);
    fprintf('Processing SNR: %d dB\n', SNR);
    
    err_ori = 0; err_imp = 0;
    
    for trial = 1:num_trials
        %% 原始数据
        data = randi([0 1], data_length, 1);
        
        %% 原始系统（仅曼彻斯特编码）
        % 编码
        man_enc = manchester_encode(data);
        
        % ASK调制（0->0，1->1）
        tx_sig = man_enc;
        
        % 加噪
        rx_sig = awgn(tx_sig, SNR, 'measured');
        
        % 解调（阈值检测）
        rx_bits = rx_sig > 0.5;
        
        % 解码
        decoded_ori = manchester_decode(rx_bits);
        err_ori = err_ori + sum(data ~= decoded_ori(1:data_length));
        
        %% 改进系统（卷积+曼彻斯特双编码）
%         % 卷积编码
%         conv_enc = convenc(data, trellis);
%         
%         % 曼彻斯特编码
%         man_conv = manchester_encode(conv_enc);
         man_conv = manchester_encode(data);
         conv_enc = convenc(man_conv, trellis);
        
        % DSSS扩频
        spread_sig = dsss_spread(conv_enc, m_seq);
        
        % ASK调制
        tx_sig = spread_sig;
        
        % 加噪
        rx_sig = awgn(tx_sig, SNR, 'measured');
        
        % 解调
        rx_bits = rx_sig > 0.5;
        
        % 解扩
        despread = dsss_despread(rx_bits, m_seq);

         decoded_imp = vitdec(despread, trellis, 34, 'trunc', 'hard');
         decoded_man = manchester_decode(decoded_imp);
         err_imp = err_imp + sum(data ~= decoded_man(1:data_length));
%         
%         % 曼彻斯特解码
%         decoded_man = manchester_decode(despread);
%         
%         % 卷积解码
%         decoded_imp = vitdec(decoded_man, trellis, 34, 'trunc', 'hard');
 %       err_imp = err_imp + sum(data ~= decoded_imp(1:data_length));
    end
    
    ber_original(snr_idx) = err_ori / (data_length*num_trials);
    ber_improved(snr_idx) = err_imp / (data_length*num_trials);
end

%% 结果可视化
figure;
semilogy(SNR_range, ber_original, 'bo-', 'LineWidth', 2); hold on;
semilogy(SNR_range, ber_improved, 'rs-', 'LineWidth', 2);
grid on; xlabel('SNR (dB)'); ylabel('BER');
legend('Original System', 'Improved System');
title('NFC Performance with ASK & Enhanced Codinga(man+con+DSSS)');

%% 核心函数定义
function encoded = manchester_encode(data)
    encoded = repelem(data, 2);          % 复制每个比特
    encoded(2:2:end) = ~encoded(1:2:end);% 取反偶数位
end

function decoded = manchester_decode(signal)
    decoded = signal(1:2:end) & ~signal(2:2:end); % 判断前半周期
end

function spread = dsss_spread(data, m_seq)
    spread = repelem(data, length(m_seq)) .* repmat(m_seq, length(data), 1);
end

function despread = dsss_despread(signal, m_seq)
    L = length(m_seq);
    despread = (reshape(signal, L, [])' * (m_seq > 0)) > L/2; % 相关解扩
end

function m_seq = mseq(n, taps)
    reg = ones(1,n); % 寄存器初始化
    m_seq = zeros(2^n-1,1);
    taps = taps(taps > 0); % 过滤无效抽头位置
    
    for i = 1:2^n-1
        m_seq(i) = reg(n); % 输出最后一位寄存器
        fb = mod(sum(reg(taps)),2); % 有效抽头求和
        reg = [fb reg(1:n-1)]; % 寄存器移位
    end
end