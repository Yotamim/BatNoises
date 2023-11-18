function [tx_freq, smooth_fft] = GetTxFreq(wav, fs)

N = length(wav);
freqs = -fs/2:fs/N:(fs/2-fs/N);
smooth_fft = movmean(abs(fftshift(fft(wav))), 10);
[~,max_ind] = max(smooth_fft);
tx_freq = abs(freqs(max_ind));

end


