function a = CAFperWindow(v1, window_length, fs, config)

bat_pulse_freq = config.bat_config.bat_pulse_freq;
speed_of_sound = config.phys_config.speed_of_sound;
rel_speed_of_bat = config.bat_config.rel_speed_of_bat;
recived_freq_range = bat_pulse_freq*((speed_of_sound+[-rel_speed_of_bat, rel_speed_of_bat])/speed_of_sound);
doppler_shift_range = recived_freq_range-bat_pulse_freq;
doppler_axis = linspace(doppler_shift_range(1), doppler_shift_range(2), 1001);

time_axis = ((0:length(v1)-1)/fs).';
num_chunks = floor(length(v1)/window_length);

caf_cell = cell(num_chunks,1);
for i = 1:num_chunks
    caf_mat = zeros(length(doppler_axis), length(v1)-window_length);
    current_chunk = v1((i-1)*window_length+1:i*window_length);
    for ith_freq = 1:length(doppler_axis)
        cur_freq = doppler_axis(ith_freq);
        caf_mat(ith_freq, :) = norm_cor_yot(exp(2*pi*1i*time_axis*cur_freq).*v1, current_chunk);
    end
    caf_cell{i} = caf_mat;
end

end