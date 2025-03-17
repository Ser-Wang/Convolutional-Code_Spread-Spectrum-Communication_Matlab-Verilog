% 基础分立设参模板

c = 1;
legends{c} = ' taps=[4 1] , reg=[1000] ';   % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;                         % 基带信号码长
encode_type(c) = 4;                         % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss.
modulation_cell(c,1:2) = {'ASK', 1};        % 调制类型('ASK' 'BPSK'可选); ASK调制深度(仅ASK时有效), ranges [0,1].
constraintLengths(c) = 3;                   % 卷积码约束长度
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);    % 卷积码生成矩阵
traceback_depths(c) = 5*constraintLengths(c);
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};   % m序列寄存器数n; 抽头位置taps; 寄存器初值reg;
