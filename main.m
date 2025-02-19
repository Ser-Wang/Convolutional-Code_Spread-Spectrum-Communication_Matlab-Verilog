clc;
clear;

% Parameters
max_runs = 3000;

info_length = 100000;   % 信息序列长度
codeRate = 1/2;         % 编码速率
EbNo_dB_vec = 0:2:10;   % 比特能量与噪声功率谱密度比（dB）

print_resolution = 5;
print_matrix = zeros(length(EbNo_dB_vec),4);
print_matrix(:,1) = EbNo_dB_vec';

% Variables
ask_depth_30  = 0.3;
ask_depth_80  = 0.8;
ask_depth_100 = 1;

ber_sum_ask30 = zeros(size(EbNo_dB_vec));
ber_sum_ask80 = zeros(size(EbNo_dB_vec));
ber_sum_ask100 = zeros(size(EbNo_dB_vec));

% 实时更新图形
monitor_matrix = nan(max_runs / print_resolution);
hFig = figure;
hold on;
hPlot30 = semilogy(print_resolution:print_resolution:max_runs, nan(max_runs / print_resolution), 'o-');
% hPlot80 = semilogy(EbNo_dB_vec, nan(size(EbNo_dB_vec)), 's-');
% hPlot100 = semilogy(EbNo_dB_vec, nan(size(EbNo_dB_vec)), '^-');
hold off;
legend('ASK 30%');
title('实时平均 BER 曲线');
xlabel('Eb/No (dB)');
ylabel('BER');
grid on;

for i_runs = 1 : max_runs
    info_bits = randi([0, 1], info_length, 1); % 生成随机二进制信息序列

    [ber_ask_30] = conv_ask_ber(info_bits, ask_depth_30, EbNo_dB_vec);
    [ber_ask_80] = conv_ask_ber(info_bits, ask_depth_80, EbNo_dB_vec);
    [ber_ask_100] = conv_ask_ber(info_bits, ask_depth_100, EbNo_dB_vec);

    ber_sum_ask30 = ber_sum_ask30 + ber_ask_30;
    ber_sum_ask80 = ber_sum_ask80 + ber_ask_80;
    ber_sum_ask100 = ber_sum_ask100 + ber_ask_100;

    % Print
    if(mod(i_runs,print_resolution) == 0)
        print_matrix(:, 2) = ber_sum_ask30'./i_runs;
        print_matrix(:, 3) = ber_sum_ask80'./i_runs;
        print_matrix(:, 4) = ber_sum_ask100'./i_runs;
        disp(' ');
        disp(['Current run_time = ' num2str(i_runs)]);
        disp('ebno       ber_ask30 ber_ask80 ber_ask100');
        disp(num2str(print_matrix, '%.6f '));

        monitor_matrix(1,i_runs / print_resolution) = print_matrix(3,2)';   %调制深度越浅，信噪比越低，随机性越强
        set(hPlot30, 'YData', monitor_matrix(1,:));
%         set(hPlot80, 'YData', print_matrix(:, 3)');
%         set(hPlot100, 'YData', print_matrix(:, 4)');
        drawnow;
    end
end

ber_avg_ask30 = ber_sum_ask30 / max_runs;
ber_avg_ask80 = ber_sum_ask80 / max_runs;
ber_avg_ask100 = ber_sum_ask100 / max_runs;

figure;
% semilogy(EbNo_dB_vec, ber_avg_ask30, 'o-', EbNo_dB_vec, ber_avg_ask80, 's-', EbNo_dB_vec, ber_avg_ask100, '^-');
hold on;    %hold on启动图形保持，当前的普通坐标轴也会被保持，semilogy将无法改变坐标轴为对数坐标.
semilogy(EbNo_dB_vec, ber_avg_ask30, 'o-');
semilogy(EbNo_dB_vec, ber_avg_ask80, 's-');
semilogy(EbNo_dB_vec, ber_avg_ask100, '^-');
hold off;
legend('ASK 调制深度 30%', 'ASK 调制深度 80%', 'ASK 调制深度 100%');
title('不同 ASK 调制深度下的误码率性能');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;
set(gca, 'YScale', 'log');  %强制设置y轴为对数坐标
