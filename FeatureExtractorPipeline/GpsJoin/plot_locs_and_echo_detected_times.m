threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,81000], "rx_freq", [78000,82500], "durations", [0,0.15]);
inds_passing_thresholds = GetValidIndsForModelFromSignalPro(threshold_dict_sig, res_table_2_peaks);

bat_num = [2,4,5];
for i = bat_num
    cur_bat_data_2 = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    cur_bat_data_1 = res_table_1_peak(res_table_1_peak.bat_num == i,:);
    gps = LoadGpsData(num2str(i));
    x = gps.x;
    y = gps.y;
    gps_t_vec = (gps.time-min(gps.time))*24*3600;
    echo_detected_times = (cur_bat_data_2.closest_gps_time-min(gps.time))*24*3600-cur_bat_data_2.diff_from_closest_gps;
    no_echo_times = (cur_bat_data_1.closest_gps_time-min(gps.time))*24*3600-cur_bat_data_1.diff_from_closest_gps;
    figure;
    subplot(1,3,1)
    plot(x,y, ".")
    xlabel("x")
    ylabel("y")
    
    subplot(1,3,2)
    plot(gps_t_vec,x, ".")
    hold on;
    plot(echo_detected_times, ones(size(echo_detected_times))*mean(x), ".k")
    plot(no_echo_times, ones(size(no_echo_times))*mean(x)+0.005e5, ".r")
    xlabel("t")
    ylabel("x")
    
    subplot(1,3,3)
    plot(gps_t_vec,y, ".")
    hold on;
    plot(echo_detected_times, ones(size(echo_detected_times))*mean(y), ".k")
    plot(no_echo_times, ones(size(no_echo_times))*mean(y)+0.005e5, ".r")
    xlabel("t")
    ylabel("y")
    
    axises = get(gcf,"children");
    linkaxes(axises(1:2), "x")
    linkaxes(axises([1,3]), "y")
    sgtitle("bat"+num2str(i))
end

