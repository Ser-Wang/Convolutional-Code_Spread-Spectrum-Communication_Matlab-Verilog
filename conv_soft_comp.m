clc;
clear;
addpath('Functions/')
addpath('Setting_templates')

% Simulation Parameter
EbNo_dB_vec = -12:2:16;
max_runs = 100;
print_resolution = 10;
% legends = {};
c=1;
num_comp = 1;

% Parameters
legends = ' nocode ';   % 为保证表格打印效果，字符最好左右留空格
L_length = 256;                         % 基带信号码长
modulation_cell(1,1:2) = {'bpsk', 1};        % 调制类型('ASK' 'BPSK'可选); ASK调制深度(仅ASK时有效), ranges [0,1].
conv_K = 3;                   % 卷积码约束长度
trellis = poly2trellis(conv_K, [5 7]);    % 卷积码生成矩阵
tb_depth = 5*conv_K - 5;

% ber storage
ber_sum = zeros(1, length(EbNo_dB_vec));     %每行对应一个对比条件，列对应多个信噪比，命令行窗口打印时矩阵会转置
% ber_num_sum = zeros(num_comp, length(EbNo_dB_vec));
% Print
print_matrix = zeros(length(EbNo_dB_vec),c+1);  % c列ber数据，首列ebn0
print_matrix(:,1) = EbNo_dB_vec';


%% Begin
% ber_num = zeros(num_comp, length(EbNo_dB_vec));
% ber = zeros(num_comp, length(EbNo_dB_vec));
for i_runs = 1 : max_runs

    [ber_num, ber] = ber_conv_dectype(L_length, EbNo_dB_vec, modulation_cell, trellis, tb_depth);

    ber_sum = ber_sum + ber;
%     ber_num_sum(i_comp, :) = ber_num_sum(i_comp, :) + ber_num(i_comp, :);

    % Print
    if(mod(i_runs,print_resolution) == 0)
        for i_comp = 1 : num_comp
            print_matrix(:, i_comp + 1) = ber_sum(i_comp, :)'./i_runs;
        end
        disp(' ');
        disp(['Current run_time = ' num2str(i_runs)]);
        %         disp('ebno       ber_ask30 ber_ask80 ber_ask100');
        disp(['ebno      ' legends]);
        disp(num2str(print_matrix, '%.6f '));
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
legend(legends);
title('误码率性能对比');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;
set(gca, 'YScale', 'log');  %强制设置y轴为对数坐标
xlim([EbNo_dB_vec(1) EbNo_dB_vec(length(EbNo_dB_vec))]);
set(gca,'XTick',EbNo_dB_vec(1):2:EbNo_dB_vec(length(EbNo_dB_vec))); % 设置 x 轴刻度间隔为 2
