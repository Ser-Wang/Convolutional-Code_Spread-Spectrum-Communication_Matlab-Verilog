clc;
clear;
addpath('Functions/')
addpath('Setting_templates')
% codeRate = 1/2;         % 编码速率

% Simulation Parameter
% EbNo_dB_vec = -8:1:14;   % 比特能量与噪声功率谱密度比（dB）
EbNo_dB_vec = -12:2:16;
max_runs = 1000000;
print_resolution = 40;
monitor_onoff = 0;      % 1: on; 0: off
num_monitor_comp = 1;   % 实时监测的对比项
num_monitor_ebno = 2;   % 实时监测的信噪比项(index of EbNo_dB_vec)
legends = {};

% run('acurrent_parameter.m');
% run('scheme.m');
% run('g_compare.m');
% run('noise_test.m');
run('R_sameK.m');
num_comp = c;

% ber storage
ber_sum = zeros(num_comp, length(EbNo_dB_vec));     %每行对应一个对比条件，列对应多个信噪比，命令行窗口打印时矩阵会转置
ber_num_sum = zeros(num_comp, length(EbNo_dB_vec));
% Print
print_matrix = zeros(length(EbNo_dB_vec),c+1);  % c列ber数据，首列ebn0
print_matrix(:,1) = EbNo_dB_vec';

% Real-time monitor
if (monitor_onoff == 1)
    monitor_matrix = nan(max_runs / print_resolution);
    hFig = figure;
    hold on;
    hPlot30 = semilogy(print_resolution:print_resolution:max_runs, nan(max_runs / print_resolution), 'o-');
    % hPlot80 = semilogy(EbNo_dB_vec, nan(size(EbNo_dB_vec)), 's-');
    % hPlot100 = semilogy(EbNo_dB_vec, nan(size(EbNo_dB_vec)), '^-');
    hold off;
    legend(legends{num_monitor_comp});
    title(['实时平均 BER 曲线, EbNo = ' num2str(EbNo_dB_vec(num_monitor_ebno))]);
    xlabel('Run times');
    ylabel('BER');
    grid on;
end

%% Begin
ber_num = zeros(num_comp, length(EbNo_dB_vec));
ber = zeros(num_comp, length(EbNo_dB_vec));
for i_runs = 1 : max_runs
    for i_comp = 1 : num_comp   % i_comp指第i个对比条件，对应上面的第i行函数调用
        switch encode_type(i_comp)
            case 0
                [ber_num(i_comp, :), ber(i_comp, :)] = ber_nocode(L_lengths(i_comp), EbNo_dB_vec, modulation_cell(i_comp,:));
            case 1
                [ber_num(i_comp, :), ber(i_comp, :)] = ber_man_only(L_lengths(i_comp), EbNo_dB_vec, modulation_cell(i_comp,:));
            case 2
                [ber_num(i_comp, :), ber(i_comp, :)] = ber_man_conv(L_lengths(i_comp), EbNo_dB_vec, modulation_cell(i_comp,:), trelliss(i_comp), traceback_depths(i_comp), R_conv(i_comp));
            case 3
                [ber_num(i_comp, :), ber(i_comp, :)] = ber_conv(L_lengths(i_comp), EbNo_dB_vec, modulation_cell(i_comp,:), trelliss(i_comp), traceback_depths(i_comp), R_conv(i_comp));
            case 4
                [ber_num(i_comp, :), ber(i_comp, :)] = ber_conv_dsss(L_lengths(i_comp), EbNo_dB_vec, modulation_cell(i_comp,:), trelliss(i_comp), traceback_depths(i_comp), dsss_cell(i_comp,:), R_conv(i_comp));
        end
        ber_sum(i_comp, :) = ber_sum(i_comp, :) + ber(i_comp, :);
        ber_num_sum(i_comp, :) = ber_num_sum(i_comp, :) + ber_num(i_comp, :);
    end
%     n_m(i_comp), taps_m(i_comp,:), reg_m(i_comp,:)
    % Print
    if(mod(i_runs,print_resolution) == 0)
        for i_comp = 1 : num_comp
            print_matrix(:, i_comp + 1) = ber_sum(i_comp, :)'./i_runs;
        end
        disp(' ');
        disp(['Current run_time = ' num2str(i_runs)]);
        %         disp('ebno       ber_ask30 ber_ask80 ber_ask100');
        disp(['ebno      ' legends{:}]);
        disp(num2str(print_matrix, '%.6f '));
        % Moniter
        if(monitor_onoff == 1)
            monitor_matrix(1,i_runs / print_resolution) = print_matrix(num_monitor_ebno,num_monitor_comp+1)';
            set(hPlot30, 'YData', monitor_matrix(1,:));
            drawnow;
        end
    end
end

%% Final Result
ber_avg = zeros(num_comp, length(EbNo_dB_vec));
for i_comp = 1 : num_comp      %这里用i_comp1是为了避免重复使用前面用过的i_comp，但我也不确定这里重复使用会不会出问题
    ber_avg(i_comp, :) = ber_sum(i_comp, :) / max_runs;
end

markers = {'o-', 's-', '^-', 'd-', 'p-', 'h-', '+-', '*-', '.-', 'x-', 'v-', '>-', '<-',};
figure;
hold on;    %hold on启动图形保持，当前的普通坐标轴也会被保持，semilogy将无法改变坐标轴为对数坐标.
for i_comp = 1 : num_comp 
    semilogy(EbNo_dB_vec, ber_avg(i_comp, :), markers{i_comp});     % 笔记： {}提取的是单元格内容，()提取的是一个单元格数组的子集。若使用了markers(i)，则marker的类型将是cell而非char
end
hold off;
% legend('ASK 调制深度 30%', 'ASK 调制深度 80%', 'ASK 调制深度 100%', 'legend4');
legend(legends{1:num_comp});
title('误码率性能对比');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;
set(gca, 'YScale', 'log');  %强制设置y轴为对数坐标
xlim([EbNo_dB_vec(1) EbNo_dB_vec(length(EbNo_dB_vec))]);
set(gca,'XTick',EbNo_dB_vec(1):2:EbNo_dB_vec(length(EbNo_dB_vec))); % 设置 x 轴刻度间隔为 2
