clc;
clear;
addpath('Functions/')
addpath('Functions_dectype_comp/')
addpath('Setting_templates')

noise = randn(256,1);

% Simulation Parameter
EbNo_dB_vec = -8:1:-3;
max_runs = 10000000;
print_resolution = 2000;
num_comp = 1;

EbN0_ratio = 10.^(EbNo_dB_vec/10);

% Parameters
% legends = {' hard     ', ' unquant  ', ' soft-3bit '};
% legends = {' soft-3bit '};
legends = {' unquant  '};
L_length = 256;                         % 基带信号码长
modulation_cell(1,1:2) = {'bpsk', 1};        % 调制类型('ASK' 'BPSK'可选); ASK调制深度(仅ASK时有效), ranges [0,1].
conv_K = 3;                   % 卷积码约束长度
trellis = poly2trellis(conv_K, [5 7]);    % 卷积码生成矩阵
tb_depth = 5*conv_K - 5;        % 回溯深度，经验公式tb_depth = 5v
R_conv = 3;
dsss_cell = {3, [3 1], [1 0 0 0]};

% ber storage
ber_sum = zeros(length(EbNo_dB_vec),num_comp);  % 每列一个对比条件，各行对应不同信噪比，与命令行窗口打印方式一致
ber_num_sum = zeros(length(EbNo_dB_vec),num_comp);
% Print
print_matrix = zeros(length(EbNo_dB_vec),num_comp+1);  % c列ber数据，首列ebn0
print_matrix(:,1) = EbNo_dB_vec';


%% Begin
% ber_num = zeros(num_comp, length(EbNo_dB_vec));
% ber = zeros(num_comp, length(EbNo_dB_vec));
for i_runs = 1 : max_runs

%     [ber_num, ber] = ber_conv_dectype(L_length, EbNo_dB_vec, modulation_cell, trellis, tb_depth, R_conv, num_comp);
    [ber_num, ber] = ber_dsss_dectype(L_length, EbNo_dB_vec, modulation_cell, trellis, tb_depth, R_conv, dsss_cell, num_comp);

    ber_sum = ber_sum + ber;
    ber_num_sum = ber_num_sum + ber_num;

    % Print
    if(mod(i_runs,print_resolution) == 0)
%         for i_comp = 1 : num_comp
%             print_matrix(:, i_comp + 1) = ber_sum(:, i_comp)./i_runs;
%         end
        disp(' ');
        disp(['Current run_time = ' num2str(i_runs) ' / ' num2str(max_runs)]);
%         disp(['ebno      ' legends{:}]);
%         disp(num2str(print_matrix, '%.6f '));
    end
end

%% Final Result
ber_avg = zeros(length(EbNo_dB_vec), num_comp);
for i_comp = 1 : num_comp      % 这里用i_comp1是为了避免重复使用前面用过的i_comp；% 但似乎重复使用会不会出问题，故重复使用
    ber_avg(:, i_comp) = ber_sum(: ,i_comp) ./ max_runs;
end

% BPSK_nocode理论误码率曲线
% bpsk_theoretical = 0.5.*erfc(sqrt(EbN0_ratio));
% ask_theoretical = 0.5.*erfc(sqrt(EbN0_ratio/4));

markers = {'o-', 's-', '^-', 'd-', 'p-', 'h-', '+-', '*-', '.-', 'x-', 'v-', '>-', '<-',};
figure;
hold on;    % hold on启动图形保持，当前的普通坐标轴也会被保持，semilogy将无法改变坐标轴为对数坐标.
for i_comp = 1 : num_comp 
    semilogy(EbNo_dB_vec, ber_avg(: ,i_comp), markers{i_comp});     % 笔记： {}提取的是单元格内容，()提取的是一个单元格数组的子集。若使用了markers(i)，则marker的类型将是cell而非char
end
% semilogy(EbNo_dB_vec,bpsk_theoretical,'-*b');
% semilogy(EbNo_dB_vec,bpsk_theoretical,'-or',EbNo_dB_vec,ask_theoretical,'-*b');
hold off;
legend(legends);
% legend([legends, ' bpsk,nocode']);
% legend('bpsk,nocode');
title('误码率性能对比 (2,1,3), g=[5 7], conv+dsss');
% xlabel('Eb/No (dB)');
xlabel('SNR (dB)')
ylabel('误码率 (BER)');
grid on;
set(gca, 'YScale', 'log');  %强制设置y轴为对数坐标
xlim([EbNo_dB_vec(1) EbNo_dB_vec(length(EbNo_dB_vec))]);
set(gca,'XTick',EbNo_dB_vec(1):2:EbNo_dB_vec(length(EbNo_dB_vec))); % 设置 x 轴刻度间隔为 2
