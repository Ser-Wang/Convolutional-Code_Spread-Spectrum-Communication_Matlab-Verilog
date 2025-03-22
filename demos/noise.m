    noisePower = 1 / (2 * codeRate * 10^(EbNo_dB_vec(i_ebno)/10));
    noisePower = 1 / (2 * 10^(EbNo_dB(i_ebno)/10)); 
    noise = sqrt(noisePower) * randn(size(x)); 
    y_noisy_ask_100 = x_ask_100 + noise;

    
    y_noisy = awgn(x_modulated,EbNo_dB_vec(i_ebno),'measured');