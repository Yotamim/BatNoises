function [doppler_vec,freq,full_tx_rx_fft] = FindDopplerFromSpec(data, fs)
[spec,freq,~] = stft(data,fs,Window=hann(128), FrequencyRange="centered", OverlapLength=0);
tresh = prctile(abs(spec(:)),92);
doppler_vec = sum(abs(spec).*(abs(spec)>=tresh),2);
full_tx_rx_fft = fftshift(fft(data));
end