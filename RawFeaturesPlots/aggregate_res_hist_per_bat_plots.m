figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).tx_freq_from_filtered_tx_fft;
    histogram(cur_bat_tx_freqs,500)
end
title("hist per bat of tx freq when echo detected")
legend("2","4","5")

figure; hold on
for i = [2,4,5]
    cur_bat_dur = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).durations;
    histogram(cur_bat_dur,500)
end
title("hist per bat of durations when echo detected")
legend("2","4","5")

figure; hold on
for i = [2,4,5]
    tind = res_table_2_peaks.bat_num == i & abs(res_table_2_peaks.diff_from_closest_gps)<10;
    histogram(res_table_2_peaks(tind,:).speed,500)
end
title("hist per bat of speeds when echo detected")
legend("2","4","5")

figure; hold on
for i = [2,4,5]
    tind = res_table_2_peaks.bat_num == i;
    histogram(res_table_2_peaks(tind,:).rx_var,500)
end
title("hist per bat of rx var when echo detected")
legend("2","4","5")

figure; hold on
for i = [2,4,5]
    cur_bat_delays = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).delay;
    
    histogram(cur_bat_delays(cur_bat_delays>0) ,500)
end
title("hist per bat of delays when echo detected")
legend("2","4","5")


figure; hold on
for i = [2,4,5]
    cur_bat_dur = res_table_1_peak(res_table_1_peak.bat_num == i,:).durations;
    ecdf(cur_bat_dur)
end
title("ecdf per bat of durations NO ECHO")
legend("2","4","5")




