join_tag_data_and_res
joined_table = tag_table;
bat_nums = [5];

joined_table.durations = joined_table.times(:,2) -joined_table.times(:,1);
for ith_bat_num = bat_nums
    fprintf("-------------- bat %i ---------------- \n", ith_bat_num)
    DispRawPipelineStats(joined_table(joined_table.bat_num == ith_bat_num,:))
    rmse_rx = RmseSpecificVar(joined_table(joined_table.bat_num == ith_bat_num,:), "alg_rx", "rx_freq_tagged");
    fprintf("RMSE of detected echos = %i \n", fix(rmse_rx))
    disp("*****************************************")
end


bat_5 = joined_table(joined_table.bat_num == 5,:);

figure; histogram(bat_5.tx_freq_tagged(bat_5.tx_freq_tagged ~= -1 & bat_5.alg_tx ~= -1) - ...
    bat_5.alg_tx(bat_5.tx_freq_tagged ~= -1 & bat_5.alg_tx ~= -1), 100)
title("tx err hist")

figure; subplot(1,2,1)
histogram(bat_5.rx_freq_tagged(bat_5.rx_freq_tagged ~= -1 & bat_5.alg_rx ~= -1) - ...
    bat_5.alg_rx(bat_5.rx_freq_tagged  ~= -1 & bat_5.alg_rx ~= -1), 50)
title("rx err hist")

subplot(1,2,2)
ecdf(abs(bat_5.rx_freq_tagged(bat_5.rx_freq_tagged ~= -1 & bat_5.alg_rx ~= -1) - ...
    bat_5.alg_rx(bat_5.rx_freq_tagged  ~= -1 & bat_5.alg_rx ~= -1)))
title("rx err ecdf")

figure; scatter(bat_5.rx_freq_tagged(bat_5.rx_freq_tagged ~= -1 & bat_5.alg_rx ~= -1), ...
    bat_5.alg_rx(bat_5.rx_freq_tagged  ~= -1 & bat_5.alg_rx ~= -1))
title("rx scatter")

