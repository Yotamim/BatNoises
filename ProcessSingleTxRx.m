function ProcessSingleTxRx(single_trx_wav, fs, config)

bat_pulse_freq = config.bat_config.bat_pulse_freq;
speed_of_sound = config.phys_config.speed_of_sound;
rel_speed_of_bat = config.bat_config.rel_speed_of_bat;

recived_freq_range = bat_pulse_freq*((speed_of_sound+[-rel_speed_of_bat, rel_speed_of_bat])/speed_of_sound);
doppler_shift_range = recived_freq_range-bat_pulse_freq;
doppler_axis = linspace(doppler_shift_range(1), doppler_shift_range(2), 1001);
time_axis = ((0:length(single_trx_wav)-1)/fs).';

caf_mat1 = zeros(length(doppler_axis), 2*length(single_trx_wav)-1);

for ith_freq = 1:length(doppler_axis)
    cur_freq = doppler_axis(ith_freq);
    caf_mat1(ith_freq, :) = xcorr(single_trx_wav, exp(2*pi*1i*time_axis*cur_freq).*single_trx_wav);
end

if 0
    positive_delays_caf_mat = caf_mat1(:,length(single_trx_wav):end);
    figure; imagesc(time_axis, doppler_axis, pow2db(abs(positive_delays_caf_mat)))
    title("regular corr - dB ")
    set(gca, 'YDir', 'normal')
    colormap jet
    
    figure; plot(max(movmean(abs(positive_delays_caf_mat),4000,2),[],2))
end

[filter_spec, spec_freq_vec, spec_time_vec] = stft(single_trx_wav, fs, FFTLength=2*config.spec_config.fft_length,FrequencyRange="centered",...
                        OverlapLength=128, Window=config.spec_config.window);
PlotSpectogram(single_trx_wav,filter_spec,fs,spec_freq_vec,spec_time_vec)

[A, B, C] = stft(single_trx_wav, fs, FFTLength=2*config.spec_config.fft_length,FrequencyRange="centered",...
                        OverlapLength=64);
PlotSpectogram(single_trx_wav,A,fs,spec_freq_vec,spec_time_vec)
figure;plot(spec_freq_vec, sum(abs(filter_spec),2))
figure;plot(abs(fftshift(fft(single_trx_wav))))

aaa = single_trx_wav(0.064*fs:0.068*fs);
xcor_vec = norm_cor_yot(single_trx_wav,aaa,1);

caf_mat2 = zeros(length(doppler_axis), length(xcor_vec));
for ith_freq = 1:length(doppler_axis)
    cur_freq = doppler_axis(ith_freq);
    caf_mat2(ith_freq, :) = norm_cor_yot(exp(2*pi*1i*time_axis*cur_freq).*single_trx_wav,aaa,1);
end

figure; imagesc([], doppler_axis, pow2db(abs(caf_mat2)))
title("regular corr - dB ")
set(gca, 'YDir', 'normal')
colormap jet

figure;plot(abs(xcor_vec))
figure;plot(abs(caf_mat2(501,:)))

end



