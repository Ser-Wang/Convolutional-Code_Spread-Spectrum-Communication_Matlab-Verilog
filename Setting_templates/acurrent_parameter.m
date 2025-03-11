% Current parameter settings

c = 1;
legends{c} = ' dsss, ask, reg=[1000] ';   % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;                         % 基带信号码长
encode_type(c) = 4;                         % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss.
modulation_cell(c,1:2) = {'ASK', 1};        % 调制类型('ASK' 'BPSK'可选); ASK调制深度(仅ASK时有效), ranges [0,1].
ask_depths(c) = 1;
constraintLengths(c) = 3;                   % 卷积码约束长度
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);    % 卷积码生成矩阵
traceback_depths(c) = 5*constraintLengths(c);
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};   % m序列寄存器数n; 抽头位置taps; 寄存器初值reg;

c = 2;
legends{c} = ' dsss, bpsk,  ';
L_lengths(c) = 256;
encode_type(c) = 4;
modulation_cell(c,1:2) = {'bpsk', 1};
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 3;
legends{c} = ' conv, ask ';
L_lengths(c) = 256;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'ask', 1};
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 4;
legends{c} = ' conv, bpsk ';
L_lengths(c) = 256;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'bpsk', 1};
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

% Setting templates

% 统一设参
% c = 8;
% legends = {' d=1 ',' d= 3',' d=5 ',' d=7 ', ' d=9 ', ' d=11 ', ' d=13 ', ' d=15 ',};
% L_lengths(1:c) = 256;
% ask_depths(1:c) = 1;
% constraintLengths(1:c) = 3;
% trelliss(1:c) = poly2trellis(constraintLengths(c), [5 7]);
% traceback_depths(1:c) = [1:2:15];

% 分立设参
% c = 1;
% legends{c} = ' dsss, ask, reg=[1000] ';   % 为保证表格打印效果，字符最好左右留空格
% L_lengths(c) = 256;                         % 基带信号码长
% encode_type(c) = 4;                         % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss.
% modulation_cell(c,1:2) = {'ASK', 1};        % 调制类型('ASK' 'BPSK'可选); ASK调制深度(仅ASK时有效), ranges [0,1].
% ask_depths(c) = 1;
% constraintLengths(c) = 3;                   % 卷积码约束长度
% trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);    % 卷积码生成矩阵
% traceback_depths(c) = 5*constraintLengths(c);
% dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};   % m序列寄存器数n; 抽头位置taps; 寄存器初值reg;