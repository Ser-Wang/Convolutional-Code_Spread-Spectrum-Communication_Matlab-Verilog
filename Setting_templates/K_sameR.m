c = 1;
legends{c} = ' K=3, g=[5 7 7] ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type(c) = 3;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
trelliss(c) = poly2trellis(constraintLengths(c), [5 7 7]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 2;
legends{c} = ' K=5, g=[25 33 37] ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type(c) = 3;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 5;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
trelliss(c) = poly2trellis(constraintLengths(c), [25 33 37]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 3;
legends{c} = ' K=7, g=[133 145 175] ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type(c) = 3;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 7;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
trelliss(c) = poly2trellis(constraintLengths(c), [133 145 175]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 4;
legends{c} = ' K=9, g=[557 663 711] ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type(c) = 3;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 9;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
trelliss(c) = poly2trellis(constraintLengths(c), [557 663 711]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};
