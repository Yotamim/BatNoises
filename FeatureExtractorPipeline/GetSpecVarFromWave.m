function var_freq = GetSpecVarFromWave(data,fs, is_rx)

freqs = linspace(-fs/2, fs/2, length(data)).';
fft_data = fftshift(abs(fft(data))); 

pos_fft_data = fft_data(freqs>0);
pos_fft_freqs = freqs(freqs>0);

if is_rx
    pos_fft_data(pos_fft_data<max(pos_fft_data)/1000) = 0;
    pos_fft_data_as_dist = pos_fft_data/sum(pos_fft_data);
    expected_freq_value = sum(pos_fft_freqs.*pos_fft_data_as_dist);
    var_freq = sqrt(sum((expected_freq_value-pos_fft_freqs).^2.*pos_fft_data_as_dist));
else
    [~,i] = max(pos_fft_data);
    freqs_tx = pos_fft_freqs(abs(pos_fft_freqs(i)-pos_fft_freqs)<=1000);
    pos_fft_data_around_peak = pos_fft_data(abs(pos_fft_freqs(i)-pos_fft_freqs)<=1000);
    pos_fft_data_as_dist = pos_fft_data_around_peak/sum(pos_fft_data_around_peak);
    expected_freq_value = sum(freqs_tx.*pos_fft_data_as_dist);
    var_freq = sqrt(sum((expected_freq_value-freqs_tx).^2.*pos_fft_data_as_dist));
end

end