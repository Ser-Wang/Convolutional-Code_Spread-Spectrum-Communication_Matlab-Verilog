c = 10;
legends = {' d=7 ',' d=9 ',' d=11 ', ' d=13 ', ' d=15 ', ' d=16 ', ' d=17 ', ' d=19 ', ' d=21 ', ' d=23 '};
L_lengths(1:c) = 256;
encode_type(1:c) = 3;
modulation_cell(1:c,1) = {'bpsk'};
modulation_cell(1:c,2) = {1};
constraintLengths(1:c) = 5;
trelliss(1:c) = poly2trellis(constraintLengths(c), [25 27 33 37]);
traceback_depths(1:c) = [7 9 11 13 15 16 17 19 21 23];
% dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

% c = 1;
% legends{c} = ' K=3, g=[5 7 7 7] ';        % 为保证表格打印效果，字符最好左右留空格
% L_lengths(c) = 256;             % 基带信号码长
% encode_type = 3;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
% modulation_cell(c,1:2) = {'bpsk', 1};
% constraintLengths(c) = 3;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
% trelliss(c) = poly2trellis(constraintLengths(c), [5 7 7 7]);    % 生成多项式为 [111, 101]，约束长度为 3
% traceback_depths(c) = 5*constraintLengths(c) - 5;
% dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};
% 
% constraintLengths(1:c) = 9;
% trelliss(1:c) = poly2trellis(constraintLengths(c), [561 753]);
% traceback_depths(1:c) = 5*constraintLengths(c) - 5;
