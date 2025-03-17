EbNo_dB_vec = -8:1:14;

legends{1} = ' manchester ';
legends{2} = ' K=9, g=[561 753] ';
legends{3} = ' K=9, g=[557 663 711] ';
legends{4} = ' K=9, g=[363 535 733 745] ';
num_comp = 4;

markers = {'o-', 's-', '^-', 'd-', 'p-', 'h-', '+-', '*-', '.-', 'x-', 'v-', '>-', '<-',};

figure;
hold on;    %hold on启动图形保持，当前的普通坐标轴也会被保持，semilogy将无法改变坐标轴为对数坐标.
for i_comp = 1 : num_comp 
    semilogy(EbNo_dB_vec, S3(:, i_comp), markers{i_comp});     % 笔记： {}提取的是单元格内容，()提取的是一个单元格数组的子集。若使用了markers(i)，则marker的类型将是cell而非char
end
hold off;
% legend('ASK 调制深度 30%', 'ASK 调制深度 80%', 'ASK 调制深度 100%', 'legend4');
legend(legends{1:num_comp});
title('误码率性能对比');
xlabel('Eb/No (dB)');
ylabel('误码率 (BER)');
grid on;
set(gca, 'YScale', 'log');  %强制设置y轴为对数坐标
xlim([EbNo_dB_vec(1) EbNo_dB_vec(length(EbNo_dB_vec))]);
set(gca,'XTick',EbNo_dB_vec(1):2:EbNo_dB_vec(length(EbNo_dB_vec))); % 设置 x 轴刻度间隔为 2