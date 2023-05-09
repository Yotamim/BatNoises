% close all
clear
analyzie_aggregate_results
bat_nums = [2,4,5];
n_windows = [2,3,4,5];
n_windows = 2;
ststst = GetStaticFreq(res_table_2_peaks);
res_table_2_peaks = renamevars(res_table_2_peaks, "ten_times_span_rx", "max_doppler");
what_featuers_to_use = {{"echo_doppler"},{"tx_freq_from_filtered_tx_fft"},{"echo_doppler", "tx_freq_from_filtered_tx_fft"}, ...
    {"echo_doppler", "speed", "tx_freq_from_filtered_tx_fft"}, ...
    {"echo_doppler", "speed", "durations"},...
    {"max_doppler"}, ...
    {"max_doppler", "speed"}, ...
    {"max_doppler", "speed", "durations"}};
prediction_name = "tx_freq";
% prediction_name = "tx_freq_diff";
% prediction_name = "weird";
model_type = "linear";
% model_type = "quadratic";
temp_rsq_array = zeros(length(what_featuers_to_use), length(bat_nums)).';
for jth_features_comb = what_featuers_to_use
    jth_features_comb = jth_features_comb{1};
    for n_window = n_windows
        threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,81000], "rx_freq", [78000,82500], "durations", [0,0.15]);
        cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, n_window);
        inds_passing_thresholds = GetValidIndsForModelFromSignalPro(threshold_dict_sig, res_table_2_peaks);

        figure;
        for bat_num = bat_nums
            [X, y, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
                ContIndsAndFeatures2XData(res_table_2_peaks, threshold_dict_sig, cont_inds_cell,...
                jth_features_comb, n_window, bat_num, prediction_name);
            MarkEchoTypeThings(X)
            vaild_inds = vaild_inds(:,1);
            y_for_plot = sum(y,2);
%             X(:,3) = X(:,3)+X(:,4)-ststst.bat5;
            [pred_vals, coef_table,bic_val,mdl] =  GLMPredict(X(vaild_inds,:),y(vaild_inds,1), model_type);
            subplot(2,3,find(bat_num == bat_nums))
            
            plot(y(vaild_inds,1), "."); hold on
            plot(pred_vals, ".")
            title_str = [];
            title_str = sprintf("bat %.f, BIC = %.2e, #prev calls = %.f\n used ", bat_num, bic_val,n_window-1);
            for i = 1:length(jth_features_comb)
                title_str = title_str + replace(jth_features_comb{i}, "_", " ")+", ";
            end
            title(extractBefore(title_str,strlength(title_str)-1))
            var_names_for_table = cell(height(coef_table),1);
            var_names_for_table(1:length(var_names)) = var_names.';
            coef_table.VarNames = var_names_for_table;
            subplot(2,3,find(bat_num == bat_nums)+3)
            scatter(y(vaild_inds,1), y(vaild_inds,1)-pred_vals, "."); axis equal
            set(gcf,"UserData", [get(gcf, "UserData"); [{bat_num}, {coef_table},{bic_val},{n_window-1}]]);
            set(gca, "UserData", [{cont_inds_as_rows_passing_thrsholds},{vaild_inds},...
                {X(vaild_inds,:)},{y(vaild_inds)} {bat_num}])
%             disp(mean(abs(y(vaild_inds,1)-pred_vals)))
%             disp(sqrt(var(y(vaild_inds,1)-pred_vals)))
            disp(mdl.Rsquared.Ordinary)
            k = find(temp_rsq_array == 0);
            temp_rsq_array(k(1)) = mdl.Rsquared.Ordinary;
        end
        aaa = get(gcf, "UserData");
        %         save_str = "C:\Users\yotam\Desktop\figs1\"+ join([jth_features_comb{:}],"_")+"_"+num2str(n_window-1);
        %         savefig(gcf, save_str)
        temp_rsq_array = temp_rsq_array.';
        close
        temp_rsq_array = temp_rsq_array.';
    end
end


%             plot(y_for_plot(vaild_inds), "."); hold on
%             plot(pred_vals+y(vaild_inds,2), "."); hold on
%             err_bar = y_for_plot(vaild_inds)-pred_vals-y(vaild_inds,2);
%             errorbar(pred_vals+y(vaild_inds,2),err_bar, "vertical", "o")
%             [xy_corr, pval] = Hist2dAsImage(pred_vals, pred_vals-y(vaild_inds,1),...
%                 [150,150], 1, 1);
%             scatter(y_for_plot(vaild_inds), pred_vals+y(vaild_inds,2), ".")
%             ylabel("tx freq")
%             xlabel("predicted tx freq")
%             xlim = get(gca, "XLim");
%             ylim = get(gca, "YLim");
%             hold on; plot(xlim(1):xlim(2), xlim(1):xlim(2), "m")
