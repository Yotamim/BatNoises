function [min_five_span, max_five_span]= GetWidthFromWave(data,fs)

freqs = linspace(-fs/2, fs/2, length(data)).';
fft_data = fftshift(abs(fft(data))); 

pos_fft_data = fft_data(freqs>0);
pos_fft_freqs = freqs(freqs>0);

five_span = pos_fft_freqs(pos_fft_data>max(pos_fft_data)/5);
max_five_span = max(five_span);
min_five_span = min(five_span);

end