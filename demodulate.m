function [y_demodulated] = demodulate(ask_depth,y_noisy)

hard_threshold = 1 - ask_depth / 2;
y_demodulated = (y_noisy > hard_threshold);
end

