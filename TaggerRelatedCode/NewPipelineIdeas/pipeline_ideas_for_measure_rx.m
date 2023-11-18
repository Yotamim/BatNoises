clear
join_tag_data_and_res
config = GetConfig();
methods_names = ["time_oriented_approach"];
rx_freqs_table = array2table(cell(height(tag_table), length(methods_names)));
rx_freqs_table = renamevars(rx_freqs_table, rx_freqs_table.Properties.VariableNames, methods_names);
rx_freqs_table.audio_path = tag_table.audio_path;
rx_freqs_table.times = tag_table.times;

% ind_vec = randperm(height(tag_table));
ind_vec = 1:height(tag_table);
for i = 1:height(tag_table)%
    try
        ith_tagged_row = ind_vec(i);
        disp(ith_tagged_row)
        tic
        row = tag_table(ith_tagged_row,:);
        if ith_tagged_row>1 && row.audio_path == tag_table(ith_tagged_row-1,:).audio_path
            a = 1;
        else
            relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
            audio_info = audioinfo(row.audio_path);
            fs = audio_info.SampleRate;
            raw_wav = audioread(row.audio_path);
            raw_wav = raw_wav-mean(raw_wav);

            [~, ~, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);
        end
        tagged_wav = filtered_audio(row.times(1)*fs:row.times(2)*fs);

        [tx_freq, smooth_fft] = GetTxFreq(tagged_wav, fs);

        [spec, freq_ax, time_ax] = stft(tagged_wav, fs,Window=hann(1024), FrequencyRange="onesided", OverlapLength=512);
        sum_of_spectogram = sum(abs(spec),2);
        [~,tx_from_spec_row_ind] = max(sum_of_spectogram);
        assert(abs(freq_ax(tx_from_spec_row_ind)-tx_freq) < freq_ax(2)-freq_ax(1))
%         res_rx = [];
%             delete method
%             for i = 1:15
%             clear_inds = freq_ax-freq_ax(tx_from_spec_row_ind) <= (freq_ax(2)-freq_ax(1))*i;
%             filtered_spec = spec;
%             filtered_spec(clear_inds,:) = 0;
% 
%             cleared_sum_over_spectogram = sum_of_spectogram;
%             cleared_sum_over_spectogram(clear_inds) = 0;
%             [~,rx_freq_ind] = max(cleared_sum_over_spectogram);
%             %
%             res_rx = [res_rx, freq_ax(rx_freq_ind)];
%         end
%         rx_freqs_table.delete_tx_from_spec{ith_tagged_row} = res_rx;
        rx_freqs = [];
        for j = [1,2,3,5,10,15,20]
            try
            rows_to_sum = tx_from_spec_row_ind +[-2:2];
            power_of_tx = movmean(sum(abs(spec(rows_to_sum,:))),3);
            no_tx_power_inds = power_of_tx<median(power_of_tx)/j;
            no_tx_power_inds = 2*(no_tx_power_inds-1/2);
            smoothening_inds = conv(no_tx_power_inds, [1,-1,1], "same") == 3;
            no_tx_power_inds_smooth = no_tx_power_inds>0;
            no_tx_power_inds_smooth(smoothening_inds) = 1;
            seq_of_low_energy = ActivityVec2IndsArray(no_tx_power_inds_smooth, time_ax);
            [~,ind_max] = max(diff(seq_of_low_energy,[],2));
            tx_end = seq_of_low_energy(ind_max,1);
            tagged_wav_after_tx = tagged_wav(fs*time_ax(tx_end):end);
            [rx_freq, smooth_fft] = GetTxFreq(tagged_wav_after_tx, fs);
            rx_freqs = [rx_freqs,rx_freq];
            catch
                rx_freqs = [rx_freqs,-1];
            end
        end
%         spec_after_tx = spec(:,tx_end:end);
        
        
        rx_freqs_table.time_oriented_approach{ith_tagged_row} = rx_freqs;
        toc
%         figure;
%         plot(time_ax,power_of_tx)
%         temp_ploting(spec,freq_ax,time_ax,tagged_wav,fs,tx_freq)
%         temp_ploting(spec_after_tx,freq_ax,time_ax(tx_end:end),tagged_wav_after_tx,fs,rx_freq)
        
        
%         temp_ploting(filtered_spec,freq_ax,time_ax,tagged_wav, fs,tx_freq)
%         subplot(2,3,4) 
%         hold on 
%         plot(joined_table.rx_freq_tagged(ith_tagged_row),max(cleared_sum_over_spectogram), "o")
        
%         t = 1/fs*(0:length(tagged_wav)-1);
%         carrier = exp(tx_freq*-2*pi*1i*t);
%         
%         figure; plot(t,real(carrier.*hilbert(tagged_wav).'))
%         figure; plot(abs(fftshift(fft(carrier.*hilbert(tagged_wav).'))), '.-')
        

    catch exception
        fprintf('Error Message: %s\n', exception.message);
        temp_ploting(spec,freq_ax,time_ax,tagged_wav,fs,tx_freq)
        keyboard
    end
end

% save(methods_names{1}, "rx_freqs_table")


