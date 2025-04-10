function [y] = noisy(sig, SNR_dB, codeRate_reciprocal)
%NOISY 此处显示有关此函数的摘要
%   此处显示详细说明

% sigPower = sum(abs(sig(:)).^2)/numel(sig);
sigPower = 1;
SNR = 10^(SNR_dB / 10);
% noisePower = sigPower / (2 * codeRate * SNR);
% noisePower = sigPower * codeRate_reciprocal/ (2 * SNR);
noisePower = sigPower / (2 * SNR);
noise = sqrt(noisePower)* randn(size(sig));
y = sig + noise;
end

