function [y, sigma] = noisy_dectype(sig, SNR_dB, codeRate_reciprocal)

sigPower = 1;
SNR = 10^(SNR_dB / 10);
% noisePower = sigPower / (2 * codeRate * SNR);
% noisePower = sigPower * codeRate_reciprocal/ (2 * SNR);
noisePower = sigPower / (2 * SNR);
% noise = sqrt(noisePower)* randn(size(sig));
sigma = sqrt(noisePower);
noise = sigma* randn(size(sig));
y = sig + noise;
end

