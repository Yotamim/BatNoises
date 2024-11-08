clear
% figs_path = "C:\Users\yotam\Desktop\Figures\Bats\for_thesis\";
figs_path = "C:\Users\yotam\Desktop\for_yossi_table_thesis\figs";
data_preperation_script
threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,81000], "rx_freq", [76500,82000], "durations", [0,0.15]);
inds_passing_thresholds = GetValidIndsForModelFromSignalPro(threshold_dict_sig, res_table_2_peaks);

res_table_2_peaks = res_table_2_peaks(inds_passing_thresholds,:);
res_table_1_peak = res_table_1_peak(7.85e4 <= res_table_1_peak.raw_tx & res_table_1_peak.raw_tx <= 8.05e4,:);
res_table_1_peak = res_table_1_peak(~(res_table_1_peak.bat_num == 5 & res_table_1_peak.raw_tx <= 7.95e4 ),:);

mvmet_types_yossi = ["vertical", "horizontal", "perching"];
mvmet_types = ["woods", "field", "hunting"];

old_mvmnt = res_table_2_peaks.movement_type; new_mvmnt = old_mvmnt;
new_mvmnt(new_mvmnt== "hunting") = "woods";
res_table_2_peaks.movement_type = new_mvmnt;

old_mvmnt = res_table_1_peak.movement_type; new_mvmnt = string(old_mvmnt);
new_mvmnt(new_mvmnt== "hunting") = "woods"; new_mvmnt(new_mvmnt== "trees") = "woods"; new_mvmnt(new_mvmnt== "fields") = "field"; new_mvmnt(new_mvmnt== "water") = "field";
res_table_1_peak.movement_type = new_mvmnt;

%% hist per bat of tx freq when echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).tx_freq_from_filtered_tx_fft;
    histogram(cur_bat_tx_freqs,[7.5e4:100:8.5e4], 'Normalization','probability')
end
fig_name = "hist per bat of tx freq when echo detected";
title(fig_name)
legend("2","4","5")
xlabel("tx freq [Hz]")
ylabel("probability")
% savefig(gcf, fullfile(figs_path,fig_name))

%% hist per bat of tx freq when no echo detected
close all
figure; hold on
mean_static_freq = [];
std_static_freq  = [];
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_1_peak(res_table_1_peak.bat_num == i,:).raw_tx;
    mean_static_freq = [mean_static_freq, mean(cur_bat_tx_freqs)];
    std_static_freq = [std_static_freq , std(cur_bat_tx_freqs)];
    histogram(cur_bat_tx_freqs, [7.8e4:50:8.1e4], 'Normalization','probability')
end
fig_name = "hist per bat of tx freq when no echo detected";
title(fig_name)
legend("2","4","5")
xlabel("Resting frequency[Hz]")
ylabel("Normalized histogram")
% savefig(gcf, fullfile(figs_path,fig_name))

%% hist per bat of tx freq when echo detected, per movement type, per bat
figure;
tbl_for_thesis = zeros(2,6);

for i = [2,4,5]
    ind_c = find(i == [2,4,5]);
    subplot(1,3,find(i == [2,4,5])); hold on
    leg_str = [];
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    if i == 2
        cur_bat_table = cur_bat_table(cur_bat_table.tx_freq_from_filtered_tx_fft <= 7.88e4, :);
    end
    for ith_movement = ["woods", "field"]
        ind_r = find(ith_movement == ["woods", "field"]);
        tx_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).tx_freq_from_filtered_tx_fft;
        histogram(tx_of_movement_type,[7.5e4:100:8.5e4], 'Normalization','probability')
        leg_str = [leg_str, (mvmet_types_yossi(ith_movement == mvmet_types))];
        tbl_for_thesis(ind_r, ind_c*2-1) = median(tx_of_movement_type);
        tbl_for_thesis(ind_r, ind_c*2) = std(tx_of_movement_type);
    end
    legend(leg_str)
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat per movement type of tx freq when echo detected";
sgtitle(fig_name)
% savefig(gcf, fullfile(figs_path,fig_name))
tbl_for_thesis = round(tbl_for_thesis);
tbl_for_thesis(tbl_for_thesis >= 1e3) = tbl_for_thesis(tbl_for_thesis >= 1e3)/1e3;
%% hist per bat of echo when echo detected
figure; hold on
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_freq;
    histogram(cur_bat_tx_freqs,[7.8e4:100:8.1e4], 'Normalization','probability')
end
fig_name = "hist per bat of rx when echo detected";
title(fig_name)
legend("2","4","5")
% savefig(gcf, fullfile(figs_path,fig_name))


%% hist per bat of rx var when echo detected
figure; hold on
tbl_for_thesis = zeros(2,6);
for i = [2,4,5]
    cur_bat_tx_freqs = res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_var;
    histogram(cur_bat_tx_freqs,[100:5:800],'Normalization','probability')
end
fig_name = "hist per bat of rx var when echo detected";
title(fig_name)
legend("2","4","5")
% savefig(gcf, fullfile(figs_path,fig_name))

%% hist per bat of rx var when echo detected, per movement type, per bat
figure;
tbl_for_thesis = zeros(2,6);
for i = [2,4,5]
    ind_c = find(i == [2,4,5]);
    leg_str = [];
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = ["woods", "field"]
        ind_r = find(ith_movement == ["woods", "field"]);
        rx_var_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).rx_var;
        histogram(rx_var_of_movement_type, [100:50:800], 'Normalization','probability')
        leg_str = [leg_str, (mvmet_types_yossi(ith_movement == mvmet_types))];
        tbl_for_thesis(ind_r, ind_c*2-1) = median(rx_var_of_movement_type);
    end
    legend(leg_str)
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat of rx var when echo detected per movement type per bat";
sgtitle(fig_name)
tbl_for_thesis = round(tbl_for_thesis);

% savefig(gcf, fullfile(figs_path,fig_name))


%% hist of delay per bat per movement type when echo detected
figure;
leg_str = [];
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = ["woods", "field"]
        if ith_movement == "hunting"
            continue
        end
        delay_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).delay;
        histogram(delay_of_movement_type, [0.001:0.001:0.04], 'Normalization','probability')
        leg_str = [leg_str, (mvmet_types_yossi(ith_movement == mvmet_types))];
    end
    legend(leg_str)
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat of delay when echo detected per movement type per bat";
sgtitle(fig_name)
savefig(gcf, fullfile(figs_path,fig_name))

%% hist of speed per bat  per movement type when echo detected
figure;
leg_str = [];
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = ["woods", "field"]
        speed_of_movement_type = cur_bat_table((cur_bat_table.movement_type == ith_movement) & (~isnan(cur_bat_table.speed)),:).speed;
        if ith_movement == "woods"
            speed_of_movement_type = speed_of_movement_type(speed_of_movement_type >= 1.5);
        end
        histogram(speed_of_movement_type , [0:0.5:10], 'Normalization','probability')
        leg_str = [leg_str, (mvmet_types_yossi(ith_movement == mvmet_types))];
    end
    legend(leg_str)
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat of speed per movement type per bat";
sgtitle(fig_name)

%% hist per bat of tx and rx per movement type per bat
fig1 = figure;
titles = [];
axess = [];
for i = [2,4,5]
    cur_bat_table_2 = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = ["woods", "field"]
        axess = [axess,subplot(3,3,ind2sub([3,3],sub2ind([3,3], find(ith_movement == mvment_type), find(i == [2,4,5]))))]; hold on
        histogram(cur_bat_table_2(cur_bat_table_2.movement_type == ith_movement,:).tx_freq_from_filtered_tx_fft,[7.5e4:100:8.5e4], 'Normalization','probability')
        histogram(cur_bat_table_2(cur_bat_table_2.movement_type == ith_movement,:).rx_freq,[7.5e4:100:8.5e4], 'Normalization','probability')
        titles = [titles,(sprintf("bat%i, %s", i, mvmet_types_yossi(ith_movement == mvmet_types)))];
        legend(["tx movment","rx movement"])
    end
end

ax_to_del = [];
fig2 = figure;
for i = 1:6
    ax_to_del = [ax_to_del, subplot(3,2,i)];
    pos_ax = get(ax_to_del(i), "Position");
    ax2 = copyobj(axess(i),fig2);
    set(ax2, "Position", pos_ax);
    set(ax2, "Title", title(titles(i)))
end
for i = 1:length(ax_to_del)
    delete(ax_to_del)
end
fig_name = "hist per bat of tx and rx per movement type per bat";
sgtitle(fig_name)
%% hist of max dop per bat per movement type when echo detected
figure;
for i = [2,4,5]
    subplot(1,3,find(i == [2,4,5])); hold on
    cur_bat_table = res_table_2_peaks(res_table_2_peaks.bat_num == i,:);
    for ith_movement = unique(cur_bat_table.movement_type).'
        max_dop_of_movement_type = cur_bat_table(cur_bat_table.movement_type == ith_movement,:).max_doppler;
        if i == 5 || i == 4
            histogram(max_dop_of_movement_type, [7.8:0.02:8.2]*1e4, 'Normalization','probability')
        else
            histogram(max_dop_of_movement_type, [7.8:0.02:8.1]*1e4, 'Normalization','probability')
        end
    end
    legend(unique(cur_bat_table.movement_type).')
    title(sprintf("bat %i", i))
end
fig_name = "hist per bat of max dop per movement type per bat";
sgtitle(fig_name)


%% hist per bat of tx and rx when echo detected and where static
mean_tx_movement = [];
std_tx_movement = [];
mean_rx_movement = [];
std_rx_movement = [];
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
    mean_tx_movement = [mean_tx_movement, mean(cur_bat_table_2.tx_freq_from_filtered_tx_fft)];
    std_tx_movement = [std_tx_movement, std(cur_bat_table_2.tx_freq_from_filtered_tx_fft)];
    mean_rx_movement = [mean_rx_movement, mean(cur_bat_table_2.rx_freq)];
    std_rx_movement = [std_rx_movement, std(cur_bat_table_2.rx_freq)];
    histogram(cur_bat_table_1.raw_tx,[7.5e4:100:8.5e4], 'Normalization','probability')
    histogram(cur_bat_table_2.tx_freq_from_filtered_tx_fft,[7.5e4:100:8.5e4], 'Normalization','probability')
    histogram(cur_bat_table_2.rx_freq,[7.5e4:100:8.5e4], 'Normalization','probability')
    title(sprintf("bat %i", i))
    legend(["tx static","tx movment","rx movement"])
    xlabel("Freq[Hz]")
end
fig_name = "hist per bat of tx and rx when echo detected and where static";
sgtitle(fig_name)
% savefig(gcf, fullfile(figs_path,fig_name))
mean_tx_movement = round(mean_tx_movement)/1e3;
std_tx_movement = round(std_tx_movement);
mean_rx_movement = round(mean_rx_movement)/1e3;
std_rx_movement = round(std_rx_movement);

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
% savefig(gcf, fullfile(figs_path,fig_name))

%% hist per bat of tx and max dop when echo detected and where static
cell_for_table_for_yossi = cell(2,3);
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
    cell_for_table_for_yossi{i == [2,4,5],1} = mean(cur_bat_table_1.raw_tx);
    cell_for_table_for_yossi{i == [2,4,5],2} = mean(cur_bat_table_2.max_doppler);
    cell_for_table_for_yossi{i == [2,4,5],3} = i;
    histogram(cur_bat_table_1.raw_tx,[7.5e4:50:8.5e4], 'Normalization','probability')
    %     histogram(cur_bat_table_2.tx_freq_from_filtered_tx_fft,[7.5e4:100:8.5e4], 'Normalization','probability')
    histogram(cur_bat_table_2.max_doppler,[7.5e4:50:8.5e4], 'Normalization','probability')
    title(sprintf("bat %i", i))
    legend(["tx static","max dop"]) %"tx movment",
    xlabel("Freq[Hz]")
end
fig_name = "hist per bat of tx and max dop when echo detected and where static";
sgtitle(fig_name)
% savefig(gcf, fullfile(figs_path,fig_name))
% writetable(cell2table(cell_for_table_for_yossi,"VariableNames",["mean_static_tx", "mean_max_dop", "bat num"]), ...
%     "C:\Users\yotam\Desktop\for_yossi_table_thesis\dop_static_tx_mean_table.xlsx")
%% plot tx rx max per mvmnt and vat - 9 panels
close all
ax_to_del = [];
figure;
bats = [2,4,5];
for bat = bats
    for mvmet_type = mvmet_types
        i = sub2ind([3,3], find(contains(mvmet_types,mvmet_type)), find(bat == bats));
        ax = subplot(3,3,i); hold on
        cur_bat_table_2 = res_table_2_peaks(res_table_2_peaks.bat_num == bat & res_table_2_peaks.movement_type == mvmet_type,:);
        histogram(cur_bat_table_2.tx_freq_from_filtered_tx_fft,[7.5e4:100:8.5e4], 'Normalization','probability')
        histogram(cur_bat_table_2.rx_freq,[7.5e4:100:8.5e4], 'Normalization','probability')
        histogram(cur_bat_table_2.max_doppler,[7.5e4:100:8.5e4], 'Normalization','probability')
        legend(["tx","rx","max rx"])
        title(sprintf("bat%i, %s", bat, mvmet_type))
    end
end

A = get(gcf, "Children");
delete(A(1))

for ith_ax = 1:length(ax_to_del)
    delete(ax_to_del(ith_ax))
end
sgtitle("Coefficiant of max doppler diff for different seq length")

%% tx vs next tx
clear;
data_preperation_script
threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [77000,81000], "rx_freq", [78500,82000], "durations", [0,0.15]);

prediction_name = "tx_freq";
features = {"tx_freq_from_filtered_tx_fft", "speed"};
cell_all_tx_next_tx = {};
for bat_num = [2,4,5]
    cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, 2);
    cur_2_peaks_table = res_table_2_peaks(any([cont_inds_cell{:}], 2), :);
    cur_all_tx_time = all_tx_time(any([cont_inds_cell{:}], 2));
    for ith_window = 2
        n_window = ith_window;
        cont_inds_cell = GetNContinuesInds(cur_all_tx_time,cur_2_peaks_table.bat_num, n_window);
        [X_lsboost, y_lsboost, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
            ContIndsAndFeatures2XData(cur_2_peaks_table, threshold_dict_sig, cont_inds_cell,...
            features, n_window, bat_num, prediction_name);
        vaild_inds = vaild_inds(:,1);
        y = y_lsboost(:,1);

        var_names{end+1} = prediction_name;
        X_table = array2table([X_lsboost(vaild_inds,:),y(vaild_inds,:)],'VariableNames',string(var_names(2:end).'));
        cell_all_tx_next_tx{end+1} = X_table;
    end
end
%%
figure;
bats = [2,4,5];
for i = 1:length(bats)
    subplot(1,3,i); hold on
    x = cell_all_tx_next_tx{i}.("tx_freq_from_filtered_tx_fft-1");
    y = cell_all_tx_next_tx{i}.tx_freq;
    [xy_corr, ~] = Hist2dAsImage(x, y, [100,100], 0, 100);
    [~,prc_idx_low] = min(abs(prctile(x, 5)-x)); [~,prc_idx_high] = min(abs(prctile(x, 99.5)-x));
    
    plot([x(prc_idx_low), x(prc_idx_high)], [x(prc_idx_low), x(prc_idx_high)], 'm', 'LineWidth',0.5)
    title(sprintf("tx vs next tx bat%i \n corr = %.2f", bats(i), xy_corr))
end
%%
figure;
bats = [2,4,5];
for i = 1:length(bats)
    subplot(1,3,i); hold on
    x = cell_all_tx_next_tx{i}.("speed-1");
    y = cell_all_tx_next_tx{i}.tx_freq;
    [xy_corr, ~] = Hist2dAsImage(x, y, [100,100], 0, 100);
    [~,prc_idx_low] = min(abs(prctile(x, 5)-x)); [~,prc_idx_high] = min(abs(prctile(x, 99.5)-x));
    
    plot([x(prc_idx_low), x(prc_idx_high)], [x(prc_idx_low), x(prc_idx_high)], 'm', 'LineWidth',0.5)
    title(sprintf("tx vs next tx bat%i \n corr = %.2f", bats(i), xy_corr))
end



