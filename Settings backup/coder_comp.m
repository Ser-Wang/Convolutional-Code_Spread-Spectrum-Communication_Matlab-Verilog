c = 1;
legends{c} = ' nocode ';
L_lengths(c) = 256;
encode_type(c) = 0;     % nocode
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);

c = 2;
legends{c} = ' manchester ';
L_lengths(c) = 256;
encode_type(c) = 1;     % manchester
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);

c = 3;
legends{c} = ' man+conv ';
L_lengths(c) = 256;
encode_type(c) = 2;     % man+conv
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);

c = 4;
legends{c} = ' conv ';
L_lengths(c) = 256;
encode_type(c) = 3;     % conv
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);

c = 5;
legends{c} = ' conv+dsss reg=[10000] ';
L_lengths(c) = 256;
encode_type(c) = 4;     % conv+dsss
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);
reg_m(c,:) = [1 0 0 0 0];

c = 6;
legends{c} = ' conv+dsss reg=[11111] ';
L_lengths(c) = 256;
encode_type(c) = 4;     % conv+dsss
ask_depths(c) = 1;
constraintLengths(c) = 3;
trelliss(c) = poly2trellis(constraintLengths(c), [5 7]);
traceback_depths(c) = 5*constraintLengths(c);
reg_m(c,:) = [1 1 1 1 1];