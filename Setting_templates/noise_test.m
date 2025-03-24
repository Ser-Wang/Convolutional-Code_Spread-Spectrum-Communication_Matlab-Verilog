
c = 1;
legends{c} = ' 100% ASK ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type(c) = 0;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
modulation_cell(c,1:2) = {'ask', 1};
constraintLengths(c) = 3;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
codeRate(c) = 0.5;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7 7 7]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 2;
legends{c} = ' BPSK ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type(c) = 0;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
codeRate(c) = 0.5;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7 7 7]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 3;
legends{c} = ' BPSK, Rconv=1/2 ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type(c) = 3;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
codeRate(c) = 0.5;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};