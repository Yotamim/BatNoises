function [resamp_centered_iq_sig, new_samp_rate, filtered_audio, center_freq] = ProcessSingleAudio(raw_audio, relevant_band, fs, config)

bat_pulse_freq = config.bat_config.bat_pulse_freq;
center_freq = config.bat_config.bat_pulse_freq;

assert(center_freq == bat_pulse_freq, "using different bat pulse and centering freq")

time_vec = (0:length(raw_audio)-1)/fs;
time_vec = time_vec';

filtered_audio = bandpass(raw_audio, relevant_band, fs);
iq_signal = hilbert(filtered_audio);

centering_wave = exp(-2*pi*1i*center_freq*time_vec);
centered_iq_sig = iq_signal.*centering_wave;

new_samp_rate = diff(relevant_band)*1.2;
resamp_centered_iq_sig = downsample(centered_iq_sig, 4);
temp_samp_rate = fs/4;
assert(new_samp_rate<=temp_samp_rate);
new_samp_rate = temp_samp_rate;

if config.plot_config.plot_audio_to_bb_sanity_check
    freqs = linspace(-fs/2, fs/2, length(raw_audio));
    figure; plot(freqs , fftshift(abs(fft(raw_audio))))
    title('fft')
    
    figure; plot(freqs , fftshift(abs(fft(hilbert(raw_audio)))))
    title('hilbert fft')
    
    figure; plot(freqs , fftshift(abs(fft(iq_signal))))
    title('hilbert fft filtered relevant band')
    
    figure; plot(freqs , fftshift(abs(fft(centered_iq_sig))))
    
    
    
    n_freqs = linspace(-temp_samp_rate/2, temp_samp_rate/2, length(resamp_centered_iq_sig));
    hold on; plot(n_freqs , fftshift(abs(fft(resamp_centered_iq_sig)))*fs/temp_samp_rate)
    
    new_time_vec = (0:(length(resamp_centered_iq_sig)-1))*1/temp_samp_rate;
    figure; plot(new_time_vec, real(resamp_centered_iq_sig), 'o'); hold on;
    plot(time_vec, real(centered_iq_sig)); 
end

end
