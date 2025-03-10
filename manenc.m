function encoded = manenc(data)
    encoded = repelem(data, 2);          % 复制每个比特
    encoded(2:2:end) = ~encoded(1:2:end);% 取反偶数位
end