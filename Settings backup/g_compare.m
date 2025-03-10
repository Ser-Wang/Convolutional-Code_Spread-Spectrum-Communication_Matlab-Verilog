% 某生成矩阵下回溯深度对BER性能的影响

c = 1;
legends{c} = ' L=256, g=[5 7] ';        % 为保证表格打印效果，字符最好左右留空格
L_lengths(c) = 256;             % 基带信号码长
encode_type = 3;                % 编码类型，0:none, 1:man, 2:man+conv, 3:conv, 4:conv+dsss
ask_depths(c) = 1;              % ASK调制深度
constraintLengths(c) = 3;       % 卷积码约束长度，后续编译码函数中用不到，构建数组是为了方便观察变量设置
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);    % 生成多项式为 [111, 101]，约束长度为 3
traceback_depths(c) = 5*constraintLengths(c);

c = 2;
legends{c} = ' L=256, g=[5 7 7] ';
L_lengths(c) = 256;
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7 7]);
traceback_depths(c) = 5*constraintLengths(c);

c = 3;
legends{c} = ' L=256 g=[133 171]';
L_lengths(c) = 256;
ask_depths(c) = 1;
constraintLengths(c) = 7;
trelliss(c) = poly2trellis(constraintLengths(c), [133 171]);
traceback_depths(c) = 5*constraintLengths(c);

c = 4;
legends{c} = ' L=256 g=[133 171 165]';
L_lengths(c) = 256;
ask_depths(c) = 1;
constraintLengths(c) = 7;
trelliss(c) = poly2trellis(constraintLengths(c), [133 171 165]);
traceback_depths(c) = 5*constraintLengths(c);

c = 5;
legends{c} = ' L=256 g=[5 7 7 7] ';
L_lengths(c) = 256;
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7 7 7]);
traceback_depths(c) = 5*constraintLengths(c);

c = 6;
legends{c} = ' L=256 g=[133 171 165 147] ';
L_lengths(c) = 4096;
ask_depths(c) = 1;
constraintLengths(c) = 7;
trelliss(c) = poly2trellis(constraintLengths(c), [133 171 165 147]);
traceback_depths(c) = 5*constraintLengths(c);