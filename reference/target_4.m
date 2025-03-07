% 卷积码编译码及误码率性能仿真
clc;
clear;
% 定义卷积码生成多项式
trellis = poly2trellis(3, [7 5]); % 生成多项式为 [111, 101]，约束长度为 3

% 仿真参数
rate = 20000; % 数据速率
EbNo_dB = 0:2:10; % 信噪比范围（dB）
numBits = 100000; % 传输的比特数

% 存储不同调制深度下的误码率
ber_ask_30 = zeros(size(EbNo_dB));
ber_ask_80 = zeros(size(EbNo_dB));
ber_ask_100 = zeros(size(EbNo_dB));


% 生成随机二进制信息序列
msg = randi([0 1], numBits, 1);

% % 绘制原始信息序列的波形图
% figure;
% stem(0:numBits-1, msg, 'LineWidth', 1);
% title('原始信息序列 (速率 = 20k Hz)');
% xlabel('比特索引');
% ylabel('比特值');
% grid on;
% % 设置 x 轴范围和刻度
% xlim([0 50]); % 只显示前 50 个比特
% ylim([-0.5 1.5]);
% set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2

% 卷积编码
encodedMsg = convenc(msg, trellis);

% % 绘制编码后的序列波形图
% figure;
% stem(0:length(encodedMsg)-1, encodedMsg, 'LineWidth', 1);
% title('编码后的序列 (速率 = 20k Hz)');
% xlabel('符号索引');
% ylabel('编码符号值');
% grid on;
% % 设置 x 轴范围和刻度
% xlim([0 50]); % 只显示前 50 个符号
% ylim([-0.5 1.5]);
% set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2


% ASK 调制深度为 30%
modSignal_ask_30 = (2*encodedMsg - 1) * 0.3;

% 绘制 ASK 调制深度为 30% 的信号波形图
figure;
plot(0:length(modSignal_ask_30)-1, modSignal_ask_30, 'LineWidth', 1);
title('ASK 调制深度为 30% 的信号 (速率 = 20k Hz)');
xlabel('符号索引');
ylabel('信号幅度');
grid on;
% 设置 x 轴范围和刻度
xlim([0 50]); % 只显示前 50 个符号
ylim([-0.5 0.5]);
set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2


% ASK 调制深度为 80%
modSignal_ask_80 = (2*encodedMsg - 1) * 0.8;

% 绘制 ASK 调制深度为 80% 的信号波形图
figure;
plot(0:length(modSignal_ask_80)-1, modSignal_ask_80, 'LineWidth', 1);
title('ASK 调制深度为 80% 的信号 (速率 = 20k Hz)');
xlabel('符号索引');
ylabel('信号幅度');
grid on;
% 设置 x 轴范围和刻度
xlim([0 50]); % 只显示前 50 个符号
ylim([-0.5 0.5]);
set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2


% ASK 调制深度为 100% (常规 ASK)
modSignal_ask_100 = 2*encodedMsg - 1;

% 绘制 ASK 调制深度为 100% 的信号波形图
figure;
plot(0:length(modSignal_ask_100)-1, modSignal_ask_100, 'LineWidth', 1);
title('ASK 调制深度为 100% 的信号 (速率 = 20k Hz)');
xlabel('符号索引');
ylabel('信号幅度');
grid on;
% 设置 x 轴范围和刻度
xlim([0 50]); % 只显示前 50 个符号
ylim([-0.5 0.5]);
set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2


for i = 1:length(EbNo_dB)
    % 加入 AWGN 噪声 for ASK 30%
    EbNo = 10^(EbNo_dB(i)/10);
    noisePower = 1 / (2 * EbNo);
    noisySignal_ask_30 = modSignal_ask_30 + sqrt(noisePower) * randn(size(modSignal_ask_30));
    
%     % 绘制加入噪声后的 ASK 30% 信号波形图
%     figure;
%     plot(0:length(noisySignal_ask_30)-1, noisySignal_ask_30, 'LineWidth', 1);
%     title(['加入 AWGN 噪声后的 ASK 30% 信号 (Eb/No = ' num2str(EbNo_dB(i)) ' dB)']);
%     xlabel('符号索引');
%     ylabel('信号幅度');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 0.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 解调 ASK 30%：硬判决
    receivedMsg_ask_30 = (noisySignal_ask_30 > 0);
    
%     % 绘制解调后的 ASK 30% 序列波形图
%     figure;
%     stem(0:length(receivedMsg_ask_30)-1, receivedMsg_ask_30, 'LineWidth', 1);
%     title(['解调后的 ASK 30% 序列 (Eb/No = ' num2str(EbNo_dB(i)) ' dB)']);
%     xlabel('符号索引');
%     ylabel('比特值');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 1.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 维特比译码 ASK 30%
    decodedMsg_ask_30 = vitdec(receivedMsg_ask_30, trellis, 5, 'trunc', 'hard');
    
%     % 绘制译码后的 ASK 30% 序列波形图
%     figure;
%     stem(0:length(decodedMsg_ask_30)-1, decodedMsg_ask_30, 'LineWidth', 1);
%     title(['译码后的 ASK 30% 序列 (Eb/No = ' num2str(EbNo_dB(i)) ' dB)']);
%     xlabel('比特索引');
%     ylabel('比特值');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 1.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 计算 ASK 30% 误码率
    [numErrors_ask_30, ber_ask_30(i)] = biterr(msg, decodedMsg_ask_30);
    
    % 加入 AWGN 噪声 for ASK 80%
    noisySignal_ask_80 = modSignal_ask_80 + sqrt(noisePower) * randn(size(modSignal_ask_80));
    
%     % 绘制加入噪声后的 ASK 80% 信号波形图
%     figure;
%     plot(0:length(noisySignal_ask_80)-1, noisySignal_ask_80, 'LineWidth', 1);
%     title(['加入 AWGN 噪声后的 ASK 80% 信号 (Eb/No = ' num2str(EbNo_dB(i)) ' dB)']);
%     xlabel('符号索引');
%     ylabel('信号幅度');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 0.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 解调 ASK 80%：硬判决
    receivedMsg_ask_80 = (noisySignal_ask_80 > 0);
    
%     % 绘制解调后的 ASK 80% 序列波形图
%     figure;
%     stem(0:length(receivedMsg_ask_80)-1, receivedMsg_ask_80, 'LineWidth', 1);
%     title (strcat('解调后的 ASK 80% 序列 (Eb/No = ', num2str(EbNo_dB(i)), ' dB)'))
%     xlabel('符号索引');
%     ylabel('比特值');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 1.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 维特比译码 ASK 80%
    decodedMsg_ask_80 = vitdec(receivedMsg_ask_80, trellis, 5, 'trunc', 'hard');
    
%     % 绘制译码后的 ASK 80% 序列波形图
%     figure;
%     stem(0:length(decodedMsg_ask_80)-1, decodedMsg_ask_80, 'LineWidth', 1);
%     title (strcat('译码后的 ASK 80% 序列 (Eb/No = ', num2str(EbNo_dB(i)), ' dB)'))
%     xlabel('比特索引');
%     ylabel('比特值');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 1.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 计算 ASK 80% 误码率
    [numErrors_ask_80, ber_ask_80(i)] = biterr(msg, decodedMsg_ask_80);
    
    % 加入 AWGN 噪声 for ASK 100%
    noisySignal_ask_100 = modSignal_ask_100 + sqrt(noisePower) * randn(size(modSignal_ask_100));
    
%     % 绘制加入噪声后的 ASK 100% 信号波形图
%     figure;
%     plot(0:length(noisySignal_ask_100)-1, noisySignal_ask_100, 'LineWidth', 1);
%     title (strcat('加入 AWGN 噪声后的 ASK 100% 信号 (Eb/No =', num2str(EbNo_dB(i)), ' dB)'))
%     xlabel('符号索引');
%     ylabel('信号幅度');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 0.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 解调 ASK 100%：硬判决
    receivedMsg_ask_100 = (noisySignal_ask_100 > 0);
    
%     % 绘制解调后的 ASK 100% 序列波形图
%     figure;
%     stem(0:length(receivedMsg_ask_100)-1, receivedMsg_ask_100, 'LineWidth', 1);
%     title (strcat('解调后的 ASK 100% 序列 (Eb/No =', num2str(EbNo_dB(i)), ' dB)'))
%     xlabel('符号索引');
%     ylabel('比特值');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 1.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 维特比译码 ASK 100%
    decodedMsg_ask_100 = vitdec(receivedMsg_ask_100, trellis, 5, 'trunc', 'hard');
    
%     % 绘制译码后的 ASK 100% 序列波形图
%     figure;
%     stem(0:length(decodedMsg_ask_100)-1, decodedMsg_ask_100, 'LineWidth', 1);
%     title (strcat('译码后的 ASK 100% 序列 (Eb/No =', num2str(EbNo_dB(i)), ' dB)'))
%     xlabel('比特索引');
%     ylabel('比特值');
%     grid on;
%     % 设置 x 轴范围和刻度
%     xlim([0 50]); % 只显示前 50 个符号
%     ylim([-0.5 1.5]);
%     set(gca,'XTick',0:2:50); % 设置 x 轴刻度间隔为 2
    
    % 计算 ASK 100% 误码率
    [numErrors_ask_100, ber_ask_100(i)] = biterr(msg, decodedMsg_ask_100);
end


% 绘制误码率曲线
figure;
semilogy(EbNo_dB, ber_ask_30, 'o-', EbNo_dB, ber_ask_80, 's-', EbNo_dB, ber_ask_100, '^-');
legend('ASK 调制深度 30%', 'ASK 调制深度 80%', 'ASK 调制深度 100%');
title('20k 速率下卷积编码时不同 ASK 调制深度的误码率性能');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;