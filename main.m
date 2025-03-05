clc;
clear;
% Parameters
max_runs = 30;
info_length = 256;   % 信息序列长度
codeRate = 1/2;         % 编码速率
EbNo_dB_vec = 0:2:10;   % 比特能量与噪声功率谱密度比（dB）


%% Comparision Parameters
num_comp = 4;

% Variables
c = 1;
ask_depths(c) = 0.8;
constraintLengths(c) = 3;                                   % 卷积码约束长度
trelliss(c) = poly2trellis(constraintLengths(c), [7 5]);    % 生成多项式为 [111, 101]，约束长度为 3

c = 2;
ask_depths(c) = 0.8;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [7 5]); 

c = 3;
ask_depths(c) = 0.8;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [7 5]); 

c = 4;
ask_depths(c) = 0.8;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [7 5]); 

% ber storage
ber_sum = zeros(num_comp, length(EbNo_dB_vec));     %每行对应一个对比条件，列对应多个信噪比，命令行窗口打印时矩阵会转置

% Print
print_resolution = 5;
print_matrix = zeros(length(EbNo_dB_vec),4);
print_matrix(:,1) = EbNo_dB_vec';

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
xlabel('Run times');
ylabel('BER');
grid on;

%% Begin
ber = zeros(num_comp, length(EbNo_dB_vec));
for i_runs = 1 : max_runs
    info_bits = randi([0, 1], info_length, 1); % 生成随机二进制信息序列

%     [ber(1, :)] = conv_ask_ber(info_bits, ask_depth_30, EbNo_dB_vec, constraintLength, trellis);
%     [ber(2, :)] = conv_ask_ber(info_bits, ask_depth_80, EbNo_dB_vec, constraintLength, trellis);
%     [ber(3, :)] = conv_ask_ber(info_bits, ask_depth_100, EbNo_dB_vec, constraintLength, trellis);

    for i_comp = 1 : num_comp   % i_comp指第i个对比条件，对应上面的第i行函数调用
        [ber(i_comp, :)] = conv_ask_ber(info_bits, ask_depths(i_comp), EbNo_dB_vec, constraintLengths(i_comp), trelliss(i_comp));
        ber_sum(i_comp, :) = ber_sum(i_comp, :) + ber(i_comp, :);
    end

    % Print
    if(mod(i_runs,print_resolution) == 0)
        for i_comp = 1 : num_comp
        print_matrix(:, i_comp + 1) = ber_sum(i_comp, :)'./i_runs;
        end
        disp(' ');
        disp(['Current run_time = ' num2str(i_runs)]);
        disp('ebno       ber_ask30 ber_ask80 ber_ask100');
        disp(num2str(print_matrix, '%.6f '));
    % Moniter
        monitor_matrix(1,i_runs / print_resolution) = print_matrix(3,2)';   %调制深度越浅，信噪比越低，随机性越强
        set(hPlot30, 'YData', monitor_matrix(1,:));
%         set(hPlot80, 'YData', print_matrix(:, 3)');
%         set(hPlot100, 'YData', print_matrix(:, 4)');
        drawnow;
    end
end


%% Final Result
ber_avg = zeros(num_comp, length(EbNo_dB_vec));
for i_comp = 1 : num_comp      %这里用i_comp1是为了避免重复使用前面用过的i_comp，但我也不确定这里重复使用会不会出问题
    ber_avg(i_comp, :) = ber_sum(i_comp, :) / max_runs;
end

markers = {'o-', 's-', '^-', 'd-', 'p-', 'h-', '+-'};
figure;
hold on;    %hold on启动图形保持，当前的普通坐标轴也会被保持，semilogy将无法改变坐标轴为对数坐标.
for i_comp = 1 : num_comp 
    semilogy(EbNo_dB_vec, ber_avg(i_comp, :), markers{i_comp});     % 笔记： {}提取的是单元格内容，()提取的是一个单元格数组的子集。若使用了markers(i)，则marker的类型将是cell而非char
end
hold off;
legend('ASK 调制深度 30%', 'ASK 调制深度 80%', 'ASK 调制深度 100%', 'legend4');
title('不同 ASK 调制深度下的误码率性能');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;
set(gca, 'YScale', 'log');  %强制设置y轴为对数坐标
