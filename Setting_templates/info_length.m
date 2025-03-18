c = 1;
legends{c} = ' L=8 ';
L_lengths(c) = 8;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 8;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 2;
legends{c} = ' L=32 ';
L_lengths(c) = 32;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 3;
legends{c} = ' L=128 ';
L_lengths(c) = 128;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 4;
legends{c} = ' L=256 ';
L_lengths(c) = 256;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 5;
legends{c} = ' L=512 ';
L_lengths(c) = 512;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};

c = 6;
legends{c} = ' L=1024 ';
L_lengths(c) = 1024;
encode_type(c) = 3;     % conv
modulation_cell(c,1:2) = {'bpsk', 1};
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c) - 5;
dsss_cell(c,1:3) = {4, [4 1], [1 0 0 0]};