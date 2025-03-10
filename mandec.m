function [decoded] = mandec(signal)
    decoded = signal(1:2:end) & ~signal(2:2:end); % 判断前半周期
end