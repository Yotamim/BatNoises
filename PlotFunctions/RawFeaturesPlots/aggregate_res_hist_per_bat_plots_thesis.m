figs_path = "C:\Users\yotam\Desktop\Figures\Bats\for_thesis\";

% hist per bat of tx freq when echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).tx_freq_from_filtered_tx_fft;
    histogram(cur_bat_tx_freqs,[7.5e4:100:8.5e4], 'Normalization','probability')
end
fig_name = "hist per bat of tx freq when echo detected";
title(fig_name)
legend("2","4","5")
savefig(gcf, fullfile(figs_path,fig_name))

% hist per bat of tx freq when no echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_1_peaks(res_table_1_peaks.bat_num == i,:).raw_tx;
    histogram(cur_bat_tx_freqs,[7.8e4:100:8.05e4], 'Normalization','probability')
end
fig_name = "hist per bat of tx freq when no echo detected";
title(fig_name)
legend("2","4","5")
savefig(gcf, fullfile(figs_path,fig_name))

% hist per bat of tx freq when echo detected, per movement type, per bat
figure;
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = unique(cur_bat_table.movement_type).'
        tx_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).tx_freq_from_filtered_tx_fft;
        histogram(tx_of_movement_type,[7.5e4:100:8.5e4], 'Normalization','probability')
    end
    legend(unique(cur_bat_table.movement_type).')
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat per movement type of tx freq when echo detected";
title(fig_name)
legend("2","4","5")
savefig(gcf, fullfile(figs_path,fig_name))

% hist per bat of echo when echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_freq;
    histogram(cur_bat_tx_freqs,[7.8e4:100:8.1e4], 'Normalization','probability')
end
fig_name = "hist per bat of rx when echo detected";
title(fig_name)
legend("2","4","5")
savefig(gcf, fullfile(figs_path,fig_name))


% hist per bat of rx var when echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_var;
    histogram(cur_bat_tx_freqs,[100:5:800],'Normalization','probability')
end
fig_name = "hist per bat of rx var when echo detected";
title(fig_name)
legend("2","4","5")
savefig(gcf, fullfile(figs_path,fig_name))


% hist per bat of rx var per movement type when echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_var;
    histogram(cur_bat_tx_freqs,[100:5:800],'Normalization','probability')
end
fig_name = "hist per bat of rx var when echo detected";
title(fig_name)
legend("2","4","5")
savefig(gcf, fullfile(figs_path,fig_name))


% hist per bat of rx var when echo detected, per movement type, per bat
figure;
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = unique(cur_bat_table.movement_type).'
        rx_var_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).rx_var;
        histogram(rx_var_of_movement_type, [100:10:800], 'Normalization','probability')
    end
    legend(unique(cur_bat_table.movement_type).')
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat of rx var when echo detected per movement type per bat";
sgtitle(fig_name)
savefig(gcf, fullfile(figs_path,fig_name))


% hist per bat of rx var when echo detected, per movement type, per bat
figure;
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = unique(cur_bat_table.movement_type).'
        delay_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).delay;
        histogram(delay_of_movement_type, [0:0.001:0.04], 'Normalization','probability')
    end
    legend(unique(cur_bat_table.movement_type).')
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat of delay when echo detected per movement type per bat";
sgtitle(fig_name)
savefig(gcf, fullfile(figs_path,fig_name))


% hist of speeds per bat when echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_var;
    histogram(cur_bat_tx_freqs,[100:5:800],'Normalization','probability')
end
fig_name = "hist of speeds per bat when echo detected";
title(fig_name)
legend("2","4","5")
savefig(gcf, fullfile(figs_path,fig_name))



% hist of speeds per bat  per movement type when echo detected
figure;
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = unique(cur_bat_table.movement_type).'
        delay_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).delay;
        histogram(delay_of_movement_type, [0:0.001:0.04], 'Normalization','probability')
    end
    legend(unique(cur_bat_table.movement_type).')
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat of delay when echo detected per movement type per bat";
sgtitle(fig_name)
savefig(gcf, fullfile(figs_path,fig_name))

% hist per bat of tx and rx when echo detected and where static
figure;
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table_2 = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    cur_bat_table_1 = res_table_1_peak(res_table_1_peak.bat_num == i,:);
    if i == 2
        cur_bat_table_1 = cur_bat_table_1(cur_bat_table_1.raw_tx >= 7.81e4,:);
    end
    if i == 4
        cur_bat_table_1 = cur_bat_table_1(cur_bat_table_1.raw_tx >= 7.9e4,:);
    end
    if i == 5
        cur_bat_table_1 = cur_bat_table_1(cur_bat_table_1.raw_tx >= 7.92e4,:);
    end

    histogram(cur_bat_table_1.raw_tx,[7.5e4:100:8.5e4], 'Normalization','probability')
    histogram(cur_bat_table_2.tx_freq_from_filtered_tx_fft,[7.5e4:100:8.5e4], 'Normalization','probability')
    histogram(cur_bat_table_2.rx_freq,[7.5e4:100:8.5e4], 'Normalization','probability')
    title(sprintf("bat %i", i))
    legend(["tx static","tx movment","rx movement"])
    xlabel("Freq[Hz]")
end
fig_name = "hist per bat of tx and rx when echo detected and where static";
sgtitle(fig_name)
savefig(gcf, fullfile(figs_path,fig_name))

%% hist per bat per movement of tx and rx when echo detected and where static
figure;
mvment_type = ["field"    "hunting"    "woods"];
for i = [2,4,5]
    cur_bat_table_2 = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    cur_bat_table_1 = res_table_1_peak(res_table_1_peak.bat_num == i,:);
    if i == 2
        cur_bat_table_1 = cur_bat_table_1(cur_bat_table_1.raw_tx >= 7.81e4,:);
    end
    if i == 4
        cur_bat_table_1 = cur_bat_table_1(cur_bat_table_1.raw_tx >= 7.9e4,:);
    end
    if i == 5
        cur_bat_table_1 = cur_bat_table_1(cur_bat_table_1.raw_tx >= 7.92e4,:);
    end
    for ith_movement = mvment_type
        subplot(3,3,ind2sub([3,3],sub2ind([3,3], find(ith_movement == mvment_type), find(i == [2,4,5])))); hold on
        histogram(cur_bat_table_1(string(cur_bat_table_1.movement_type) == ith_movement,:).raw_tx,[7.5e4:100:8.5e4], 'Normalization','probability')
        histogram(cur_bat_table_2(cur_bat_table_2.movement_type == ith_movement,:).raw_tx,[7.5e4:100:8.5e4], 'Normalization','probability')
        histogram(cur_bat_table_2(cur_bat_table_2.movement_type == ith_movement,:).rx_freq,[7.5e4:100:8.5e4], 'Normalization','probability')
        title(sprintf("bat %i, %s", i, ith_movement))
    legend(["tx static","tx movment","rx movement"])
    end


%     legend(["tx static","tx movment","rx movement"])
    xlabel("Freq[Hz]")
end
fig_name = "hist per bat per movement of tx and rx when echo detected and where static";
sgtitle(fig_name)
savefig(gcf, fullfile(figs_path,fig_name))

